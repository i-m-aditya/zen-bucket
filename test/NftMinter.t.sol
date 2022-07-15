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


}
