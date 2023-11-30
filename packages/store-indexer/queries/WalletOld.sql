-- Gives the account, orb balance, and season pass holder
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
    END season_pass_holder
FROM
    "0x7203e7ADfDF38519e1ff4f8Da7DCdC969371f377__SeasonPass"."Balances" AS season_pass_balances FULL
    OUTER JOIN (
        -- Get the most up to date orb balance
        WITH OrbBalances AS (
            SELECT
                Account,
                value,
                ROW_NUMBER() OVER (
                    PARTITION BY Account
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
    ) AS OrbBalances ON OrbBalances.account = season_pass_balances.account
ORDER BY
    COALESCE(OrbBalances.value, 0) DESC;