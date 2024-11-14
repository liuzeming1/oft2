// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.22;

import "forge-std/Script.sol";
import {IOFT, SendParam} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/interfaces/IOFT.sol";
import {IOAppCore} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/interfaces/IOAppCore.sol";
import {MessagingFee} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/OFTCore.sol";
import {OptionsBuilder} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAdapter is IOAppCore, IOFT {}

// Bridge tokens from Sepolia to Berachain
contract SendCMMFScript is Script {
    using OptionsBuilder for bytes;

    uint32 constant AVALANCHE_ENPOINT_ID = 40106;
    address constant CMMF_TOKEN = 0xb994D99D1104Ac852169f99191fD7f11ad8a1F96;

    function run() external {
        address SEPOLIA_ADAPTER_ADDRESS = vm.envAddress(
            "SEPOLIA_ADAPTER_ADDRESS"
        );
        address AVALANCHE_OFT_ADDRESS = vm.envAddress("AVALANCHE_OFT_ADDRESS");

        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        address signer = vm.addr(privateKey);

        // Get the Adapter contract instance
        IAdapter sepoliaAdapter = IAdapter(SEPOLIA_ADAPTER_ADDRESS);

        // Hook up Sepolia Adapter to Berachain's OFT
        sepoliaAdapter.setPeer(
            AVALANCHE_ENPOINT_ID,
            bytes32(uint256(uint160(AVALANCHE_OFT_ADDRESS)))
        );

        // Define the send parameters
        uint256 tokensToSend = 10 ether; // 0.0001 $UNI tokens

        bytes memory options = OptionsBuilder
            .newOptions()
            .addExecutorLzReceiveOption(200000, 0);

        SendParam memory sendParam = SendParam(
            AVALANCHE_ENPOINT_ID,
            bytes32(uint256(uint160(signer))),
            tokensToSend,
            tokensToSend,
            options,
            "",
            ""
        );

        // Quote the send fee
        MessagingFee memory fee = sepoliaAdapter.quoteSend(sendParam, false);
        console.log("Native fee: %d", fee.nativeFee);

        // Approve the OFT contract to spend UNI tokens
        IERC20(CMMF_TOKEN).approve(
            SEPOLIA_ADAPTER_ADDRESS,
            tokensToSend
        );

        // Send the tokens
        sepoliaAdapter.send{value: fee.nativeFee}(sendParam, fee, signer);

        console.log("Tokens bridged successfully!");
    }
}
