-include .env

create-sepolia:
	forge create src/FundMe.sol:FundMe --rpc-url $(SEP_URL) --private-key $(SEP_ACC_KEY_1) --verify --etherscan-api-key $(ETHERSCAN_API_KEY)
deploy-sepolia:
	forge script script/DeployFundMe.s.sol --rpc-url $(SEP_URL) --private-key $(SEP_ACC_KEY_1) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
deploy-anvil:
	forge script script/DeployFundMe.s.sol --rpc-url $(ANV_URL) --private-key $(ANV_ACC_KEY_1) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv