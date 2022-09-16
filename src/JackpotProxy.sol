// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract JackpotProxy {
    function claimPrize(address jackpot) public payable {
        uint256 amount = msg.value;
        require(amount > 0, "Amount should be greater than 0");

        (bool success,) = jackpot.call{value: amount}(abi.encodeWithSignature("claimPrize(uint256)", amount));
        require(success, "Failed to claim prize");
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
