SET
    search_path TO "0x7203e7ADfDF38519e1ff4f8Da7DCdC969371f377__";

--Matches are "created" when MatchConfig is set
SELECT
    __last_updated_block_number AS "createdAtBlock",
    "createdBy" AS "mainWalletAddress",
    encode("levelId", 'escape') AS map,
    key AS "matchEntity"
FROM
    "MatchConfig";