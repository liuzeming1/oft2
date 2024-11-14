-include .env

deploy-oft-adapter-sepolia:
	forge script script/OFTAdapterCame_Sepolial.s.sol --rpc-url $(SEPOLIA_RPC_URL) --broadcast

deploy-oft-adapter-avalanche:
	forge script script/OFTAdapterCamel_Avalanche.s.sol --rpc-url $(AVALANCHE_RPC_URL) --broadcast

deploy-oft-fuji:
	forge script script/MyOFT.s.sol --rpc-url $(AVALANCHE_RPC_URL) --broadcast

send-cmmf:
	forge script script/SendCMMF.s.sol --rpc-url  $(SEPOLIA_RPC_URL) --broadcast
	
send-ammf:
	forge script script/SendAMMF.s.sol --rpc-url  $(AVALANCHE_RPC_URL) --broadcast