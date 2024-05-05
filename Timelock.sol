// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Timelock {
  using SafeMath for uint256;

  mapping(address => uint256) public balances;

  mapping(address => uint256) public lockTime;

  function deposit() external payable {
    balances[msg.sender] += msg.value;
    lockTime[msg.sender] = block.timestamp + 1 weeks;
  }

  function increaseLockTime(uint256 _secondsToIncrease) public {
    lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToIncrease);
  }

  function withdraw() public {
    require(balances[msg.sender] > 0, "insufficient funds");
    require(block.timestamp > lockTime[msg.sender], "lock time has not expired");
    uint256 amount = balances[msg.sender];
    balances[msg.sender] = 0;
    (bool sent, ) = msg.sender.call{value: amount}("");

    require(sent, "Failed to send ether");
  }
}
