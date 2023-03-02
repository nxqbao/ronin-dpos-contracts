pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract MyContractTest is Test {
  function testWhatever(uint256 var1) public {
    uint256 var2 = var1;
    assertEq(var1, var2);
  }

  function testUrl() public {
    string memory url = vm.rpcUrl("devnet");
    assertEq(url, "https://hcm-devnet.skymavis.one/rpc");
  }
}
