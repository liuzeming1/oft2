// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {IOAppCore} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/interfaces/IOAppCore.sol";
import {OFTReceipt, SendParam} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/interfaces/IOFT.sol";
import {OptionsBuilder} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oapp/libs/OptionsBuilder.sol";
import {MessagingFee} from "@layerzerolabs/lz-evm-oapp-v2/contracts/oft/OFTCore.sol";
import {MyOFT} from "../src/MyOFT.sol";

contract SendAMMFScript is Script {
    using OptionsBuilder for bytes;

    /**
     * @dev Converts an address to bytes32.
     * @param _addr The address to convert.
     * @return The bytes32 representation of the address.
     */
    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }

    function run() public {
        // Fetching environment variables
        address oftAddress = vm.envAddress("AVALANCHE_OFT_ADDRESS");

        // Fetch the private key from environment variable
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting with the private key
        vm.startBroadcast(privateKey);
        address signer = vm.addr(privateKey);
        MyOFT sourceOFT = MyOFT(oftAddress);

        bytes memory _extraOptions = OptionsBuilder
            .newOptions()
            .addExecutorLzReceiveOption(65000, 0);

        uint256 tokensToSend = 1 ether;
        SendParam memory sendParam = SendParam(
            40161, // You can also make this dynamic if needed
            addressToBytes32(signer),
            tokensToSend,
            tokensToSend,
            _extraOptions,
            "",
            ""
        );

        MessagingFee memory fee = sourceOFT.quoteSend(sendParam, false);

        console.log("Fee amount: ", fee.nativeFee);

        sourceOFT.send{value: fee.nativeFee}(sendParam, fee, msg.sender);

        // Stop broadcasting
        vm.stopBroadcast();
        console.log("Tokens bridged successfully!");
    }
}
