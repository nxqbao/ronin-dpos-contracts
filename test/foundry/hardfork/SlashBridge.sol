import "forge-std/Test.sol";
import { RoninGovernanceAdmin } from "@contracts/ronin/RoninGovernanceAdmin.sol";
import { RoninTrustedOrganization } from "@contracts/multi-chains/RoninTrustedOrganization.sol";
import { IRoninTrustedOrganization } from "@contracts/interfaces/IRoninTrustedOrganization.sol";
import { SlashIndicator } from "@contracts/ronin/slash-indicator/SlashIndicator.sol";
import { Ballot } from "@contracts/libraries/Ballot.sol";
import { RoninValidatorSet } from "@contracts/ronin/validator/RoninValidatorSet.sol";
import { MockPrecompile } from "@contracts/mocks/MockPrecompile.sol";
import { BridgeTracking } from "@contracts/ronin/gateway/BridgeTracking.sol";

contract SlashBridge is Test {
  uint256 fork;
  string RPC_URL = vm.envString("MAINNET_URL");
  BridgeTracking bridgeTrackingContract;

  function setUp() external {
    fork = vm.createSelectFork(RPC_URL);
    bridgeTrackingContract = BridgeTracking(payable(0x3Fb325b251eE80945d3fc8c7692f5aFFCA1B8bC2));
    deployPCU_arrangeValidator();
  }

  function deployPCU_arrangeValidator() internal {
    MockPrecompile precompileContract = new MockPrecompile();
    vm.etch(address(uint160(0x68)), address(precompileContract).code);
  }

  function testGetSlashBridge() external {
    uint256 _totalVotes = bridgeTrackingContract.totalVotes(0);
    uint256 _totalBallots = bridgeTrackingContract.totalBallots(0);

    console.log("_totalVotes", _totalVotes);
    console.log("_totalBallots", _totalBallots);
  }
}
