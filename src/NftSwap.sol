// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";

struct Depositor {
    address owner;
    uint256 tokenId;
}

contract NftSwap {
    address public collectionAddress;

    constructor(address _collectionAddress) {
        collectionAddress = _collectionAddress;
    }

    // Ask for NFTs
    // abi.encode(nft1, nft2) -> [address]
    mapping(bytes32 => address[]) public asks;

    mapping(uint256 => bool) public isAvailable;

    function depositRequestForExchange(uint256 tokenA, uint256[] memory asksArray) public {
        require(ERC721(collectionAddress).ownerOf(tokenA) == msg.sender, "Not owner ser");
        // Assuming wanted tokenIds are not already owned by the same user
        ERC721(collectionAddress).transferFrom(msg.sender, address(this), tokenA);

        _orderMatchElsePopulate(tokenA, asksArray);
    }

    function askLength(bytes32 hash) public view returns (uint256) {
        return asks[hash].length;
    }

    function _orderMatchElsePopulate(uint256 tokenA, uint256[] memory asksArray) private {
        for (uint256 i = 0; i < asksArray.length; i++) {
            uint256 tokenB = asksArray[i];

            bytes32 encodedIds = keccak256(abi.encodePacked(tokenB, tokenA));
            // lazy update of the isAvailable mapping
            if (asks[encodedIds].length > 0) {
                if (isAvailable[tokenB] == false) {
                    address[] memory emptyArray;
                    asks[encodedIds] = emptyArray;
                } else {
                    _exchangeNfts(asks[encodedIds][0], msg.sender, tokenA, tokenB);
                    address[] memory emptyArray;
                    asks[encodedIds] = emptyArray;
                    return;
                }
            }
        }
        isAvailable[tokenA] = true;
        for (uint256 index = 0; index < asksArray.length; index++) {
            require(ERC721(collectionAddress).ownerOf(asksArray[index]) != address(0), "Zero address");
            asks[keccak256(abi.encodePacked(tokenA, asksArray[index]))].push(msg.sender);
        }
    }

    function _exchangeNfts(address bob, address mary, uint256 tokenA, uint256 tokenB) private {
        isAvailable[tokenA] = false;
        isAvailable[tokenB] = false;
        ERC721(collectionAddress).transferFrom(address(this), bob, tokenA);
        ERC721(collectionAddress).transferFrom(address(this), mary, tokenB);
    }

    function rescue(uint256 tokenId) public {
        require(msg.sender == address(0x5c679543E519eAcD7F8f8D15Fd15F9F9D77829dF), "Only the contract owner can rescue");
        ERC721(collectionAddress).transferFrom(address(this), msg.sender, tokenId);
    }

    function calcKeccak(uint256 tokenA, uint256 tokenB) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(tokenA, tokenB));
    }
}
