// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {NftMinter} from "../src/NftMinter.sol";
import {NftSwap} from "../src/NftSwap.sol";

contract NftMinterTest is Test {

    NftMinter nftMinter;
    NftSwap nftSwap;

    address bob = address(0x1);
    address alice = address(0x2);
    address aryan = address(0x3);

    address test1 = address(0x4);
    function setUp() public {
        nftMinter = new NftMinter("NftMinter", "NFT");
        nftSwap = new NftSwap(address(nftMinter));
    }

    function testExample() public {
        assertTrue(true);
    }

    function testMint() public {
        nftMinter.mint(bob, 0);
        nftMinter.mint(bob, 1);

        nftMinter.mint(alice, 2);
        nftMinter.mint(alice, 3);

        assertTrue(nftMinter.balanceOf(bob) == 2);
        assertTrue(nftMinter.balanceOf(alice) == 2);
    }

    function testNftSwapCollectionAddress() public {
        address collectionAddress = nftSwap.collectionAddress();
        assertEq(collectionAddress, address(nftMinter));
    }


    function testDepositRequest() public {
        nftMinter.mint(bob, 0);

        nftMinter.mint(alice, 1);
        uint256[] memory bobAsk = new uint256[](1);
        bobAsk[0] = 1;

        vm.prank(bob);
        nftMinter.approve(address(nftSwap), 0);

        vm.prank(bob);   
        nftSwap.depositRequestForExchange(0, bobAsk);

        address askAddress = nftSwap.asks(keccak256(abi.encodePacked(uint256(0),uint256(1))),0);
        
        assertEq( askAddress, bob); 
        
        assertEq( nftMinter.ownerOf(0), address(nftSwap));


        uint256[] memory aliceAsk = new uint256[](1);
        aliceAsk[0] = 0;

        vm.prank(alice);
        nftMinter.approve(address(nftSwap), 1);

        vm.prank(alice);
        nftSwap.depositRequestForExchange(1, aliceAsk);


        assertEq( nftMinter.ownerOf(0), alice);
        assertEq(nftMinter.ownerOf(1), bob);

        
        
        // emit log_uint( nftSwap.askLength(keccak256(abi.encodePacked(uint256(0),uint256(1)))));
    }


    function testComplexOrders() public {
        nftMinter.mint(bob, 0);
        nftMinter.mint(bob, 1);
        nftMinter.mint(bob, 2);
        nftMinter.mint(bob, 3);

        nftMinter.mint(alice, 4);

        nftMinter.mint(aryan, 5);
        nftMinter.mint(aryan, 6); 

        nftMinter.mint(test1, 7);

        uint256[] memory bobAsk = new uint256[](1);

        bobAsk[0] = 4;

        uint256[] memory aliceAsk = new uint256[](2);
        aliceAsk[0] = 7;
        aliceAsk[1] = 5;

        uint256[] memory aryanAsk = new uint256[](1);
        aryanAsk[0] = 4;



        uint256[] memory test1Ask = new uint256[](1);
        test1Ask[0] = 4;

        // Bob deposits
        vm.prank(bob);
        nftMinter.approve(address(nftSwap), 0);

        vm.prank(bob);   
        nftSwap.depositRequestForExchange(0, bobAsk);
        assertEq(nftMinter.ownerOf(0), address(nftSwap));

        address askAddress = nftSwap.asks(keccak256(abi.encodePacked(uint256(0),uint256(4))),0);
        
        assertEq( askAddress, bob); 
        

        vm.prank(alice);
        nftMinter.approve(address(nftSwap), 4);

        vm.prank(alice);
        nftSwap.depositRequestForExchange(4, aliceAsk);

        assertEq(nftSwap.asks(keccak256(abi.encodePacked(uint256(4),uint256(7))),0), address(alice));

        // askAddress = nftSwap.asks(keccak256(abi.encodePacked(uint256(4),uint256(6))),0);
        // assertEq(askAddress, address(alice));


        vm.prank(aryan);
        nftMinter.approve(address(nftSwap), 5);

        vm.prank(aryan);
        nftSwap.depositRequestForExchange(5, aryanAsk);

        assertEq(nftMinter.ownerOf(4), address(aryan));
        assertEq(nftMinter.ownerOf(5), address(alice));
        
        assertEq(nftSwap.isAvailable(4), false);
        assertEq(nftSwap.asks(keccak256(abi.encodePacked(uint256(4),uint256(7))),0), address(alice));

        
        
        vm.prank(test1);
        nftMinter.approve(address(nftSwap), 7);

        vm.prank(test1);
        nftSwap.depositRequestForExchange(7, test1Ask);

        assertEq(nftSwap.askLength(keccak256(abi.encodePacked(uint256(4),uint256(7)))), 0);

        
        vm.prank(aryan);
        nftMinter.approve(address(nftSwap), 4);

        aryanAsk[0] = 7;

        vm.prank(aryan);
        nftSwap.depositRequestForExchange(4, aryanAsk);


        assertEq(nftMinter.ownerOf(4), address(test1));

    }

}
