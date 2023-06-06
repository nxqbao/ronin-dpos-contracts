import "forge-std/Test.sol";
import { RoninGovernanceAdmin } from "@contracts/ronin/RoninGovernanceAdmin.sol";
import { RoninTrustedOrganization } from "@contracts/multi-chains/RoninTrustedOrganization.sol";
import { IRoninTrustedOrganization } from "@contracts/interfaces/IRoninTrustedOrganization.sol";
import { SlashIndicator } from "@contracts/ronin/slash-indicator/SlashIndicator.sol";
import { Ballot } from "@contracts/libraries/Ballot.sol";
import { RoninValidatorSet } from "@contracts/ronin/validator/RoninValidatorSet.sol";
import { MockPrecompile } from "@contracts/mocks/MockPrecompile.sol";
import { BridgeTracking } from "@contracts/ronin/gateway/BridgeTracking.sol";
import { Maintenance } from "@contracts/ronin/Maintenance.sol";

contract MaintenanceCocoTest is Test {
  uint256 fork;
  uint256 forkBlock = 24630799 - 10;
  string RPC_URL = vm.envString("MAINNET_URL");
  Maintenance maintenanceContract;
  RoninValidatorSet validatorSetContract;

  function setUp() external {
    fork = vm.createSelectFork(RPC_URL, forkBlock); // Epoch #123154
    maintenanceContract = Maintenance(0x6F45C1f8d84849D497C6C0Ac4c3842DC82f49894);
    validatorSetContract = RoninValidatorSet(payable(0x617c5d73662282EA7FfD231E020eCa6D2B0D552f));
    deployPCU_arrangeValidator();
  }

  function deployPCU_arrangeValidator() internal {
    MockPrecompile precompileContract = new MockPrecompile();
    vm.etch(address(uint160(0x68)), address(precompileContract).code);
  }

  function testMaintenance__GetConfigs() external {
    uint256 _minOffset = maintenanceContract.minOffsetToStartSchedule();
    uint256 _maxOffset = maintenanceContract.maxOffsetToStartSchedule();

    console.log("minOffset", _minOffset);
    console.log("maxOffset", _maxOffset);
  }

  function testMaintenance__scheduleMaintenance() external {
    uint256 currentEpoch = validatorSetContract.epochOf(forkBlock);

    console.log("currentEpoch", currentEpoch);
    vm.prank(0xAaf13f99BDBF3bFa9209AaBFcd74C50c6D1A9e72); // StableNode admin
    maintenanceContract.schedule(
      0x6E46924371d0e910769aaBE0d867590deAC20684, // StableNode consensus
      24632000, // Epoch #123160,
      24632599 //Epoch #123162
    );
  }
}
