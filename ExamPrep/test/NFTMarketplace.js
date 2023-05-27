const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("NFTMarketplace", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployAndMint() {
    // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    // const ONE_GWEI = 1_000_000_000;

    // const lockedAmount = ONE_GWEI;
    // const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;

    // Contracts are deployed using the first signer/account by default
    const [deployer, firstUser] = await ethers.getSigners();

    const MarketplaceFactory = await ethers.getContractFactory("NFTMarketplace", deployer);

    const marketplace = await Marketplaceock.deploy();

    const marketplaceFirstUser = marketplace.connect(firstUser);

    const tx = await marketplace.createNFT("ttest");

    return { marketplace, deployer, firstUser };
  }

  describe("Listing", function () {
    it("Revert when price == 0", async function () {
      const { marketplace, deployer } = await loadFixture(deployAndMint);

      await expect(marketplace.listNFT(marketplace.address, 0, 0)).to.be.revertedWith("price must be greater than 0")

      expect(await lock.unlockTime()).to.equal(unlockTime);
    });
  })
});
