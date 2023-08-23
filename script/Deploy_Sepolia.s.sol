// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {LayerZeroSwap_Sepolia} from "../src/LayerZeroSwap_Sepolia.sol";

contract DeploySepolia is Script {

    LayerZeroSwap_Sepolia layerZeroSwap_Sepolia;

    function run() external {        

        uint256 PrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(PrivateKey);

        layerZeroSwap_Sepolia = new LayerZeroSwap_Sepolia(0xae92d5aD7583AD66E49A0c67BAd18F6ba52dDDc1);

        vm.stopBroadcast();
    }
}
