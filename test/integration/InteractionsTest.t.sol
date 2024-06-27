// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionTest is Test {
    FundMe fundMe;

    address immutable USER = makeAddr("user");
    uint256 constant TEST_PRICE = 1 ether;
    uint256 constant START_PRICE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        console.log("function setUp() external is called");
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        // vm.prank(USER);
        fundFundMe.fundFundMe(address(fundMe));

        address funder = fundMe.getFunder(0);
        assertEq(funder, msg.sender);        
    }

    function testUserCanWithdrawInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0);        
    }
}