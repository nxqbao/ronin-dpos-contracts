pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./RoninValidatorSet.sol";
import { BridgeTracking } from "../gateway/BridgeTracking.sol";
import { RoninValidatorSet } from "./RoninValidatorSet.sol";
import { SlashIndicator } from "../slash-indicator/SlashIndicator.sol";
import { MockPrecompile } from "../../mocks/MockPrecompile.sol";

// 12300398
// 12328798
// 12357198
// 12385598
// 12414198
// 12442598
// 12503398
// 12528198
// 12556798
// 12585198
// 12613998
// 12642398
// 12670998
// 12699598
// 12727798
// 12756198
// 12784798
// 12813398
// 12841998
// 12870798
// 12899598
// 12928398
// 12957198
// 12985998
// 13014798
// 13043398
// 13072198
// 13100998
// 13129798
// 13158598
// 13187398
// 13215998
// 13244798
// 13273598
// 13302398
// 13331198
// 13359998
// 13388598
// 13417398
// 13446198
// 13474998
// 13503798
// 13532598
// 13561398
// 13590198
// 13618998
// 13647798
// 13676598
// 13705198
// 13733998
// 13762798
// 13791598
// 13820398
// 13849198
// 13877998
// 13906798
// 13935398
// 13964198
// 13992998
// 14021798
// 14050598
// 14079398
// 14108198
// 14136998
// 14165798
// 14194598
// 14223398
// 14252198
// 14280998
// 14309798
// 14338598
// 14367398
// 14396198
// 14424998
// 14453798
// 14482598
// 14511398
// 14540198
// 14568998
// 14597798
// 14626598
// 14655398
// 14683798
// 14712598
// 14741398
// 14770198
// 14798998
// 14827798
// 14856598
// 14885398
// 14914198
// 14942998
// 14971398
// 15000198
// 15028598
// 15057398
// 15085398
// 15114198
// 15142598

contract CoinbaseExecutionTest is Test {
  uint256 fork;
  string RPC_URL = vm.envString("TESTNET_URL");
  RoninValidatorSet validatorSetContract;
  BridgeTracking bridgeTrackingContract;
  SlashIndicator slashIndicatorContract;
  address coinbase;
  bytes validatorSetCode;
  bytes slashCode;
  bytes precompileCode;

  uint256 __currentEpoch;
  uint256 __currentPeriod;

  function setUp() public {
    validatorSetContract = RoninValidatorSet(payable(0x54B3AC74a90E64E8dDE60671b6fE8F8DDf18eC9d));
    slashIndicatorContract = SlashIndicator(payable(0xF7837778b6E180Df6696C8Fa986d62f8b6186752));
    RoninValidatorSet newLogic = new RoninValidatorSet();
    validatorSetCode = address(newLogic).code;
    SlashIndicator newSlash = new SlashIndicator();
    slashCode = address(newSlash).code;
    MockPrecompile newPC = new MockPrecompile();
    precompileCode = address(newPC).code;
  }

  function test_debug_updateCreditScoreBatch_1() public {
    fork = vm.createSelectFork(RPC_URL, 12300398);
    core();
  }

  function test_debug_updateCreditScoreBatch_2() public {
    fork = vm.createSelectFork(RPC_URL, 12328798);
    core();
  }

  function test_debug_updateCreditScoreBatch_3() public {
    fork = vm.createSelectFork(RPC_URL, 14827798);
    core();
  }

  function test_debug_updateCreditScoreBatch_4() public {
    fork = vm.createSelectFork(RPC_URL, 14856598);
    core();
  }

  function test_debug_updateCreditScoreBatch_5() public {
    fork = vm.createSelectFork(RPC_URL, 14885398);
    core();
  }

  function test_debug_updateCreditScoreBatch_6() public {
    fork = vm.createSelectFork(RPC_URL, 14914198);
    core();
  }

  function test_debug_updateCreditScoreBatch_7() public {
    fork = vm.createSelectFork(RPC_URL, 14942998);
    core();
  }

  function test_debug_updateCreditScoreBatch_8() public {
    fork = vm.createSelectFork(RPC_URL, 14971398);
    core();
  }

  function test_debug_updateCreditScoreBatch_9() public {
    fork = vm.createSelectFork(RPC_URL, 15142598);
    core();
  }

  function core() public {
    vm.etch(address(validatorSetContract), validatorSetCode);
    vm.etch(address(slashIndicatorContract), slashCode);
    vm.etch(address(validatorSetContract.precompilePickValidatorSetAddress()), precompileCode);

    coinbase = 0x36Fd0d4A075507a4E742631aA37DAD46a1F4c0da;
    vm.roll(block.number + 1);

    slashIndicatorContract.getCreditScoreConfigs();

    vm.coinbase(coinbase);
    vm.prank(coinbase);
    validatorSetContract.wrapUpEpoch();
    console.log("Epoch %d", __currentEpoch);
    console.log("Period %d", __currentPeriod);
  }
}
