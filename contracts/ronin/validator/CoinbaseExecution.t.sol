pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./RoninValidatorSet.sol";
import { BridgeTracking } from "../gateway/BridgeTracking.sol";

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
    bridgeTrackingContract = BridgeTracking(payable(0xBf9e491df628A3ab6daacb7b288032C1f84db52C));

    BridgeTracking newLogic = new BridgeTracking();
    bytes memory code = address(newLogic).code;
    vm.etch(address(bridgeTrackingContract), code);

    devnetFork = vm.createFork(DEVNET_RPC_URL);
    coinbase = 0x3B9F2587d55E96276B09b258ac909D809961F6C2;
    vm.roll(block.number + 1);
  }

  function testCreateContract() public {
    vm.selectFork(devnetFork);
    assertEq(vm.activeFork(), devnetFork);
  }

  function testFork_debug_getCurrentPeriod() public {
    vm.prank(coinbase);
    __currentEpoch = validatorSetContract.epochOf(block.number);
    __currentPeriod = validatorSetContract.currentPeriod();

    console.log("Epoch %d", __currentEpoch);
    console.log("Period %d", __currentPeriod);
  }

  function testFork_debug_getBallots() public {
    __currentPeriod = validatorSetContract.currentPeriod();

    address[21] memory _list = [
      0xD76B33A7ce5dbf374400A8Af6f825aB596653E1F,
      0xE6A695F7D96D549b0d176D591D0c35E61e74F3E2,
      0x24b5c6479611CF85A7FC9F4E50A2f3BafF90BDfB,
      0x5bF313658bc10F5445b4cE1aDabAB758bd85F291,
      0x3288010A8cd907bcCabd4B435AAde4c975c81DF2,
      0x7BDe8821494ce6bcAD84101D5652538b1EA79b2b,
      0x40Ab0B13032fa40e2f877Ad3797a4bb837805682,
      0x48bbceC4f79533d461610B3Cee17B44806A03264,
      0xCB1a48bb517cc5b30323Dd202C1645B48454536a,
      0x4C4a81448DD6759E4f70125dE7b41b8DBC797339,
      0x15FaE301Dd96fffcb6D00F665261fE3047bf0C34,
      0x060f136f61492955BdA350472C0488cACBDB9237,
      0x13e85501D111E476c1FbD86C17EE0a0f79d6a523,
      0xcB9e60872ED4Fab925A02E91E5841197Ae8F1858,
      0xAe5c19C87A8b2CD7be18de07B6BcdaAD99Fa6D72,
      0xeE299B46a42794fa90e277981dCFdad90886c9c5,
      0x73D741f7aAE1DbA4CEd9bCeB437B062d2595d56B,
      0xDe39e26567BC9e1C45e91c0A077DDA7A784846EE,
      0xf5Dc64e0B8A34c6C51aFD1bcF1C4BE91E7c47Ac2,
      0xdE5e1554E2BF5D0E54BaFC74C932B8f2AD4E2732,
      0xC6eF830414fCeE98049Ec63f86983e435275A2A9
    ];

    vm.prank(coinbase);
    // uint256 _currentPeriod = 1863494;
    console.log("Total ballots: %d", bridgeTrackingContract.totalBallots(__currentPeriod));
    console.log("Total votes: %d", bridgeTrackingContract.totalVotes(__currentPeriod));
    address[] memory _validators = new address[](21);
    for (uint i = 0; i < 21; i++) {
      _validators[i] = _list[i];
    }
    uint256[] memory _votes = bridgeTrackingContract.getManyTotalBallots(__currentPeriod, _validators);
    for (uint i = 0; i < 21; i++) {
      // BridgeTracking.VoteStats storage __stats = bridgeTrackingContract._periodStats[_currentPeriod];
      // uint256 __stats = .totalBallotsOf[_validators[i]];
      // console.log("%s: ballots(%d)\t periodStats(%d)", _validators[i], _votes[i], __stats);
      // console.log("%s: ballots(%d)\t ", _validators[i], _votes[i]);
      console.log("%s :  %d ", _validators[i], _votes[i]);
    }
  }

  function testFork_wrapUpEpoch() public {
    vm.coinbase(coinbase);
    vm.prank(coinbase);
    validatorSetContract.wrapUpEpoch();
  }

  function testFork_debug_getBallotsOfSingle() public {
    __currentPeriod = validatorSetContract.currentPeriod();

    address[1] memory _list = [0xDe39e26567BC9e1C45e91c0A077DDA7A784846EE];

    vm.prank(coinbase);
    uint256 _currentPeriod = 1863494;
    console.log("Total ballots: %d", bridgeTrackingContract.totalBallots(_currentPeriod));
    console.log("Total votes: %d", bridgeTrackingContract.totalVotes(_currentPeriod));
    address[] memory _validators = new address[](1);
    for (uint i = 0; i < 1; i++) {
      _validators[i] = _list[i];
    }
    uint256[] memory _votes = bridgeTrackingContract.getManyTotalBallots(_currentPeriod, _validators);
    for (uint i = 0; i < 1; i++) {
      console.log(_validators[i], ": ", _votes[i]);
    }
  }
}
