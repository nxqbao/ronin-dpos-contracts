import "forge-std/Test.sol";
import { RoninGovernanceAdmin } from "../RoninGovernanceAdmin.sol";
import { RoninTrustedOrganization } from "../../multi-chains/RoninTrustedOrganization.sol";
import { IRoninTrustedOrganization } from "../../interfaces/IRoninTrustedOrganization.sol";
import { SlashIndicator } from "./SlashIndicator.sol";
import { Ballot } from "../../libraries/Ballot.sol";

contract SlashIndicatorTest is Test {
  using stdStorage for StdStorage;
  uint256 fork;
  string RPC_URL = vm.envString("MAINNET_URL");
  RoninGovernanceAdmin GAContract;
  RoninTrustedOrganization TOContract;
  SlashIndicator SlashContract;

  function setUp() public {
    fork = vm.createSelectFork(RPC_URL);

    GAContract = RoninGovernanceAdmin(payable(0x946397deDFd2f79b75a72B322944a21C3240c9c3));
    TOContract = RoninTrustedOrganization(GAContract.roninTrustedOrganizationContract());
    SlashContract = SlashIndicator(0xEBFFF2b32fA0dF9C5C8C5d5AAa7e8b51d5207bA3);
    address TOLogicAddr = address(
      uint160(
        uint256(
          vm.load(address(TOContract), bytes32(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc))
        )
      )
    );

    console.log("GAContract", address(GAContract));
    console.log("TOContract", address(TOContract));
    console.log("SlashContract", address(SlashContract));
    console.log("TOLogicAddr", TOLogicAddr);

    IRoninTrustedOrganization.TrustedOrganization[] memory _list = TOContract.getAllTrustedOrganizations();
    console.log("governor length", _list.length);
    console.log("governor", _list[0].governor);

    RoninTrustedOrganization TOLogic = new RoninTrustedOrganization();
    bytes memory TOCode = address(TOLogic).code;
    vm.etch(TOLogicAddr, TOCode);
  }

  function testPropose_slashConfigs() external {
    address[1] memory governors = [0xe880802580a1fbdeF67ACe39D1B21c5b2C74f059];

    (
      uint256 chainId,
      uint256 expiryTimestamp,
      address[] memory targets,
      uint256[] memory values,
      bytes[] memory datas,
      uint256[] memory gasAmounts
    ) = prepareMainnetData();

    address gov = governors[0];

    stdstore.target(address(TOContract)).sig("_governorWeight(address)").with_key(gov).checked_write(1000000);
    //   .depth(0)

    console.log("===== PRE-CHECK =====");
    printSlashConfigs();
    console.log("=====================");

    vm.prank(gov);
    // function proposeProposalForCurrentNetwork(
    //   uint256 _expiryTimestamp,
    //   address[] calldata _targets,
    //   uint256[] calldata _values,
    //   bytes[] calldata _calldatas,
    //   uint256[] calldata _gasAmounts,
    //   Ballot.VoteType _support
    // ) external onlyGovernor {
    GAContract.proposeProposalForCurrentNetwork(
      expiryTimestamp,
      targets,
      values,
      datas,
      gasAmounts,
      Ballot.VoteType.For
    );

    console.log("===== POST-CHECK =====");
    printSlashConfigs();
    console.log("======================");
  }

  function prepareMainnetData()
    internal
    pure
    returns (
      uint256 chainId,
      uint256 expiryTimestamp,
      address[] memory targets,
      uint256[] memory values,
      bytes[] memory datas,
      uint256[] memory gasAmounts
    )
  {
    chainId = 2020;
    expiryTimestamp = 1681620303;
    uint256 length = 3;
    targets = new address[](length);
    values = new uint256[](length);
    gasAmounts = new uint256[](length);
    for (uint i; i < length; i++) {
      targets[i] = 0xEBFFF2b32fA0dF9C5C8C5d5AAa7e8b51d5207bA3;
      values[i] = 0;
      gasAmounts[i] = 1_000_000;
    }

    datas = new bytes[](length);
    datas[
      0
    ] = hex"4bb5274a000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000840e1512ac00000000000000000000000000000000000000000000000000000000000003e80000000000000000000000000000000000000000000000000000000000000bb80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003200000000000000000000000000000000000000000000000000000000";
    datas[
      1
    ] = hex"4bb5274a00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000084d1737e27000000000000000000000000000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000000000000001f400000000000000000000000000000000000000000000003635c9adc5dea00000000000000000000000000000000000000000000000000000000000000000e10000000000000000000000000000000000000000000000000000000000";
    datas[
      2
    ] = hex"4bb5274a00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000044853af1b7000000000000000000000000000000000000000000000000000000000001518000000000000000000000000000000000000000000000003635c9adc5dea0000000000000000000000000000000000000000000000000000000000000";
  }

  function printSlashConfigs() internal {
    (
      uint256 missingVotesRatioTier1,
      uint256 missingVotesRatioTier2,
      uint256 jailDurationForMissingVotesRatioTier2,
      uint256 skipBridgeOperatorSlashingThreshold
    ) = SlashContract.getBridgeOperatorSlashingConfigs();

    (
      uint256 unavailabilityTier1Threshold,
      uint256 unavailabilityTier2Threshold,
      uint256 slashAmountForUnavailabilityTier2Threshold,
      uint256 jailDurationForUnavailabilityTier2Threshold
    ) = SlashContract.getUnavailabilitySlashingConfigs();

    (uint256 bridgeVotingThreshold, uint256 bridgeVotingSlashAmount) = SlashContract.getBridgeVotingSlashingConfigs();

    console.log("missingVotesRatioTier1", missingVotesRatioTier1);
    console.log("missingVotesRatioTier2", missingVotesRatioTier2);
    console.log("jailDurationForMissingVotesRatioTier2", jailDurationForMissingVotesRatioTier2);
    console.log("skipBridgeOperatorSlashingThreshold", skipBridgeOperatorSlashingThreshold);
    console.log("unavailabilityTier1Threshold", unavailabilityTier1Threshold);
    console.log("unavailabilityTier2Threshold", unavailabilityTier2Threshold);
    console.log("slashAmountForUnavailabilityTier2Threshold", slashAmountForUnavailabilityTier2Threshold);
    console.log("jailDurationForUnavailabilityTier2Threshold", jailDurationForUnavailabilityTier2Threshold);
    console.log("bridgeVotingThreshold", bridgeVotingThreshold);
    console.log("bridgeVotingSlashAmount", bridgeVotingSlashAmount);
  }
}
