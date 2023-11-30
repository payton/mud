SELECT
    value AS "balance",
    concat('0x', encode(account, 'hex')) AS "mainWalletAddress",
    __last_updated_block_number AS "createdAtBlock"
FROM
    "0x7203e7ADfDF38519e1ff4f8Da7DCdC969371f377__Orb"."Balances"
WHERE
    account = '\x7203e7adfdf38519e1ff4f8da7dcdc969371f377';