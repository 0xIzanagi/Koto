// SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.22;

import {Koto} from "../../src/Koto.sol";
import "lib/forge-std/src/Script.sol";

contract DeployPoolScript is Script {
    Koto public koto = Koto(payable(0x0e58bD5557C4e0a0Abf0e8d4df24177Ae714452D));

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY_KOTO");
        vm.startBroadcast(deployerPrivateKey);
        koto.launch();
        vm.stopBroadcast();
    }
}
