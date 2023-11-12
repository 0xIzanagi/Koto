// SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.22;

import {Koto} from "../src/Koto.sol";
import "lib/forge-std/src/Script.sol";

contract KotoHelpersScript is Script {
    Koto public koto = Koto(payable(0x86de09fE79Ed2e70283A6A3c810d7Ff92cBb7EeA));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_KOTO");
        vm.startBroadcast(deployerPrivateKey);
        
        vm.stopBroadcast();
    }
}