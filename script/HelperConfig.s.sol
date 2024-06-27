pragma solidity ^0.8.19;
// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import {console} from "forge-std/Test.sol";

contract HelperConfig is Script {

    struct NetworkConfig {
        address priceFeed;   
        //uint256 value; 
    }
    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaPriceFeedAddress();
            console.log("################## Sepolia Network Selected ##################");
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetPriceFeedAddress();
            console.log("################## Mainnet Network Selected ##################");
        } else {
            activeNetworkConfig = getAnvilPriceFeedAddress();
            console.log("################## Anvil Network Selected ##################");
        }
    }

    function getSepoliaPriceFeedAddress() public pure returns(NetworkConfig memory) {
        NetworkConfig memory sepoliaPriceFeed = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaPriceFeed;
    }

    function getMainnetPriceFeedAddress() public pure returns(NetworkConfig memory) {
        NetworkConfig memory mainnetPriceFeed = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainnetPriceFeed;
    }

    function getAnvilPriceFeedAddress() public returns(NetworkConfig memory) {
        console.log("getAnvilPriceFeedAddress() function is triggered");
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        
        NetworkConfig memory anvilPriceFeed = NetworkConfig({priceFeed: address(mockV3Aggregator)});
        return anvilPriceFeed;
        // 1.deploy the mock contract
        // 2.read the mock address
    }
}