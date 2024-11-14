// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import "../src/OFTAdapterCame_Sepolial.sol";

// Deploys OFT adapter to Sepolia
contract OFTAdapterCamelScript is Script {
    address constant CMMF_TOKEN = 0xb994D99D1104Ac852169f99191fD7f11ad8a1F96;
    address constant LAYERZERO_ENDPOINT =
        0x6EDCE65403992e310A62460808c4b910D972f10f;

    function run() public {
        // Setup
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        // Deploy
        new OFTAdapterCamel_Sepolia(
            CMMF_TOKEN,
            LAYERZERO_ENDPOINT,
            vm.addr(privateKey) // Wallet address of signer
        );

        vm.stopBroadcast();
    }
}
