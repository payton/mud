-- Gives the account, orb balance, season pass holder, and matches joined
SELECT
    concat(
        '0x',
        encode(
            COALESCE(
                orb_balances.account,
                season_pass_balances.account
            ),
            'hex'
        )
    ) AS "account",
    COALESCE(orb_balances.value, 0) / 1000000000000000000 AS orb_balance,
    CASE
        WHEN season_pass_balances.value IS NULL THEN FALSE
        ELSE TRUE
    END season_pass_holder,
    COALESCE(MatchesJoined.matches_joined, 0) as matches_joined
FROM
    "0x7203e7adfdf38519e1ff4f8da7dcdc969371f377__SeasonPass".balances AS season_pass_balances FULL
    OUTER JOIN (
        -- Get each accounts most recent orb balance
        WITH orb_balances AS (
            SELECT
                account,
                value,
                ROW_NUMBER() OVER (
                    PARTITION BY account
                    ORDER BY
                        __last_updated_block_number DESC
                ) AS RowNum
            FROM
                "0x7203e7adfdf38519e1ff4f8da7dcdc969371f377__Orb".balances
        )
        SELECT
            account,
            value
        FROM
            orb_balances
        WHERE
            RowNum = 1
            AND value <> 0
    ) AS orb_balances ON orb_balances.account = season_pass_balances.account FULL
    OUTER JOIN (
        -- Get the number of matches joined by each account
        SELECT
            SUBSTRING(owned_by.value, 13) AS account,
            COUNT(*) AS matches_joined
        FROM
            spawn_reserved_by
            INNER JOIN owned_by ON spawn_reserved_by.match_entity = owned_by.match_entity
            AND spawn_reserved_by.value = owned_by.entity
        GROUP BY
            owned_by.value
        ORDER BY
            matches_joined DESC
    ) AS MatchesJoined ON MatchesJoined.account = COALESCE(
        orb_balances.account,
        season_pass_balances.account
    )
ORDER BY
    COALESCE(orb_balances.value, 0) DESC;