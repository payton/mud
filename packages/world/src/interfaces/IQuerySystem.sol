// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

import { IStore } from "@latticexyz/store/src/IStore.sol";
import { SelectionFragment, Record } from "./../modules/query/systems/structs.sol";

interface IQuerySystem {
  function query(
    IStore store,
    bytes32 tableId,
    uint8[] memory projectionFieldIndices,
    SelectionFragment[] memory fragments
  ) external view returns (Record[] memory records);
}
