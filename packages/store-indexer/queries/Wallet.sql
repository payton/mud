-- Gives the account, orb balance, season pass holder, and matches joined
SELECT
    concat(
        '0x',
        encode(
            COALESCE(
                OrbBalances.account,
                season_pass_balances.account
            ),
            'hex'
        )
    ) AS "account",
    COALESCE(OrbBalances.value, 0) / 1000000000000000000 AS orb_balance,
    CASE
        WHEN season_pass_balances.value IS NULL THEN FALSE
        ELSE TRUE
    END season_pass_holder,
    COALESCE(MatchesJoined.matches_joined, 0) as matches_joined
FROM
    "0x7203e7ADfDF38519e1ff4f8Da7DCdC969371f377__SeasonPass"."Balances" AS season_pass_balances FULL
    OUTER JOIN (
        -- Get each accounts most recent orb balance
        WITH OrbBalances AS (
            SELECT
                account,
                value,
                ROW_NUMBER() OVER (
                    PARTITION BY account
                    ORDER BY
                        __last_updated_block_number DESC
                ) AS RowNum
            FROM
                "0x7203e7ADfDF38519e1ff4f8Da7DCdC969371f377__Orb"."Balances"
        )
        SELECT
            account,
            value
        FROM
            OrbBalances
        WHERE
            RowNum = 1
            AND value <> 0
    ) AS OrbBalances ON OrbBalances.account = season_pass_balances.account FULL
    OUTER JOIN (
        -- Get the number of matches joined by each account
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
            matches_joined DESC
    ) AS MatchesJoined ON MatchesJoined.account = COALESCE(
        OrbBalances.account,
        season_pass_balances.account
    )
ORDER BY
    COALESCE(OrbBalances.value, 0) DESC;