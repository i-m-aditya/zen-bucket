// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Jackpot {
    address private jackpotProxy;

    constructor(address _jackpotProxy) {
        jackpotProxy = _jackpotProxy;
    }

    modifier onlyJackpotProxy() {
        require(msg.sender == jackpotProxy, "Only jackpot proxy can call this function");
        _;
    }

    function claimPrize(uint256 amount) public payable onlyJackpotProxy {
        // do something
        payable(msg.sender).transfer(2 * amount);
    }

    fallback() external payable {}
    receive() external payable {}
}
