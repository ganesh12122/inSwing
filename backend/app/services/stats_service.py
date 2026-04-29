"""Stats service — aggregate player statistics from match ball data."""

import structlog
from sqlalchemy import select, func as sa_func
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.ball import Ball
from app.models.innings import Innings
from app.models.match import Match
from app.models.players_in_match import PlayersInMatch
from app.models.profile import Profile

logger = structlog.get_logger()


class StatsService:
    """Aggregate and update player profile statistics after a match."""

    async def update_player_stats_for_match(
        self, match_id: str, db: AsyncSession
    ) -> int:
        """Recalculate stats for all players in a finished match.

        Returns the number of profiles updated.
        """
        # Get all innings and balls for this match
        innings_result = await db.execute(
            select(Innings).where(Innings.match_id == match_id)
        )
        all_innings = innings_result.scalars().all()
        innings_ids = [i.id for i in all_innings]

        if not innings_ids:
            return 0

        # Get all balls
        balls_result = await db.execute(
            select(Ball).where(Ball.innings_id.in_(innings_ids))
        )
        all_balls = balls_result.scalars().all()

        # Get all players in the match
        players_result = await db.execute(
            select(PlayersInMatch).where(
                PlayersInMatch.match_id == match_id,
                PlayersInMatch.is_guest == False,  # noqa: E712 — SQLAlchemy needs ==
                PlayersInMatch.user_id.isnot(None),
            )
        )
        players = players_result.scalars().all()

        updated = 0
        for player in players:
            user_id = player.user_id
            if not user_id:
                continue

            # Get or create profile
            profile_result = await db.execute(
                select(Profile).where(Profile.user_id == user_id)
            )
            profile = profile_result.scalars().first()
            if not profile:
                profile = Profile(user_id=user_id)
                db.add(profile)
                await db.flush()

            # Calculate batting stats from balls where this user was batsman
            batting_balls = [b for b in all_balls if b.batsman_id == user_id]
            match_runs = sum(b.runs_off_bat for b in batting_balls)
            match_balls_faced = sum(1 for b in batting_balls if b.is_legal_delivery)

            # Calculate bowling stats from balls where this user was bowler
            bowling_balls = [b for b in all_balls if b.bowler_id == user_id]
            match_runs_conceded = sum(b.total_runs for b in bowling_balls)
            match_balls_bowled = sum(1 for b in bowling_balls if b.is_legal_delivery)
            match_wickets = sum(1 for b in bowling_balls if b.wicket_type is not None)

            # Update cumulative totals
            profile.total_matches = (profile.total_matches or 0) + 1
            profile.total_runs = (profile.total_runs or 0) + match_runs
            profile.total_balls_faced = (
                profile.total_balls_faced or 0
            ) + match_balls_faced
            profile.total_wickets = (profile.total_wickets or 0) + match_wickets
            profile.total_balls_bowled = (
                profile.total_balls_bowled or 0
            ) + match_balls_bowled
            profile.total_runs_conceded = (
                profile.total_runs_conceded or 0
            ) + match_runs_conceded

            # Recalculate derived stats
            if profile.total_balls_faced and profile.total_balls_faced > 0:
                profile.strike_rate = round(
                    (profile.total_runs / profile.total_balls_faced) * 100, 2
                )

            if profile.total_matches and profile.total_matches > 0:
                profile.average_runs = round(
                    profile.total_runs / profile.total_matches, 2
                )

            if profile.total_balls_bowled and profile.total_balls_bowled > 0:
                overs_bowled = profile.total_balls_bowled / 6
                profile.economy_rate = (
                    round(profile.total_runs_conceded / overs_bowled, 2)
                    if overs_bowled > 0
                    else 0.0
                )

            if profile.total_wickets and profile.total_wickets > 0:
                profile.bowling_average = round(
                    profile.total_runs_conceded / profile.total_wickets, 2
                )

            updated += 1

        await db.flush()
        logger.info("Player stats updated", match_id=match_id, players_updated=updated)
        return updated


stats_service = StatsService()
