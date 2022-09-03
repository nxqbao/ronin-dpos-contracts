// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "../staking/RewardCalculation.sol";

contract MockStaking is RewardCalculation {
  /// @dev Mapping from user => staking balance
  mapping(address => uint256) internal _stakingBalance;
  /// @dev Mapping from period number => slashed
  mapping(uint256 => bool) internal _periodSlashed;
  uint256[] internal _periods;
  uint256 internal _totalBalance;

  address public poolAddr;

  constructor(address _poolAddr) {
    _periods.push(0);
    poolAddr = _poolAddr;
  }

  function endPeriod() external {
    _periods.push(block.number);
  }

  function stake(address _user, uint256 _amount) external {
    uint256 _balance = _stakingBalance[_user];
    uint256 _newBalance = _balance + _amount;
    _syncUserReward(poolAddr, _user, _newBalance);
    _stakingBalance[_user] = _newBalance;
    _totalBalance += _amount;
  }

  function unstake(address _user, uint256 _amount) external {
    uint256 _balance = _stakingBalance[_user];
    uint256 _newBalance = _balance - _amount;
    _syncUserReward(poolAddr, _user, _newBalance);
    _stakingBalance[_user] = _newBalance;
    _totalBalance -= _amount;
  }

  function slash() external {
    uint256 _period = getPeriod();
    _periodSlashed[_period] = true;
    _onSlashed(poolAddr);
  }

  function recordReward(uint256 _rewardAmount) external {
    _recordReward(poolAddr, _rewardAmount);
  }

  function commitRewardPool() external {
    _onPoolSettled(poolAddr);
  }

  function increaseAccumulatedRps(uint256 _amount) external {
    _recordReward(poolAddr, _amount);
  }

  function getPeriod() public view returns (uint256) {
    return _periodOf(block.number);
  }

  function claimReward(address _user) external returns (uint256 _amount) {
    _amount = _claimReward(poolAddr, _user);
  }

  function balanceOf(address, address _user) public view override returns (uint256) {
    return _stakingBalance[_user];
  }

  function totalBalance(address) public view virtual override returns (uint256) {
    return _totalBalance;
  }

  function _slashed(address, uint256 _period) internal view override returns (bool) {
    return _periodSlashed[_period];
  }

  function _periodOf(uint256 _block) internal view override returns (uint256 _period) {
    for (uint256 _i; _i < _periods.length; _i++) {
      if (_block >= _periods[_i]) {
        _period = _i + 1;
      }
    }
  }
}
