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
    concat('0x', encode(account, 'hex')) AS "account",
    (value / 1000000000000000000) AS balance
FROM
    OrbBalances
WHERE
    RowNum = 1
    AND value <> 0
ORDER BY
    value DESC;