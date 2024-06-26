// get funds from users
// withdraw funds
// set a minimum funding value in USD

pragma solidity ^0.8.19;
// SPDX-License-Identifier: MIT

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";
import {console} from "forge-std/Test.sol";

contract FundMe {
    address private immutable i_owner;
    uint256 public constant CONST_PRICE = 0.01 ether;
    address[] private s_funders;
    mapping(address=>uint256) private s_addresToAmountFunded;
    AggregatorV3Interface public s_priceFeed;

    modifier moneyRequirement() {
        require(msg.value>=CONST_PRICE, "not enough money");
        _;
    }

    modifier isOwner {
        require(msg.sender==i_owner, "not an original owner of contract");
        _;
    }
 
    // Functions Order:
    //// constructor
    //// receive
    //// fallback
    //// external
    //// public
    //// internal
    //// private
    //// view / pure

    constructor(address _priceFeedAddress) {
        i_owner = msg.sender;
        console.log("msg.sender address is ", msg.sender);
        s_priceFeed = AggregatorV3Interface(_priceFeedAddress);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function fund() public payable moneyRequirement() {
        s_funders.push(msg.sender);
        s_addresToAmountFunded[msg.sender] = s_addresToAmountFunded[msg.sender] + msg.value;
    }

    function withdraw() public isOwner {
        for(uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address _funder = s_funders[funderIndex];
            s_addresToAmountFunded[_funder] = 0;
        }
        s_funders = new address[](0);

        // transfer
        // send
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance} ("");
        require(callSuccess, "Call failed");
    }

    function cheaperWithdraw() public isOwner {
        uint256 length = s_funders.length;
        for(uint256 funderIndex = 0; funderIndex < length; funderIndex++) {
            address _funder = s_funders[funderIndex];
            s_addresToAmountFunded[_funder] = 0;
        }
        s_funders = new address[](0);

        // transfer
        // send
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance} ("");
        require(callSuccess, "Call failed");
    }

    // view functions (getters) - they are needed for testing as we no longer have public variables used for storage so we must use getters
    //function getConversionRate(uint256 ethAmount) public view returns(uint256) {
    //    uint256 ethPrice = PriceConverter.getPrice(s_priceFeed);
    //    return (ethPrice * ethAmount) / 1e18;
    //}

    function getFunder(uint256 _funderIndex) public view returns(address) {
        return s_funders[_funderIndex];
    }
    function getAddresToAmountFunded(address _fundingAddress) external view returns(uint256) {
        return s_addresToAmountFunded[_fundingAddress];
    }
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }
    function getOwner() public view returns (address) {
        return i_owner;
    }
    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
    function getPriceGetter() public view returns (uint256) {
        return PriceConverter.getPrice(s_priceFeed);
    }
}