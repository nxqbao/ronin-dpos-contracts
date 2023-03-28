import { anyValue } from '@nomicfoundation/hardhat-chai-matchers/withArgs';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { expect } from 'chai';
import { BigNumber, BigNumberish, ContractTransaction } from 'ethers';
import { ethers, network } from 'hardhat';

import { Staking, Staking__factory, TransparentUpgradeableProxyV2__factory } from '../../src/types';
import { MockValidatorSet__factory } from '../../src/types/factories/MockValidatorSet__factory';
import { StakingVesting__factory } from '../../src/types/factories/StakingVesting__factory';
import { MockValidatorSet } from '../../src/types/MockValidatorSet';
import { createManyValidatorCandidateAddressSets, ValidatorCandidateAddressSet } from '../helpers/address-set-types';
import { getLastBlockTimestamp } from '../helpers/utils';

let coinbase: SignerWithAddress;
let deployer: SignerWithAddress;

let proxyAdmin: SignerWithAddress;
let userA: SignerWithAddress;
let userB: SignerWithAddress;
let poolAddrSet: ValidatorCandidateAddressSet;
let otherPoolAddrSet: ValidatorCandidateAddressSet;
let anotherActivePoolSet: ValidatorCandidateAddressSet;
let sparePoolAddrSet: ValidatorCandidateAddressSet;

let validatorContract: MockValidatorSet;
let stakingContract: Staking;
let signers: SignerWithAddress[];
let validatorCandidates: ValidatorCandidateAddressSet[];

const ONE_DAY = 60 * 60 * 24;

const minValidatorStakingAmount = BigNumber.from(2_000_000);
const maxValidatorCandidate = 50;
const numberOfBlocksInEpoch = 2;
const cooldownSecsToUndelegate = 3 * 86400;
const waitingSecsToRevoke = 7 * 86400;
const maxCommissionRate = 30_00;
const minEffectiveDaysOnwards = 7;
const numberOfCandidate = 4;

describe('Staking test', () => {
  before(async () => {
    [coinbase, deployer, proxyAdmin, userA, userB, ...signers] = await ethers.getSigners();
    validatorCandidates = createManyValidatorCandidateAddressSets(signers.slice(0, numberOfCandidate * 3));
    sparePoolAddrSet = validatorCandidates.splice(validatorCandidates.length - 1)[0];

    const stakingVestingContract = await new StakingVesting__factory(deployer).deploy();
    const nonce = await deployer.getTransactionCount();
    const stakingContractAddr = ethers.utils.getContractAddress({ from: deployer.address, nonce: nonce + 2 });
    validatorContract = await new MockValidatorSet__factory(deployer).deploy(
      stakingContractAddr,
      ethers.constants.AddressZero,
      stakingVestingContract.address,
      maxValidatorCandidate,
      numberOfBlocksInEpoch,
      minEffectiveDaysOnwards
    );
    await validatorContract.deployed();
    const logicContract = await new Staking__factory(deployer).deploy();
    await logicContract.deployed();
    const proxyContract = await new TransparentUpgradeableProxyV2__factory(deployer).deploy(
      logicContract.address,
      proxyAdmin.address,
      logicContract.interface.encodeFunctionData('initialize', [
        validatorContract.address,
        minValidatorStakingAmount,
        maxCommissionRate,
        cooldownSecsToUndelegate,
        waitingSecsToRevoke,
      ])
    );
    await proxyContract.deployed();
    stakingContract = Staking__factory.connect(proxyContract.address, deployer);
    expect(stakingContractAddr.toLowerCase()).eq(stakingContract.address.toLowerCase());
  });

  describe('Validator candidate test', () => {
    it('Should be able to propose validator with sufficient amount', async () => {
      for (let i = 0; i < validatorCandidates.length; i++) {
        const candidate = validatorCandidates[i];
        const tx = await stakingContract
          .connect(candidate.poolAdmin)
          .applyValidatorCandidate(
            candidate.candidateAdmin.address,
            candidate.consensusAddr.address,
            candidate.treasuryAddr.address,
            candidate.bridgeOperator.address,
            1,
            /* 0.01% */ { value: minValidatorStakingAmount.mul(2) }
          );
        await expect(tx)
          .emit(stakingContract, 'PoolApproved')
          .withArgs(candidate.consensusAddr.address, candidate.poolAdmin.address);
      }

      poolAddrSet = validatorCandidates[0];
      expect(await stakingContract.getStakingTotal(poolAddrSet.consensusAddr.address)).eq(
        minValidatorStakingAmount.mul(2)
      );
    });
  });
});
