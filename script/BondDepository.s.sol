// SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.22;

import {BondDepository} from "../src/BondDepository.sol";
import "lib/forge-std/src/Script.sol";

contract BondDepositoryScript is Script {
    function run() public {
        vm.startBroadcast();
        vm.stopBroadcast();
    }
}
