--Matches "finish" when MatchFinished and MatchRanking event are set for the same entity at the same block number
--FIXME: This gives extra records, because the MatchRanking is set twice in the finish transaction
SET
    search_path TO "0x7203e7adfdf38519e1ff4f8da7dcdc969371f377__";

SELECT
    match_finished.__last_updated_block_number AS created_at_block,
    match_finished.key AS match_entity,
    match_ranking.value :: json -> 'json' AS players
FROM
    match_finished
    INNER JOIN match_ranking ON match_finished.key = match_ranking.key
    and match_finished.__last_updated_block_number = match_ranking.__last_updated_block_number;