pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { RoninGatewayV2 } from "./RoninGatewayV2.sol";
import { BridgeTracking } from "./BridgeTracking.sol";

contract RoninGatewayV2Test is Test {
  uint256 devnetFork;
  string DEVNET_RPC_URL = vm.envString("DEVNET_URL");

  RoninGatewayV2 gatewayContract;
  BridgeTracking bridgeTrackingContract;
  address coinbase;

  uint256 __currentEpoch;
  uint256 __currentPeriod;

  function setUp() public {
    gatewayContract = RoninGatewayV2(payable(0x14bEbb8a09e0362f026B9f4Fb1Cd2EB508c919ba));
    bridgeTrackingContract = BridgeTracking(payable(0xBf9e491df628A3ab6daacb7b288032C1f84db52C));

    BridgeTracking newLogic = new BridgeTracking();
    bytes memory code = address(newLogic).code;
    vm.etch(address(bridgeTrackingContract), code);

    devnetFork = vm.createFork(DEVNET_RPC_URL);
    coinbase = 0x3B9F2587d55E96276B09b258ac909D809961F6C2;
    vm.roll(block.number + 1);
  }

  function testReplayTx() public {
    // 0x7d8c6c79ac15d280ac7eb7622118b134db5103223c8f5e2c8ac171063419f05a   13005668
    vm.prank(0xDe39e26567BC9e1C45e91c0A077DDA7A784846EE);
    bytes memory _calldata = hex"deadbeef";
    (bool _s, ) = address(gatewayContract).call(_calldata);
    if (_s) return;
  }

  function testSubmitWithdrawal_1() public {
    // 0x7d8c6c79ac15d280ac7eb7622118b134db5103223c8f5e2c8ac171063419f05a   13005668
    vm.prank(0xDe39e26567BC9e1C45e91c0A077DDA7A784846EE);
    bytes
      memory _calldata = hex"fa38965900000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000180000000000000000000000000000000000000000000000000000000000000000900000000000000000000000000000000000000000000000000000000000000c200000000000000000000000000000000000000000000000000000000000000c300000000000000000000000000000000000000000000000000000000000000cb00000000000000000000000000000000000000000000000000000000000000cc00000000000000000000000000000000000000000000000000000000000000cd00000000000000000000000000000000000000000000000000000000000000ce00000000000000000000000000000000000000000000000000000000000000cf00000000000000000000000000000000000000000000000000000000000000d000000000000000000000000000000000000000000000000000000000000000d10000000000000000000000000000000000000000000000000000000000000009000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000001a0000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000002a0000000000000000000000000000000000000000000000000000000000000032000000000000000000000000000000000000000000000000000000000000003a0000000000000000000000000000000000000000000000000000000000000042000000000000000000000000000000000000000000000000000000000000004a0000000000000000000000000000000000000000000000000000000000000052000000000000000000000000000000000000000000000000000000000000000419cc05d910eb5c56a514595cd2075a894a75ba212a46734b1fd1eafbf691afef235b0198699da145bd8108dd980d4b536ccafeefeb25e37ee760d544aa020dffa1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041522c0ed2cf0bc97e36aba6642ccba093eff54551644ee8cf3c072eaf9243c57820d4ae3e0cb13c4e34115f770eca81ae43e11dbeabc8696802fa3e02cd15e5b31c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041ad6bbb722c9dc14f954f88ac7dc73d61c951d5cf2bdee5b69f8c827eb0ce5579617f5a508779f59a4851a258239e276a19d33d87d7e9eee10a2b17d1144916cc1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041802a0260cdce948f865aa9aeadf60227491db60dd06527773331e9ff7bbcaa3d2aaa7495b5305d5b55f90665901e63e9692996e365c785931458c867efd3660f1b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004170d32165d1a308b3e817db0d0ad7f3d263743cffc9c1e48ec53d7be4bffa959f7082a8af5edaf9648d151d4e0fca794d68e7903d7a411a84e34fd3292b582f4f1c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041752488bf9f0f279a1c69fd653740ce14ff3a1258b1870e766d092354619c58b400cc8461fce7662d848a656859b523f68771b9f38231ee5b2dcf7009ad2645691c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000413d2c6a6ad15b15c14897e9feb5e3fd417edcdf091b185dedda62d83fac8c7f92277284d29b26460ff2e6c319ac924edd4649eb7a95ddcd73cc15a81971aacf411b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041bd13543e1218992d9c6910eb1b622e899a20e695aad37c7568e9929a09ea7c79694faeab14519c067934a4a997e3e78b61d4065e9508b16f722f7fa46d77a95a1c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041d97214b54f41ee01bacaac7341287e0fbe5760578b2958603b2f3cd2542676921ebe738b8bf7d4f1766baec4d922b43351d22d8a7c0d368062850d22b6be127f1c00000000000000000000000000000000000000000000000000000000000000";
    (bool _s, ) = address(gatewayContract).call(_calldata);
    if (_s) return;
  }

  function testSubmitWithdrawal_target_4() public {
    // 0xc499bef687efff5e2bafaa11d381fb5d5a47a800373044f01d636881a546bacf   13005634
    vm.prank(0xDe39e26567BC9e1C45e91c0A077DDA7A784846EE);
    bytes
      memory _calldata = hex"fa389659000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000c400000000000000000000000000000000000000000000000000000000000000c50000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000411ec1a11f048de41d962a0f2cb7064c2f3997967fc2ce18a01141661c16313aca539403835b6c0347d73718bfc4427f474882122617a61a38cc813272a9d5003a1c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004118617957a73e327c3bf74a6c81a7c2cbfb70aa2a9a396b802508f64807551c4e4edffc6cac84796f981fc293a5ef50d25ef21e15fcaa50a44a284e26249e06011b00000000000000000000000000000000000000000000000000000000000000";
    (bool _s, ) = address(gatewayContract).call(_calldata);
    if (_s) return;
  }

  function testSubmitWithdrawal_target_5() public {
    // 0x84b66495612a23fe3616dc1d1ab3faf12c0bf846fc33db521727e141f19bd013   13005636
    vm.prank(0xDe39e26567BC9e1C45e91c0A077DDA7A784846EE);
    bytes
      memory _calldata = hex"fa38965900000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000c6000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000041542c2a5566f77d73dd2c480d41d0e0bbd460f0e5032574fe4ebc2d88c47180327fff62ef41e86cc7d3d19093127904c527003ef5f6d0dca6110f7f368edc22fa1c00000000000000000000000000000000000000000000000000000000000000";
    (bool _s, ) = address(gatewayContract).call(_calldata);
    if (_s) return;
  }

  function testSubmitWithdrawal_target_6() public {
    // 0x45b2c5a9b8615bbf55e1e64193690db5341e8c20ce84ea91c0e4ee8060d13fd3   13005637
    vm.prank(0xDe39e26567BC9e1C45e91c0A077DDA7A784846EE);
    bytes
      memory _calldata = hex"fa38965900000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000c7000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000041d32a497a9246208e0a6817d3dc6d3e5e2c461d20f39f8a1dfce312c1b97289f41ad4779e42ebadf696ee71f2ca0708d0080668919476017968d54d9f3e8d24191c00000000000000000000000000000000000000000000000000000000000000";
    (bool _s, ) = address(gatewayContract).call(_calldata);
    if (_s) return;
  }

  function testSubmitWithdrawal_target_13() public {
    // 0x8f59e873428d806c4a7abb2fff49ee7188f184ed921b8dc298afc68a7285dab6   13005652
    vm.prank(0xDe39e26567BC9e1C45e91c0A077DDA7A784846EE);
    bytes
      memory _calldata = hex"fa389659000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000ce00000000000000000000000000000000000000000000000000000000000000cf0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000041752488bf9f0f279a1c69fd653740ce14ff3a1258b1870e766d092354619c58b400cc8461fce7662d848a656859b523f68771b9f38231ee5b2dcf7009ad2645691c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000413d2c6a6ad15b15c14897e9feb5e3fd417edcdf091b185dedda62d83fac8c7f92277284d29b26460ff2e6c319ac924edd4649eb7a95ddcd73cc15a81971aacf411b00000000000000000000000000000000000000000000000000000000000000";
    (bool _s, ) = address(gatewayContract).call(_calldata);
    if (_s) return;
  }

  function testSubmitWithdrawal_target_14() public {
    // 0x45b2c5a9b8615bbf55e1e64193690db5341e8c20ce84ea91c0e4ee8060d13fd3   13005654
    vm.prank(0xDe39e26567BC9e1C45e91c0A077DDA7A784846EE);
    bytes
      memory _calldata = hex"fa389659000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000c200000000000000000000000000000000000000000000000000000000000000c300000000000000000000000000000000000000000000000000000000000000d000000000000000000000000000000000000000000000000000000000000000d10000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000180000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000419cc05d910eb5c56a514595cd2075a894a75ba212a46734b1fd1eafbf691afef235b0198699da145bd8108dd980d4b536ccafeefeb25e37ee760d544aa020dffa1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041522c0ed2cf0bc97e36aba6642ccba093eff54551644ee8cf3c072eaf9243c57820d4ae3e0cb13c4e34115f770eca81ae43e11dbeabc8696802fa3e02cd15e5b31c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041bd13543e1218992d9c6910eb1b622e899a20e695aad37c7568e9929a09ea7c79694faeab14519c067934a4a997e3e78b61d4065e9508b16f722f7fa46d77a95a1c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000041d97214b54f41ee01bacaac7341287e0fbe5760578b2958603b2f3cd2542676921ebe738b8bf7d4f1766baec4d922b43351d22d8a7c0d368062850d22b6be127f1c00000000000000000000000000000000000000000000000000000000000000";
    (bool _s, ) = address(gatewayContract).call(_calldata);
    if (_s) return;
  }
}
