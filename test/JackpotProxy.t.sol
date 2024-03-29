// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Jackpot} from "../src/Jackpot.sol";
import {JackpotProxy} from "../src/JackpotProxy.sol";

contract JackpotProxyTest is Test {
    JackpotProxy jackpotProxy;
    Jackpot jackpot;

    address whale = 0x2E0D63fFCB08eA20fF3AcDbB72dfEc97343885d2;
    function setUp() public {
        jackpotProxy = new JackpotProxy();
        jackpot = new Jackpot(address(jackpotProxy));
    }

    function testClaimPrize() public {
        
        vm.prank(whale);
        address(jackpot).call{value: 4 ether}("");
        
        uint256 preBalance = address(jackpotProxy).balance;

        jackpotProxy.claimPrize{value: 1 ether}(address(jackpot));

        uint256 postBalance = address(jackpotProxy).balance;

        assertEq(postBalance, preBalance + 2 ether);
    }
    
    receive() external payable {}
}
