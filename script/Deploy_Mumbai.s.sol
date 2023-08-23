// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {LayerZeroSwap_Mumbai} from "../src/LayerZeroSwap_Mumbai.sol";

contract DeployMumbai is Script {

    LayerZeroSwap_Mumbai layerZeroSwap_Mumbai;

    function run() external {        

        uint256 PrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(PrivateKey);

        layerZeroSwap_Mumbai = new LayerZeroSwap_Mumbai(0xf69186dfBa60DdB133E91E9A4B5673624293d8F8);

        vm.stopBroadcast();
    }
}
