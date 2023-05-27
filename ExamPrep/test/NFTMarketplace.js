const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

describe("NFTMarketplace", function () {

  let marketplaceFirstUser, deployer, firstUser;


  this.beforeAll(async function () {
    [deployer, firstUser] = await ethers.getSigners();
    const { marketplace } = await loadFixture(deployAndMint);
    marketplaceFirstUser = getFirstUserMarketPlace(marketplace, firstUser);
  });

  async function deployAndMint() {
    // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    // const ONE_GWEI = 1_000_000_000;

    // const lockedAmount = ONE_GWEI;
    // const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;

    // Contracts are deployed using the first signer/account by default

    const MarketplaceFactory = await ethers.getContractFactory("NFTMarketplace", deployer);

    const marketplace = await MarketplaceFactory.deploy();

    const _marketplaceFirstUser = marketplace.connect(firstUser);

    await _marketplaceFirstUser.createNFT("ttest");

    return { marketplace, deployer, firstUser };
  }

  describe("Listing", function () {
    it("reverts when price == 0", async function () {
      console.log('hi');
      const { marketplace, deployer } = await loadFixture(deployAndMint);

      await expect(marketplace.listNFTForSale(marketplace.address, 0, 0))
        .to.be.revertedWith("price must be greater than 0");
    });
  });

  it("reverts when already listed", async function () {
    const { marketplace, deployer } = await loadFixture(deployAndMint);

    const price = ethers.utils.parseEther("1");
    await marketplaceFirstUser.approve(marketplace.address, 0)
    await marketplaceFirstUser.listNFTForSale(marketplace.address, 0, price);

    await expect(marketplaceFirstUser.listNFTForSale(marketplace.address, 0, price))
      .to.be.revertedWith("NFT is already listed for sale");
  });
});


function getFirstUserMarketPlace(marketplace, firstUser) {
  return marketplace.connect(firstUser);
};