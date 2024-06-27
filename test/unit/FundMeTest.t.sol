pragma solidity ^0.8.19;
// SPDX-License-Identifier: MIT

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {PriceConverter} from "../../src/PriceConverter.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address immutable USER = makeAddr("user");
    uint256 constant TEST_PRICE = 1 ether;
    uint256 constant START_PRICE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: TEST_PRICE}();
        _;
    }

    function setUp() external {
        console.log("function setUp() external is called for contract FundMeTest");
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
        vm.deal(USER, START_PRICE);
    }

    function test_const_price() public view {
        console.log(fundMe.CONST_PRICE(), "should be the same as", .01 ether);
        assertEq(fundMe.CONST_PRICE(), .01 ether);
    }

    function test_owner() public view {
        console.log("fundMe.getOwner(), should be the same as msg.sender");
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        console.log(fundMe.getVersion(), "should be the same as", 4);
        assertEq(fundMe.getVersion(), uint256(4));
    }

    function testFundFunctionNoMoney() public {
        //console.log(fundMe.getVersion(), "should be the same as", 4);
        vm.expectRevert();
        fundMe.fund{value: 0 ether}();
    }
    
    function testFundFunctionWMoney() funded public {
        console.log("testFundFunctionWMoney() test was instantiated");
        assertEq(fundMe.getAddresToAmountFunded(USER), TEST_PRICE);
    }

    function testAddsFunderToArrayOfFunders() funded public {
        console.log("fundMe.getOwner()", fundMe.getOwner(), "msg.sender", msg.sender);
        assertEq(fundMe.getFunder(0), USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();  // expects failure because USER cannot withdraw and only owner can withdraw
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startfundMeBalance = address(fundMe).balance;
        uint256 startOwnerBalance = fundMe.getOwner().balance;
        // Act
        // uint256 gasStart = gasleft();
        // vm.txGasPrice(0);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint256 endfundMeBalance = address(fundMe).balance;
        uint256 endOwnerBalance = fundMe.getOwner().balance;
        // Assert
        assertEq(startfundMeBalance, endOwnerBalance-startOwnerBalance);
        assertEq(endfundMeBalance, 0);
    }

    function testWithdrawFromMultipleFunders() public {
        uint256 totalFundsWidthdrawn = 0;
        uint256 startOwnerBalance = fundMe.getOwner().balance;
        for (uint160 i = 0; i<11; i++) {
            hoax(address(i));
            fundMe.fund{value: TEST_PRICE}();
            totalFundsWidthdrawn += TEST_PRICE;
        }
        assertEq(address(fundMe).balance, totalFundsWidthdrawn);
        
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        uint256 endOwnerBalance = fundMe.getOwner().balance;
        assertEq(totalFundsWidthdrawn, endOwnerBalance-startOwnerBalance);
    }

    function testWithdrawFromMultipleFundersCheaper() public {
        uint256 totalFundsWidthdrawn = 0;
        uint256 startOwnerBalance = fundMe.getOwner().balance;
        for (uint160 i = 0; i<11; i++) {
            hoax(address(i));
            fundMe.fund{value: TEST_PRICE}();
            totalFundsWidthdrawn += TEST_PRICE;
        }
        assertEq(address(fundMe).balance, totalFundsWidthdrawn);
        
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();
        uint256 endOwnerBalance = fundMe.getOwner().balance;
        assertEq(totalFundsWidthdrawn, endOwnerBalance-startOwnerBalance);
    }

    function testPriceConverterlib() public funded {  // This test always asserts to true
        uint256 price = fundMe.getPriceGetter();
        console.log("price", price);
    }
}