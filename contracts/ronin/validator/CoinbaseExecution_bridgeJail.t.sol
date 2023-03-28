pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./RoninValidatorSet.sol";
import { BridgeTracking } from "../gateway/BridgeTracking.sol";
import { RoninValidatorSet } from "./RoninValidatorSet.sol";

contract CoinbaseExecutionTest is Test {
  uint256 devnetFork;
  string DEVNET_RPC_URL = vm.envString("DEVNET_URL");
  RoninValidatorSet validatorSetContract;
  BridgeTracking bridgeTrackingContract;
  address coinbase;

  uint256 __currentEpoch;
  uint256 __currentPeriod;

  function setUp() public {
    validatorSetContract = RoninValidatorSet(payable(0x262A3cab2bBB6Fc414Eb78e6755BF544B97dAC01));
    bridgeTrackingContract = BridgeTracking(payable(0x1d1C41591CCbe389ee1E25d4fa3B397F21284857));

    // BridgeTracking newLogic = new BridgeTracking();
    // bytes memory code = address(newLogic).code;
    // vm.etch(address(bridgeTrackingContract), code);

    RoninValidatorSet newLogic = new RoninValidatorSet();
    bytes memory code = address(newLogic).code;
    vm.etch(address(validatorSetContract), code);

    devnetFork = vm.createFork(DEVNET_RPC_URL);
    coinbase = 0x3B9F2587d55E96276B09b258ac909D809961F6C2;
    vm.roll(block.number + 1);
  }

  function testCreateContract() public {
    vm.selectFork(devnetFork);
    assertEq(vm.activeFork(), devnetFork);
  }

  function testFork_debug_getCurrentPeriod_2() public {
    vm.prank(coinbase);
    __currentEpoch = validatorSetContract.epochOf(block.number);
    __currentPeriod = validatorSetContract.currentPeriod();

    console.log("Epoch %d", __currentEpoch);
    console.log("Period %d", __currentPeriod);
  }

  function testFork_debug_rewardDeprecated() public {
    vm.prank(coinbase);
    bool _isDeprecated = validatorSetContract.checkBridgeRewardDeprecatedAtPeriod(
      0xDA0A817cD6ac3521ee669637fffB7c6293014840,
      1864649
    );

    console.log("isDeprecated", _isDeprecated);
  }
}
