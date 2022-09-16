// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/NftSwap.sol";

contract ContractScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new NftSwap(0xA5Bb401E53A3DE5445102dFEe26Ae2a1d2669d23);
        vm.stopBroadcast();
    }
}
