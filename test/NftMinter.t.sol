// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NftMinter.sol";

contract NftMinterTest is Test {

    NftMinter nftMinter;

    address bob = address(0x1);
    address alice = address(0x2);
    function setUp() public {
        nftMinter = new NftMinter("NftMinter", "NFT");
    }

    function testExample() public {
        assertTrue(true);
    }

    function testMint() public {
        nftMinter.mint(bob, 0);
        address ownerOf0 = nftMinter.ownerOf(0);
        assertEq(bob, ownerOf0);
    }

}
