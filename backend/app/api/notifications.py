from datetime import datetime, timedelta
from typing import List, Optional

import structlog
from app.database import get_async_db
from app.dependencies import get_current_user
from app.models.notification import Notification
from app.models.user import User
from app.schemas import NotificationCreate, NotificationResponse, NotificationStatus
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

logger = structlog.get_logger()
router = APIRouter()


@router.get("/", response_model=List[NotificationResponse])
async def get_notifications(
    status_filter: Optional[NotificationStatus] = Query(
        None, description="Filter by notification status"
    ),
    limit: int = Query(
        50, ge=1, le=200, description="Number of notifications to return"
    ),
    db: AsyncSession = Depends(get_async_db),
    current_user: User = Depends(get_current_user),
):
    """Get notifications for the current user."""

    statement = select(Notification).where(Notification.user_id == current_user.id)

    if status_filter:
        statement = statement.where(Notification.status == status_filter)  # type: ignore[arg-type]

    notifications_result = await db.execute(
        statement.order_by(Notification.created_at.desc()).limit(limit)
    )
    notifications = notifications_result.scalars().all()

    logger.info(
        "Notifications retrieved",
        user_id=current_user.id,
        status_filter=status_filter,
        limit=limit,
        count=len(notifications),
    )

    return notifications


@router.get("/unread-count")
async def get_unread_count(
    db: AsyncSession = Depends(get_async_db),
    current_user: User = Depends(get_current_user),
):
    """Get count of unread notifications."""

    count_result = await db.execute(
        select(func.count(Notification.id)).where(
            Notification.user_id == current_user.id,
            Notification.status == NotificationStatus.UNREAD,  # type: ignore[arg-type]
        )
    )
    count = int(count_result.scalar() or 0)

    logger.info(
        "Unread notification count retrieved", user_id=current_user.id, count=count
    )

    return {"unread_count": count}


@router.post("/", response_model=NotificationResponse)
async def create_notification(
    notification_data: NotificationCreate,
    db: AsyncSession = Depends(get_async_db),
    current_user: User = Depends(get_current_user),
):
    """Create a new notification (for testing/admin purposes)."""

    # Only admins can create notifications for other users
    if notification_data.user_id != current_user.id and current_user.role != "admin":  # type: ignore[truthy-bool]
        logger.warning(
            "Unauthorized notification creation attempt",
            user_id=current_user.id,
            target_user_id=notification_data.user_id,
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You can only create notifications for yourself",
        )

    notification = Notification(
        user_id=notification_data.user_id,
        title=notification_data.title,
        message=notification_data.message,
        type=notification_data.type,
        data=notification_data.data or {},
        priority=notification_data.priority,
        status=NotificationStatus.UNREAD,
        expires_at=notification_data.expires_at,
    )

    db.add(notification)
    await db.commit()
    await db.refresh(notification)

    logger.info(
        "Notification created",
        notification_id=notification.id,
        user_id=notification.user_id,
        type=notification.type,
        priority=notification.priority,
    )

    return notification


@router.put("/{notification_id}/read", response_model=NotificationResponse)
async def mark_notification_read(
    notification_id: str,
    db: AsyncSession = Depends(get_async_db),
    current_user: User = Depends(get_current_user),
):
    """Mark a notification as read."""

    notification_result = await db.execute(
        select(Notification).where(
            Notification.id == notification_id,
            Notification.user_id == current_user.id,
        )
    )
    notification = notification_result.scalars().first()

    if not notification:
        logger.warning(
            "Notification not found for read marking",
            notification_id=notification_id,
            user_id=current_user.id,
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Notification not found"
        )

    notification.status = NotificationStatus.READ
    notification.read_at = datetime.utcnow()

    await db.commit()
    await db.refresh(notification)

    logger.info(
        "Notification marked as read",
        notification_id=notification_id,
        user_id=current_user.id,
    )

    return notification


@router.put("/mark-all-read")
async def mark_all_notifications_read(
    db: AsyncSession = Depends(get_async_db),
    current_user: User = Depends(get_current_user),
):
    """Mark all notifications as read."""

    unread_result = await db.execute(
        select(Notification).where(
            Notification.user_id == current_user.id,
            Notification.status == NotificationStatus.UNREAD,  # type: ignore[arg-type]
        )
    )
    unread_notifications = unread_result.scalars().all()
    for item in unread_notifications:
        item.status = NotificationStatus.READ
        item.read_at = datetime.utcnow()
    updated_count = len(unread_notifications)

    await db.commit()

    logger.info(
        "All notifications marked as read",
        user_id=current_user.id,
        updated_count=updated_count,
    )

    return {"message": f"{updated_count} notifications marked as read"}


@router.delete("/{notification_id}")
async def delete_notification(
    notification_id: str,
    db: AsyncSession = Depends(get_async_db),
    current_user: User = Depends(get_current_user),
):
    """Delete a notification."""

    notification_result = await db.execute(
        select(Notification).where(
            Notification.id == notification_id,
            Notification.user_id == current_user.id,
        )
    )
    notification = notification_result.scalars().first()

    if not notification:
        logger.warning(
            "Notification not found for deletion",
            notification_id=notification_id,
            user_id=current_user.id,
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Notification not found"
        )

    db.delete(notification)
    await db.commit()

    logger.info(
        "Notification deleted", notification_id=notification_id, user_id=current_user.id
    )

    return {"message": "Notification deleted successfully"}


@router.delete("/cleanup-old")
async def cleanup_old_notifications(
    days_old: int = Query(
        30, ge=1, le=365, description="Delete notifications older than this many days"
    ),
    db: AsyncSession = Depends(get_async_db),
    current_user: User = Depends(get_current_user),
):
    """Delete old notifications for the current user."""

    cutoff_date = datetime.utcnow() - timedelta(days=days_old)

    old_result = await db.execute(
        select(Notification).where(
            Notification.user_id == current_user.id,
            Notification.created_at < cutoff_date,
            Notification.status == NotificationStatus.READ,  # type: ignore[arg-type]
        )
    )
    old_notifications = old_result.scalars().all()
    deleted_count = len(old_notifications)
    for item in old_notifications:
        await db.delete(item)

    await db.commit()

    logger.info(
        "Old notifications cleaned up",
        user_id=current_user.id,
        days_old=days_old,
        deleted_count=deleted_count,
    )

    return {"message": f"{deleted_count} old notifications deleted"}


@router.post("/send-match-invitation")
async def send_match_invitation_notification(
    match_id: str,
    user_ids: List[str],
    db: AsyncSession = Depends(get_async_db),
    current_user: User = Depends(get_current_user),
):
    """Send match invitation notifications to multiple users."""

    # Verify the user is hosting the match
    from app.models.match import Match

    match_result = await db.execute(select(Match).where(Match.id == match_id))
    match = match_result.scalars().first()
    if not match:
        logger.warning(
            "Match not found for invitation", match_id=match_id, user_id=current_user.id
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Match not found"
        )

    if match.host_user_id != current_user.id:  # type: ignore[truthy-bool]
        logger.warning(
            "Unauthorized match invitation",
            match_id=match_id,
            user_id=current_user.id,
            host_id=match.host_user_id,
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only the match host can send invitations",
        )

    notifications_created = []

    for user_id in user_ids:
        # Check if user exists
        invited_user_result = await db.execute(select(User).where(User.id == user_id))
        invited_user = invited_user_result.scalars().first()
        if not invited_user:
            logger.warning(
                "User not found for invitation",
                user_id=user_id,
                inviter_id=current_user.id,
            )
            continue

        # Create invitation notification
        notification = Notification(
            user_id=user_id,
            title="Match Invitation",
            message=f"{current_user.full_name} invited you to join a cricket match",
            type="match_invitation",
            data={
                "match_id": match_id,
                "host_id": current_user.id,
                "host_name": current_user.full_name,
                "invited_at": datetime.utcnow().isoformat(),
            },
            priority="high",
            status=NotificationStatus.UNREAD,
            expires_at=datetime.utcnow() + timedelta(hours=24),  # Expires in 24 hours
        )

        db.add(notification)
        notifications_created.append(notification)

    await db.commit()

    for notification in notifications_created:
        await db.refresh(notification)

    logger.info(
        "Match invitation notifications sent",
        match_id=match_id,
        host_id=current_user.id,
        invited_users_count=len(notifications_created),
        invited_users=[n.user_id for n in notifications_created],
    )

    return {
        "message": f"Invitations sent to {len(notifications_created)} users",
        "notifications": notifications_created,
    }


@router.post("/send-match-update")
async def send_match_update_notification(
    match_id: str,
    message: str,
    priority: str = "medium",
    db: AsyncSession = Depends(get_async_db),
    current_user: User = Depends(get_current_user),
):
    """Send match update notifications to all players in the match."""

    # Verify the user is hosting the match
    from app.models.match import Match
    from app.models.players_in_match import PlayersInMatch

    match_result = await db.execute(select(Match).where(Match.id == match_id))
    match = match_result.scalars().first()
    if not match:
        logger.warning(
            "Match not found for update notification",
            match_id=match_id,
            user_id=current_user.id,
        )
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Match not found"
        )

    if match.host_user_id != current_user.id:  # type: ignore[truthy-bool]
        logger.warning(
            "Unauthorized match update notification",
            match_id=match_id,
            user_id=current_user.id,
            host_id=match.host_user_id,
        )
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only the match host can send match updates",
        )

    # Get all players in the match (excluding the host)
    players_result = await db.execute(
        select(PlayersInMatch).where(
            PlayersInMatch.match_id == match_id,
            PlayersInMatch.user_id != current_user.id,
        )
    )
    players = players_result.scalars().all()

    notifications_created = []

    for player in players:
        notification = Notification(
            user_id=player.user_id,
            title="Match Update",
            message=message,
            type="match_update",
            data={
                "match_id": match_id,
                "host_id": current_user.id,
                "host_name": current_user.full_name,
                "updated_at": datetime.utcnow().isoformat(),
            },
            priority=priority,
            status=NotificationStatus.UNREAD,
        )

        db.add(notification)
        notifications_created.append(notification)

    await db.commit()

    for notification in notifications_created:
        await db.refresh(notification)

    logger.info(
        "Match update notifications sent",
        match_id=match_id,
        host_id=current_user.id,
        players_notified=len(notifications_created),
        message=message,
        priority=priority,
    )

    return {
        "message": f"Match updates sent to {len(notifications_created)} players",
        "notifications": notifications_created,
    }
