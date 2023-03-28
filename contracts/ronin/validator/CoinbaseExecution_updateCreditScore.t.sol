pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./RoninValidatorSet.sol";
import { BridgeTracking } from "../gateway/BridgeTracking.sol";
import { RoninValidatorSet } from "./RoninValidatorSet.sol";
import { SlashIndicator } from "../slash-indicator/SlashIndicator.sol";
import { MockPrecompile } from "../../mocks/MockPrecompile.sol";

contract CoinbaseExecutionTest is Test {
  uint256 fork;
  string RPC_URL = vm.envString("TESTNET_URL");
  RoninValidatorSet validatorSetContract;
  BridgeTracking bridgeTrackingContract;
  SlashIndicator slashIndicatorContract;
  address coinbase;

  uint256 __currentEpoch;
  uint256 __currentPeriod;

  function setUp() public {
    validatorSetContract = RoninValidatorSet(payable(0x54B3AC74a90E64E8dDE60671b6fE8F8DDf18eC9d));
    slashIndicatorContract = SlashIndicator(payable(0xF7837778b6E180Df6696C8Fa986d62f8b6186752));

    // BridgeTracking newLogic = new BridgeTracking();
    // bytes memory code = address(newLogic).code;
    // vm.etch(address(bridgeTrackingContract), code);
    // fork = vm.createSelectFork(RPC_URL, 15028598);

    // RoninValidatorSet newLogic = new RoninValidatorSet();
    // vm.etch(address(validatorSetContract), address(newLogic).code);

    // SlashIndicator newSlash = new SlashIndicator();
    // vm.etch(address(slashIndicatorContract), address(newSlash).code);

    // MockPrecompile newPC = new MockPrecompile();
    // vm.etch(address(validatorSetContract.precompilePickValidatorSetAddress()), address(newPC).code);

    // coinbase = 0x36Fd0d4A075507a4E742631aA37DAD46a1F4c0da;
    // vm.roll(block.number + 1);
  }

  function testFork_debug_updateCreditScore() public {
    __currentEpoch = validatorSetContract.epochOf(block.number);
    __currentPeriod = validatorSetContract.currentPeriod();

    console.log("Epoch %d", __currentEpoch);
    console.log("Period %d", __currentPeriod);
  }

  function testFork_debug_updateCreditScore_2() public {
    vm.coinbase(coinbase);
    vm.prank(coinbase);
    validatorSetContract.wrapUpEpoch();
    console.log("Epoch %d", __currentEpoch);
    console.log("Period %d", __currentPeriod);
  }

  function testFork_debug_updateCreditScore_batch() public {
    uint256[10] memory forks;
    forks[0] = 12585198;
    forks[1] = 12556798;
    forks[2] = 12528198;
    forks[3] = 12503398;
    forks[4] = 12442598;
    forks[5] = 12414198;
    forks[6] = 12385598;
    forks[7] = 12357198;
    forks[8] = 12328798;
    forks[9] = 12300398;

    for (uint i = 0; i < 10; i++) {
      fork = vm.createSelectFork(RPC_URL, forks[i]);

      RoninValidatorSet newLogic = new RoninValidatorSet();
      vm.etch(address(validatorSetContract), address(newLogic).code);

      SlashIndicator newSlash = new SlashIndicator();
      vm.etch(address(slashIndicatorContract), address(newSlash).code);

      MockPrecompile newPC = new MockPrecompile();
      vm.etch(address(validatorSetContract.precompilePickValidatorSetAddress()), address(newPC).code);

      coinbase = 0x36Fd0d4A075507a4E742631aA37DAD46a1F4c0da;
      vm.roll(block.number + 1);

      debug_updateCreditScore_single();
    }
  }

  function debug_updateCreditScore_single() public {
    vm.coinbase(coinbase);
    vm.prank(coinbase);
    validatorSetContract.wrapUpEpoch();
    console.log("Epoch %d", __currentEpoch);
    console.log("Period %d", __currentPeriod);
  }
}
