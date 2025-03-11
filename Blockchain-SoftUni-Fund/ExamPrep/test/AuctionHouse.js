const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Crowdsale", function () {
  const TOKEN_ID = 1

  async function initialDeployFixture() {
    // Contracts are deployed using the first signer/account by default
    const [seller, bidder, bidderTwo] = await ethers.getSigners();

    const CustomTokenFactory = await ethers.getContractFactory("NFT");
    const nftContract = await CustomTokenFactory.deploy(seller.address);

    const AuctionHouseFactory = await ethers.getContractFactory("AuctionHouse");
    const auctionContract = await AuctionHouseFactory.deploy();

    return {
      nftContract,
      auctionContract,
      seller,
      bidder,
      bidderTwo,
    };
  }

  describe("Create Auction", function () {

    it("Should revert if min price <0", async function () {
      const { auctionContract, seller, nftContract } = await loadFixture(
        initialDeployFixture
      );

      await expect(
        auctionContract.connect(seller).createAuction(
          TOKEN_ID,
          await nftContract.getAddress(),
          0, 0, 0, 0, 0, 0
        )
      ).to.be.revertedWithCustomError(auctionContract, "CannotBeZero");
    });

    it("Should revert start time is before current block time stamp", async function () {
      const { auctionContract, seller, nftContract } = await loadFixture(
        initialDeployFixture
      );
      const latest = await time.latestBlock();
      const next = latest + 2;
      time.setNextBlockTimestamp(next);

      await expect(
        auctionContract.connect(seller).createAuction(
          TOKEN_ID,
          await nftContract.getAddress(),
          1, next - 1, 0, 0, 0, 0
        )
      ).to.be.revertedWithCustomError(auctionContract, "InvalidStartTime");
    });
  });
});