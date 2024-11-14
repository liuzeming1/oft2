// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import "../src/OFTAdapterCamel_Avalanche.sol";

// Deploys OFT adapter to Sepolia
contract OFTAdapterCamelScript is Script {
    address constant CMMF_TOKEN = 0x623fbCCD58A291f34DF358d21A2d34086DB0896b;
    address constant LAYERZERO_ENDPOINT =
        0x6EDCE65403992e310A62460808c4b910D972f10f;

    function run() public {
        // Setup
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        // Deploy
        new OFTAdapterCamel_Avalanche(
            CMMF_TOKEN,
            LAYERZERO_ENDPOINT,
            vm.addr(privateKey) // Wallet address of signer
        );

        vm.stopBroadcast();
    }
}
