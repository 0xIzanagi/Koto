// SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.22;

import {BondDepository} from "../src/BondDepository.sol";
import "lib/forge-std/src/Script.sol";

contract BondDepositoryScript is Script {
    BondDepository public depository;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_KOTO");
        vm.startBroadcast(deployerPrivateKey);
        depository = new BondDepository();
        vm.stopBroadcast();
    }
}
