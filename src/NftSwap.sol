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
    
    mapping (uint256=>address) nftDeposits;

    // Ask for NFTs
    // abi.encode(nft1, nft2) -> [address]
    mapping (bytes32 => address[]) asks;

    // Ask for NFTs
    mapping (uint256 => uint256[]) asksList;



    function swapMyNFTWhenThisAreAvailable(uint256 tokenA, uint256[] memory asksArray) public {
        require(ERC721(collectionAddress).ownerOf(tokenA) == msg.sender, "Not owner");
        // Assuming wanted tokenIds are not already owned by the same user

        
        _orderMatchElsePopulate(tokenA, asksArray);
        
        
    }

    function _orderMatchElsePopulate(uint256 tokenA, uint256[] memory asksArray) private {
        for(uint256 i=0; i<asksArray.length; i++) {
            uint256 tokenB = asksArray[i];
            
            bytes32 encodedIds = keccak256(abi.encodePacked(tokenB, tokenA));
            if(asks[encodedIds].length > 0) {
                _exchangeNfts(asks[encodedIds][0], msg.sender, tokenA, tokenB);
                address[] memory emptyArray;
                asks[encodedIds] = emptyArray;
                return ;
            }
        }
        for(uint256 index=0; index<asksArray.length; index++) {
            require(ERC721(collectionAddress).ownerOf(asksArray[index]) == address(0), "Zero address");
            asks[keccak256(abi.encodePacked(tokenA, asksArray[index]))].push(msg.sender);
        }
    }

    function _exchangeNfts(address bob, address mary, uint256 tokenA, uint256 tokenB) private {
        ERC721(collectionAddress).transferFrom(address(this), bob, tokenA);
        ERC721(collectionAddress).transferFrom(address(this), mary, tokenB);
    }
}
