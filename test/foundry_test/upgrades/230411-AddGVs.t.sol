import "forge-std/Test.sol";
import { RoninGovernanceAdmin } from "@contracts/ronin/RoninGovernanceAdmin.sol";
import { RoninTrustedOrganization } from "@contracts/multi-chains/RoninTrustedOrganization.sol";
import { IRoninTrustedOrganization } from "@contracts/interfaces/IRoninTrustedOrganization.sol";
import { SlashIndicator } from "@contracts/ronin/slash-indicator/SlashIndicator.sol";
import { Ballot } from "@contracts/libraries/Ballot.sol";
import { RoninValidatorSet } from "@contracts/ronin/validator/RoninValidatorSet.sol";

contract Upgrade230411AddGVTest is Test {
  using stdStorage for StdStorage;
  uint256 fork;
  string RPC_URL = vm.envString("MAINNET_URL");
  RoninGovernanceAdmin GAContract;
  RoninTrustedOrganization TOContract;
  SlashIndicator SlashContract;
  RoninValidatorSet ValidatorContract;

  function setUp() public {
    fork = vm.createSelectFork(RPC_URL);

    GAContract = RoninGovernanceAdmin(payable(0x946397deDFd2f79b75a72B322944a21C3240c9c3));
    TOContract = RoninTrustedOrganization(GAContract.roninTrustedOrganizationContract());
    ValidatorContract = RoninValidatorSet(payable(0x617c5d73662282EA7FfD231E020eCa6D2B0D552f));
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

  function testPropose_addGVs() external {
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
    printTrustedOrgs();
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
    printTrustedOrgs();
    console.log("======================");
  }

  function prepareMainnetData()
    internal
    view
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
    expiryTimestamp = 1681640491;
    uint256 length = 1;
    targets = new address[](length);
    values = new uint256[](length);
    gasAmounts = new uint256[](length);
    for (uint i; i < length; i++) {
      targets[i] = address(TOContract);
      values[i] = 0;
      gasAmounts[i] = 2_000_000;
    }

    datas = new bytes[](length);
    datas[
      0
    ] = hex"4bb5274a000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000007240ed285df0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000b0000000000000000000000006e46924371d0e910769aabe0d867590deac20684000000000000000000000000ea172676e4105e92cc52dbf45fd93b274ec96676000000000000000000000000f4ed08c347e63e00916af33eb2b371eea9812593000000000000000000000000000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000000000000000000000000000000000000000008eec4f1c0878f73e8e09c1be78ac1465cc16544d00000000000000000000000090ead0e8d5f5bf5658a2e6db04535679df0f8e430000000000000000000000000ecee7d75d4d00d68fb4df5bc62e6d09e7ec014d00000000000000000000000000000000000000000000000000000000000000640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ee11d2016e9f2fae606b2f12986811f4abbe621500000000000000000000000077ab649caa7b4b673c9f2cf069900df48114d79d0000000000000000000000005153545192d793ff3dda1075196365f2f82e526400000000000000000000000000000000000000000000000000000000000000640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000210744c64eea863cf0f972e5aebc683b98fb19840000000000000000000000004620fb95eabdab4bf681d987e116e0aaef1adef20000000000000000000000000e28a9df6979952ab333567917f4da22069a825500000000000000000000000000000000000000000000000000000000000000640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d11d9842babd5209b9b1155e46f5878c989125b70000000000000000000000005832c3219c1da998e828e1a2406b73dbfc02a70c000000000000000000000000c18e7b56684903f0c8ba900e42f4aac406882b9b00000000000000000000000000000000000000000000000000000000000000640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fc3e31519b551bd594235dd0ef014375a87c4e2100000000000000000000000060c4b72fc62b3e3a74e283aa9ba20d61dd4d8f1b0000000000000000000000007b8325312dff80b10e03d3f764c9472cece83a96000000000000000000000000000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000000000000000000000000000000000000000009b959d27840a31988410ee69991bcf0110d61f02000000000000000000000000bacb04ea617b3e5eee0e3f6e8fcb5ba886b83958000000000000000000000000452273e252f96eb9dc098faedc9e8a947986336b00000000000000000000000000000000000000000000000000000000000000640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e07d7e56588a6fd860c5073c70a099658c060f3d000000000000000000000000d5877c63744903a459ccba94c909cdaae90575f8000000000000000000000000139eea2007de5917752db8c6325c19e6e1e4956d00000000000000000000000000000000000000000000000000000000000000640000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ec702628f44c31acc56c3a59555be47e1f16eb1e000000000000000000000000e258f9996723b910712d6e67ada4eafc15f7f1010000000000000000000000008fe8fe3dff9a6ee301fd061128f7593bc233c4cb0000000000000000000000000000000000000000000000000000000000000064000000000000000000000000000000000000000000000000000000000000000000000000000000000000000052349003240770727900b06a3b3a90f5c0219ade00000000000000000000000002201f9bfd2face1b9f9d30d776e77382213da1a000000000000000000000000573e3028958c457c418173a60668491455786afb0000000000000000000000000000000000000000000000000000000000000064000000000000000000000000000000000000000000000000000000000000000000000000000000000000000032d619dc6188409cebbc52f921ab306f07db085b00000000000000000000000058abcbcab52dee942491700cd0db67826bbaa8c600000000000000000000000066bc2886b4bf8b1fd434b83b77af32e3579a01ea0000000000000000000000000000000000000000000000000000000000000064000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  }

  function printTrustedOrgs() internal view {
    IRoninTrustedOrganization.TrustedOrganization[] memory _tos = TOContract.getAllTrustedOrganizations();

    for (uint i; i < _tos.length; i++) {
      console.log("> Trusted org #%d:", i);
      console.log("     Consensus: %s", _tos[i].consensusAddr);
      console.log("     Govenor:   %s", _tos[i].governor);
      console.log("     Bridge:    %s", _tos[i].bridgeVoter);
    }
  }
}
