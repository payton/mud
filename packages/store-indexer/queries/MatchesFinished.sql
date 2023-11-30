--Matches "finish" when MatchFinished and MatchRanking event are set for the same entity at the same block number
--FIXME: This gives extra records, because the MatchRanking is set twice in the finish transaction
SET
    search_path TO "0x7203e7ADfDF38519e1ff4f8Da7DCdC969371f377__";

SELECT
    "MatchFinished".__last_updated_block_number AS "createdAtBlock",
    "MatchFinished".key AS "MatchEntity",
    "MatchRanking".value :: json -> 'json' AS players
FROM
    "MatchFinished"
    INNER JOIN "MatchRanking" ON "MatchFinished".key = "MatchRanking".key
    and "MatchFinished"."__last_updated_block_number" = "MatchRanking"."__last_updated_block_number";

;