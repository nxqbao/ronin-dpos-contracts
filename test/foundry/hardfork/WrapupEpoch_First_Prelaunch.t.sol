import "forge-std/Test.sol";
import { RoninGovernanceAdmin } from "@contracts/ronin/RoninGovernanceAdmin.sol";
import { RoninTrustedOrganization } from "@contracts/multi-chains/RoninTrustedOrganization.sol";
import { IRoninTrustedOrganization } from "@contracts/interfaces/IRoninTrustedOrganization.sol";
import { SlashIndicator } from "@contracts/ronin/slash-indicator/SlashIndicator.sol";
import { Ballot } from "@contracts/libraries/Ballot.sol";
import { RoninValidatorSet } from "@contracts/ronin/validator/RoninValidatorSet.sol";
import { MockPrecompile } from "@contracts/mocks/MockPrecompile.sol";

contract FirstWraupEpochTest is Test {
  uint256 fork;
  string RPC_URL = vm.envString("MAINNET_URL");
  RoninGovernanceAdmin GAContract;
  RoninTrustedOrganization TOContract;
  SlashIndicator SlashContract;
  RoninValidatorSet ValidatorContract;

  address SkyMavisGVConsensus = 0xf41Af21F0A800dc4d86efB14ad46cfb9884FDf38;

  /**
   * SET UP FUNCTIONS
   */

  function setUp() external {
    fork = vm.createSelectFork(RPC_URL);
    ValidatorContract = RoninValidatorSet(payable(0x617c5d73662282EA7FfD231E020eCa6D2B0D552f));
    deployPCU_arrangeValidator();
    topupStakingVesting();
  }

  function deployPCU_arrangeValidator() internal {
    MockPrecompile precompileContract = new MockPrecompile();
    vm.etch(address(uint160(0x68)), address(precompileContract).code);
  }

  function topupStakingVesting() internal {
    vm.deal(0xC768423A2AE2B5024cB58F3d6449A8f5DB6D8816, 1_000_000 ether);
  }

  /**
   * TEST FUNCTIONS
   */

  function testWraupEpoch_First_Prelaunch() external {
    setHardforkBlock();
    getValidators();
    wrapUpEpoch(SkyMavisGVConsensus, 1);

    submitBlockRewardsBulk(5000 wei);
    setFirstPeriodBlock();
    wrapUpEpoch(SkyMavisGVConsensus, 2);
  }

  function setHardforkBlock() internal {
    console.log("[*] Set hardfork block");
    uint256 hardforkBlock = 23155200 - 1;
    uint256 hardforkTimestamp = 1681288482; // Wed Apr 12 2023 08:34:42 GMT+0000

    __setBlock(hardforkBlock, hardforkTimestamp);
  }

  function setFirstPeriodBlock() internal {
    console.log("[*] Set hardfork block");

    uint256 firstPeriodBlock = 23164800 - 1; // hardforkBlock + 28800/3
    uint256 firstPeriodTimestamp = 1681344313; // Thu Apr 13 2023 00:05:13 GMT+0000

    __setBlock(firstPeriodBlock, firstPeriodTimestamp);
  }

  function __setBlock(uint _block, uint _timestamp) private {
    console.log("[*] Set block to", _block);
    console.log("    Set timestamp to", _timestamp);

    vm.roll(_block);
    vm.warp(_timestamp);
  }

  function getValidators() internal returns (address[] memory _validators) {
    console.log("[*] Get validators");
    (_validators, , ) = ValidatorContract.getValidators();
    for (uint i; i < _validators.length; i++) {
      console.log(_validators[i]);
    }
  }

  function wrapUpEpoch(address _coinbase, uint256 _counter) internal {
    console.log("Invoke wrapUpEpoch. Invoking #%d", _counter);
    __setCoinbase(_coinbase);
    ValidatorContract.wrapUpEpoch();
  }

  function submitBlockRewardsBulk(uint256 amountEachBlock) internal {
    console.log("[*] Submit block reward in bulk");
    uint _block = block.number;
    address[] memory _validators = getValidators();
    for (uint i; i < _validators.length; i++) {
      address miner = _validators[i];
      console.log("    Submitted %d from %s at %d", amountEachBlock, miner, ++_block);
      vm.deal(miner, 1 ether);
      vm.roll(_block);
      __setCoinbase(miner);
      ValidatorContract.submitBlockReward{ value: amountEachBlock }();
    }
  }

  function __setCoinbase(address _coinbase) private {
    vm.coinbase(_coinbase);
    vm.prank(_coinbase);
  }
}
