-- Gives the number of matches joined for each owner
SET
    search_path TO "0x7203e7ADfDF38519e1ff4f8Da7DCdC969371f377__";

SELECT
    SUBSTRING("OwnedBy".value, 13) AS account,
    COUNT(*) AS matches_joined
FROM
    "SpawnReservedBy"
    INNER JOIN "OwnedBy" ON "SpawnReservedBy"."matchEntity" = "OwnedBy"."matchEntity"
    AND "SpawnReservedBy".value = "OwnedBy".entity
GROUP BY
    "OwnedBy".value
ORDER BY
    matches_joined DESC;