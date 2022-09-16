// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Jackpot} from "../src/Jackpot.sol";
import {JackpotProxy} from "../src/JackpotProxy.sol";

contract JackpotProxyTest is Test {
    JackpotProxy jackpotProxy;
    Jackpot jackpot;


    function setUp() public {
        jackpotProxy = new JackpotProxy();
        jackpot = new Jackpot(address(jackpotProxy));
    }

    function testClaimPrize() public {
        uint256 preBalance = address(jackpotProxy).balance;


        emit log_named_uint("preBalance", preBalance);

        // jackpotProxy.claimPrize{value: 1 ether}(address(jackpot));

        // uint256 postBalance = address(jackpotProxy).balance;

        // assertEq(postBalance, preBalance + 2 ether);
    }
}
