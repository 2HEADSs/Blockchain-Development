const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("CrowdSale", function () {

  async function initialDeployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount, feeReceiver] = await ethers.getSigners();

    const CustomTokenFactory = await ethers.getContractFactory("CustomToken");
    const customToken = await CustomTokenFactory.deploy();

    const CrowdSaleFactory = await ethers.getContractFactory("CrowdSale");
    const crowdsale = await CrowdSaleFactory.deploy(owner);

    const latestTimestamp = await time.latest();
    const nextBlockTimestamo = latestTimestamp + 10;
    await time.setNextBlockTimestamp(nextBlockTimestamo);

    const ONE_WEEK = 7 * 24 * 60 * 60;
    const startTime = nextBlockTimestamo + 1000;
    const endTime = startTime + ONE_WEEK;
    const tokensToSale = ethers.parseUnits("50000", 8);
    await customToken.approve(crowdsale.getAddress(), tokensToSale)

    await crowdsale.initialize(
      startTime,
      endTime,
      50,
      feeReceiver.address,
      await customToken.getAddress(),
      tokensToSale
    );

    return {
      crowdsale,
      customToken,
      owner,
      otherAccount,
      feeReceiver,
      startTime,
      endTime,
    };
  }

  describe("Buy token", function () {
    it("Should revert if sale ended", async function () {

      const { crowdsale, owner, endTime, otherAccount } = await loadFixture(initialDeployFixture);

      await time.increaseTo(endTime + 1);
      await expect(crowdsale.connect(otherAccount).buyShares(otherAccount.address)
      ).to.be.revertedWithCustomError(crowdsale, "OutOfSalePeriod");
    })
  })

});
