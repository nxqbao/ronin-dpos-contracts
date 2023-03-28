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

  uint160 count = 500;

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

  function testBatchCandidateApply_01() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_02() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_03() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_04() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_05() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_06() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_07() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_08() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_09() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_10() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_11() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_12() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_13() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_14() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_15() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_16() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_17() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_18() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_19() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_20() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_21() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_22() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_23() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_24() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_25() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_26() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_27() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_28() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_29() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_30() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_31() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_32() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_33() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_34() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_35() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_36() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_37() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_38() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_39() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_40() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_41() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_42() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_43() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_44() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_45() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_46() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_47() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_48() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_49() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_50() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_51() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_52() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_53() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_54() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_55() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_56() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_57() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_58() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_59() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_60() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_61() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_62() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_63() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_64() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_65() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_66() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_67() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_68() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_69() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_70() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_71() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_72() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_73() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_74() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_75() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_76() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_77() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_78() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
  }

  function testBatchCandidateApply_79() public {
    coretestApplyCandidate(address(count++), address(count++), address(count++));
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
