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

        // emit log_address (bob);
        // emit log_address(nftMinter.ownerOf(0));
        // emit log_address(address(nftSwap));

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

}
