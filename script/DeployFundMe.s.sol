pragma solidity ^0.8.19;
// SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns(FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(helperConfig.activeNetworkConfig());
        vm.stopBroadcast();     
        return fundMe;
    }
}