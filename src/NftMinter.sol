// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC721.sol";

contract NftMinter is ERC721 {
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
    }

    uint256 public tokenId;

    function tokenURI(uint256 id) public view override returns (string memory) {
        return "ipfs://bafyreic3omwmfqcggrf5cbmmw2so6eytbwwhhc3wruabcbpaci63qhzkxu/metadata.json";
    }

    function mint(address to, uint256 id) public {
        _mint(to, id);
        unchecked {
            tokenId ++;
        }
    }

    function burn(uint256 id) public {
        _burn(id);
    }
}
