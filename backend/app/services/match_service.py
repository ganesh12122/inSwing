"""Match service — match completion, winner calculation, and result finalization."""

from datetime import datetime
from typing import Optional

import structlog
from sqlalchemy import select, func as sa_func
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.ball import Ball
from app.models.innings import Innings
from app.models.match import Match

logger = structlog.get_logger()


class MatchService:
    """Business logic for match lifecycle operations."""

    async def complete_innings(self, innings: Innings, db: AsyncSession) -> Innings:
        """Mark an innings as completed."""
        innings.is_completed = True
        innings.completed_at = datetime.utcnow()
        await db.flush()
        logger.info(
            "Innings completed",
            innings_id=innings.id,
            runs=innings.runs,
            wickets=innings.wickets,
        )
        return innings

    async def calculate_match_result(
        self, match: Match, db: AsyncSession
    ) -> Optional[dict]:
        """Calculate match result from completed innings.

        Returns result dict or None if match isn't ready for result calculation.
        """
        # Fetch all innings for the match
        result = await db.execute(
            select(Innings)
            .where(Innings.match_id == match.id)
            .order_by(Innings.created_at)
        )
        all_innings = result.scalars().all()

        if len(all_innings) < 2:
            return None  # Need both innings

        first_innings = all_innings[0]
        second_innings = all_innings[1]

        # Both innings must be completed
        if not first_innings.is_completed or not second_innings.is_completed:
            return None

        first_team = first_innings.batting_team
        second_team = second_innings.batting_team

        first_runs = first_innings.runs
        second_runs = second_innings.runs

        match_result: dict

        if first_runs > second_runs:
            # First batting team won by runs
            match_result = {
                "winner": first_team,
                "winning_margin": first_runs - second_runs,
                "winning_type": "runs",
                "final_scores": {
                    first_team: {
                        "runs": first_runs,
                        "wickets": first_innings.wickets,
                        "overs": float(first_innings.overs_bowled),
                    },
                    second_team: {
                        "runs": second_runs,
                        "wickets": second_innings.wickets,
                        "overs": float(second_innings.overs_bowled),
                    },
                },
            }
        elif second_runs > first_runs:
            # Second batting team won by wickets remaining
            max_wickets = (match.rules or {}).get("max_players_per_team", 11) - 1
            wickets_remaining = max_wickets - second_innings.wickets
            match_result = {
                "winner": second_team,
                "winning_margin": wickets_remaining,
                "winning_type": "wickets",
                "final_scores": {
                    first_team: {
                        "runs": first_runs,
                        "wickets": first_innings.wickets,
                        "overs": float(first_innings.overs_bowled),
                    },
                    second_team: {
                        "runs": second_runs,
                        "wickets": second_innings.wickets,
                        "overs": float(second_innings.overs_bowled),
                    },
                },
            }
        else:
            # Tie
            match_result = {
                "winner": "tie",
                "winning_margin": 0,
                "winning_type": "tie",
                "final_scores": {
                    first_team: {
                        "runs": first_runs,
                        "wickets": first_innings.wickets,
                        "overs": float(first_innings.overs_bowled),
                    },
                    second_team: {
                        "runs": second_runs,
                        "wickets": second_innings.wickets,
                        "overs": float(second_innings.overs_bowled),
                    },
                },
            }

        return match_result

    async def finalize_match(self, match: Match, db: AsyncSession) -> Match:
        """Calculate result, set status to finished, and return the updated match."""
        match_result = await self.calculate_match_result(match, db)

        if match_result:
            match.result = match_result
            logger.info(
                "Match result calculated",
                match_id=match.id,
                winner=match_result["winner"],
                margin=match_result["winning_margin"],
                type=match_result["winning_type"],
            )

        match.status = "finished"
        match.finished_at = datetime.utcnow()
        await db.flush()

        return match

    async def check_auto_complete_innings(
        self, innings: Innings, match: Match, db: AsyncSession
    ) -> bool:
        """Check if an innings should be auto-completed (all out or overs done).

        Returns True if the innings was completed.
        """
        if innings.is_completed:
            return False

        rules = match.rules or {}
        max_players = rules.get("max_players_per_team", 11)
        last_man = rules.get("last_man_batting", False)
        max_wickets = max_players - 1 if not last_man else max_players

        overs_limit = innings.overs_allocated

        all_out = innings.wickets >= max_wickets
        overs_done = innings.overs_bowled >= overs_limit

        if all_out or overs_done:
            await self.complete_innings(innings, db)
            return True

        return False

    async def check_target_chased(
        self, second_innings: Innings, match: Match, db: AsyncSession
    ) -> bool:
        """Check if the chasing team has reached the target.

        Returns True if the match should be auto-finished.
        """
        # Get first innings score
        result = await db.execute(
            select(Innings)
            .where(Innings.match_id == match.id)
            .order_by(Innings.created_at)
        )
        all_innings = result.scalars().all()

        if len(all_innings) < 2:
            return False

        first_innings = all_innings[0]
        target = first_innings.runs + 1

        if second_innings.runs >= target:
            # Target chased — complete second innings and finalize
            await self.complete_innings(second_innings, db)
            return True

        return False


match_service = MatchService()
