pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { BridgeTracking } from "../gateway/BridgeTracking.sol";
import { Staking } from "./Staking.sol";
import { RoninValidatorSet } from "../validator/RoninValidatorSet.sol";

contract ApplyCandidateTest is Test {
  uint256 devnetFork;
  string RPC_URL = vm.envString("TESTNET_URL");
  Staking stakingContract;
  RoninValidatorSet validatorSetContract;
  address coinbase;

  uint256 __currentEpoch;
  uint256 __currentPeriod;

  function setUp() public {
    stakingContract = Staking(payable(0x9C245671791834daf3885533D24dce516B763B28));
    validatorSetContract = RoninValidatorSet(payable(0x54B3AC74a90E64E8dDE60671b6fE8F8DDf18eC9d));

    // BridgeTracking newLogic = new BridgeTracking();
    // bytes memory code = address(newLogic).code;
    // vm.etch(address(bridgeTrackingContract), code);

    Staking newStakingLogic = new Staking();
    bytes memory stakingCode = address(newStakingLogic).code;

    RoninValidatorSet newValidatorLogic = new RoninValidatorSet();
    bytes memory validatorCode = address(newValidatorLogic).code;

    devnetFork = vm.createSelectFork(RPC_URL, 15436860);
    vm.etch(address(stakingContract), stakingCode);
    vm.etch(address(validatorSetContract), validatorCode);
    coinbase = 0x3B9F2587d55E96276B09b258ac909D809961F6C2;
  }

  function testBatchApply() public {
    uint160 count = 500;
    for (uint i; i < 65; ) {
      coretestApplyCandidate(address(count++), address(count++), address(count++));
      unchecked {
        i++;
      }
    }
  }

  function coretestApplyCandidate(
    address a1,
    address a2,
    address a3
  ) public {
    address _addr = a1;
    vm.deal(_addr, 1_000_000 ether);
    vm.prank(_addr);
    stakingContract.applyValidatorCandidate{ value: 500_000 ether }(_addr, a2, payable(_addr), a3, 10_00);
  }
}
