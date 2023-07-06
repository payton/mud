// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { Test } from "forge-std/Test.sol";
import { GasReporter } from "@latticexyz/std-contracts/src/test/GasReporter.sol";
import { SchemaType } from "@latticexyz/schema-type/src/solidity/SchemaType.sol";
import { mudstore_Mixed, mudstore_MixedData, mudstore_MixedTableId } from "../src/codegen/Tables.sol";
import { StoreCore } from "../src/StoreCore.sol";
import { StoreReadWithStubs } from "../src/StoreReadWithStubs.sol";
import { Schema } from "../src/Schema.sol";

contract MixedTest is Test, GasReporter, StoreReadWithStubs {
  mudstore_MixedData private testMixed;

  function testRegisterAndGetSchema() public {
    startGasReport("register Mixed schema");
    mudstore_Mixed.registerSchema();
    endGasReport();

    Schema registeredSchema = StoreCore.getSchema(mudstore_MixedTableId);
    Schema declaredSchema = mudstore_Mixed.getSchema();

    assertEq(keccak256(abi.encode(registeredSchema)), keccak256(abi.encode(declaredSchema)));
  }

  function testSetAndGet() public {
    mudstore_Mixed.registerSchema();
    bytes32 key = keccak256("somekey");

    uint32[] memory a32 = new uint32[](2);
    a32[0] = 3;
    a32[1] = 4;
    string memory s = "some string";

    startGasReport("set record in Mixed");
    mudstore_Mixed.set({ key: key, u32: 1, u128: 2, a32: a32, s: s });
    endGasReport();

    startGasReport("get record from Mixed");
    mudstore_MixedData memory mixed = mudstore_Mixed.get(key);
    endGasReport();

    assertEq(mixed.u32, 1);
    assertEq(mixed.u128, 2);
    assertEq(mixed.a32[0], 3);
    assertEq(mixed.a32[1], 4);
    assertEq(mixed.s, s);
  }

  function testCompareSolidity() public {
    mudstore_MixedData memory mixed = mudstore_MixedData({ u32: 1, u128: 2, a32: new uint32[](2), s: "some string" });
    mixed.a32[0] = 3;
    mixed.a32[1] = 4;

    startGasReport("store Mixed struct in storage (native solidity)");
    testMixed = mixed;
    endGasReport();
  }

  function testEncode() public {
    uint32[] memory a32 = new uint32[](2);
    a32[0] = 3;
    a32[1] = 4;
    string memory s = "some string";

    assertEq(
      mudstore_Mixed.encode(1, 2, a32, s),
      hex"0000000100000000000000000000000000000002000000000000130000000008000000000b0000000000000000000000000000000000000300000004736f6d6520737472696e67"
    );
  }
}
