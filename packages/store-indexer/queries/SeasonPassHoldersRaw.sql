-- Gives the account, orb balance, and season pass holder
SELECT
    account,
    CASE
        WHEN value IS NULL THEN FALSE
        ELSE TRUE
    END season_pass_holder
FROM
    "0x7203e7ADfDF38519e1ff4f8Da7DCdC969371f377__SeasonPass"."Balances";