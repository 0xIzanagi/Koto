// SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.22;

import {BondDepository} from "../src/BondDepository.sol";
import "lib/forge-std/src/Script.sol";

contract BondHelpersScript is Script {
    BondDepository public depository = BondDepository(payable(0x0e58bD5557C4e0a0Abf0e8d4df24177Ae714452D));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_KOTO");
        vm.startBroadcast(deployerPrivateKey);
        depository.bond(1.25 ether);
        vm.stopBroadcast();
    }
}