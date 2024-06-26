// get funds from users
// withdraw funds
// set a minimum funding value in USD

pragma solidity ^0.8.19;
// SPDX-License-Identifier: MIT

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter { 
    function getPrice(AggregatorV3Interface priceFeed) public view returns(uint256) {
        // 0x694AA1769357215DE4FAC081bf1f309aDC325306 is the address of the contract that is of the contract type AggregatorV3Interface so it has all these functions
        // this address resembles the contract that contains the latest price of ETH in USD
        (, int256 _price,,,) = priceFeed.latestRoundData();
        return uint256(_price)*1e10;
    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) public view returns(uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        return (ethPrice * ethAmount) / 1e18;
    }
}