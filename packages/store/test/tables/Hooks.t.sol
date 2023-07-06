// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { Test } from "forge-std/Test.sol";
import { GasReporter } from "@latticexyz/std-contracts/src/test/GasReporter.sol";
import { StoreReadWithStubs } from "../../src/StoreReadWithStubs.sol";
import { mudstore_Hooks } from "../../src/codegen/Tables.sol";

contract HooksTest is Test, GasReporter, StoreReadWithStubs {
  function testSetAndGet() public {
    // Hooks schema is already registered by StoreCore
    bytes32 key = keccak256("somekey");

    address[] memory addresses = new address[](1);
    addresses[0] = address(this);

    startGasReport("set field in Hooks");
    mudstore_Hooks.set(key, addresses);
    endGasReport();

    startGasReport("get field from Hooks (warm)");
    address[] memory returnedAddresses = mudstore_Hooks.get(key);
    endGasReport();

    assertEq(returnedAddresses.length, addresses.length);
    assertEq(returnedAddresses[0], addresses[0]);

    startGasReport("push field to Hooks");
    mudstore_Hooks.push(key, addresses[0]);
    endGasReport();

    returnedAddresses = mudstore_Hooks.get(key);

    assertEq(returnedAddresses.length, 2);
    assertEq(returnedAddresses[1], addresses[0]);
  }
}
