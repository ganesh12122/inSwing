from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from sqlalchemy import func, or_, and_, case
from typing import List, Optional
import structlog

from app.database import get_db
from app.dependencies import get_current_user
from app.models.user import User
from app.models.match import Match
from app.models.players_in_match import PlayersInMatch
from app.schemas import (
    UserSearchResponse,
    MatchSearchResponse,
    SearchResponse
)

logger = structlog.get_logger()
router = APIRouter()


@router.get("/users", response_model=List[UserSearchResponse])
async def search_users(
    query: str = Query(..., min_length=1, max_length=100, description="Search query for users"),
    limit: int = Query(20, ge=1, le=50, description="Number of results to return"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Search for users by name or phone number."""
    
    # Search by name or phone (partial match)
    search_filter = or_(
        User.full_name.ilike(f"%{query}%"),
        User.phone_number.ilike(f"%{query}%")
    )
    
    users = db.query(User).filter(
        search_filter,
        User.is_active == True  # noqa: E712
    ).order_by(
        # Prioritize exact matches first
        case(
            (User.full_name.ilike(query), 1),
            (User.phone_number.ilike(query), 1),
            else_=2
        ),
        # Then sort by name similarity
        func.length(User.full_name),
        User.full_name
    ).limit(limit).all()
    
    logger.info("User search performed", 
                query=query,
                limit=limit,
                results_count=len(users),
                user_id=current_user.id)
    
    return users


@router.get("/matches", response_model=List[MatchSearchResponse])
async def search_matches(
    query: str = Query(..., min_length=1, max_length=100, description="Search query for matches"),
    status_filter: Optional[str] = Query(None, description="Filter by match status"),
    limit: int = Query(20, ge=1, le=50, description="Number of results to return"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Search for matches by venue or team names."""
    
    # Build search filter — Match has no 'title', search by team names and venue
    search_filter = or_(
        Match.venue.ilike(f"%{query}%"),
        Match.team_a_name.ilike(f"%{query}%"),
        Match.team_b_name.ilike(f"%{query}%")
    )
    
    # Add status filter if provided
    filters = [search_filter]
    if status_filter:
        filters.append(Match.status == status_filter)
    
    matches = db.query(Match).filter(*filters).order_by(
        # Prioritize venue matches first
        case((Match.venue.ilike(query), 1), else_=2),
        # Then sort by creation date (newest first)
        Match.created_at.desc()
    ).limit(limit).all()
    
    logger.info("Match search performed", 
                query=query,
                status_filter=status_filter,
                limit=limit,
                results_count=len(matches),
                user_id=current_user.id)
    
    return matches


@router.get("/combined", response_model=SearchResponse)
async def combined_search(
    query: str = Query(..., min_length=1, max_length=100, description="Search query"),
    include_users: bool = Query(True, description="Include users in search results"),
    include_matches: bool = Query(True, description="Include matches in search results"),
    limit_per_type: int = Query(10, ge=1, le=25, description="Number of results per type"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Combined search for users and matches."""
    
    results = {
        "users": [],
        "matches": [],
        "query": query,
        "total_results": 0
    }
    
    if include_users:
        # Search users
        user_filter = or_(
            User.full_name.ilike(f"%{query}%"),
            User.phone_number.ilike(f"%{query}%")
        )
        
        users = db.query(User).filter(
            user_filter,
            User.is_active == True  # noqa: E712
        ).order_by(
            case(
                (User.full_name.ilike(query), 1),
                (User.phone_number.ilike(query), 1),
                else_=2
            ),
            func.length(User.full_name),
            User.full_name
        ).limit(limit_per_type).all()
        
        results["users"] = users
    
    if include_matches:
        # Search matches
        match_filter = or_(
            Match.venue.ilike(f"%{query}%"),
            Match.team_a_name.ilike(f"%{query}%"),
            Match.team_b_name.ilike(f"%{query}%")
        )
        
        matches = db.query(Match).filter(match_filter).order_by(
            case((Match.venue.ilike(query), 1), else_=2),
            Match.created_at.desc()
        ).limit(limit_per_type).all()
        
        results["matches"] = matches
    
    results["total_results"] = len(results["users"]) + len(results["matches"])
    
    logger.info("Combined search performed", 
                query=query,
                include_users=include_users,
                include_matches=include_matches,
                limit_per_type=limit_per_type,
                total_results=results["total_results"],
                user_id=current_user.id)
    
    return results


@router.get("/suggestions")
async def get_search_suggestions(
    query: str = Query(..., min_length=1, max_length=50, description="Partial search query"),
    limit: int = Query(10, ge=1, le=20, description="Number of suggestions"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get search suggestions based on partial query."""
    
    suggestions = []
    
    # Get user name suggestions
    user_names = db.query(User.full_name).filter(
        User.full_name.ilike(f"%{query}%"),
        User.is_active == True  # noqa: E712
    ).distinct().order_by(
        func.length(User.full_name),
        User.full_name
    ).limit(limit // 2).all()
    
    suggestions.extend([name[0] for name in user_names])
    
    # Get venue suggestions (Match has no 'title' column)
    venues = db.query(Match.venue).filter(
        Match.venue.ilike(f"%{query}%"),
        Match.venue.isnot(None)
    ).distinct().order_by(
        func.length(Match.venue),
        Match.venue
    ).limit(limit // 2).all()
    
    suggestions.extend([venue[0] for venue in venues if venue[0]])
    
    # Get team name suggestions
    team_a_names = db.query(Match.team_a_name).filter(
        Match.team_a_name.ilike(f"%{query}%")
    ).distinct().limit(limit // 4).all()
    
    team_b_names = db.query(Match.team_b_name).filter(
        Match.team_b_name.ilike(f"%{query}%")
    ).distinct().limit(limit // 4).all()
    
    suggestions.extend([name[0] for name in team_a_names if name[0]])
    suggestions.extend([name[0] for name in team_b_names if name[0]])
    
    # Remove duplicates and limit
    suggestions = list(set(suggestions))[:limit]
    suggestions.sort()
    
    logger.info("Search suggestions generated", 
                query=query,
                limit=limit,
                suggestions_count=len(suggestions),
                user_id=current_user.id)
    
    return {"suggestions": suggestions}


@router.get("/popular-searches")
async def get_popular_searches(
    limit: int = Query(10, ge=1, le=20, description="Number of popular searches"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get popular search terms based on user activity."""
    
    popular_terms = []
    
    # Get most active user names
    active_users = db.query(User.full_name).join(
        PlayersInMatch, PlayersInMatch.user_id == User.id
    ).join(
        Match, Match.id == PlayersInMatch.match_id
    ).filter(
        Match.status == 'finished',
        User.is_active == True  # noqa: E712
    ).group_by(
        User.full_name
    ).order_by(
        func.count(PlayersInMatch.id).desc()
    ).limit(limit // 2).all()
    
    popular_terms.extend([user[0] for user in active_users])
    
    # Get most common match venues
    common_venues = db.query(Match.venue).filter(
        Match.venue.isnot(None),
        Match.status == 'finished'
    ).group_by(
        Match.venue
    ).order_by(
        func.count(Match.id).desc()
    ).limit(limit // 2).all()
    
    popular_terms.extend([venue[0] for venue in common_venues if venue[0]])
    
    # Remove duplicates and limit
    popular_terms = list(set(popular_terms))[:limit]
    popular_terms.sort()
    
    logger.info("Popular searches retrieved", 
                limit=limit,
                terms_count=len(popular_terms),
                user_id=current_user.id)
    
    return {"popular_searches": popular_terms}
