// SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.22;

import {Koto} from "../../src/Koto.sol";
import "lib/forge-std/src/Script.sol";

contract KotoScript is Script {
    Koto public koto;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_KOTO");
        vm.startBroadcast(deployerPrivateKey);
        koto = new Koto();
        vm.stopBroadcast();
    }
}
