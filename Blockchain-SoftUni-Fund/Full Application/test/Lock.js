// const {
//   time,
//   loadFixture,
// } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
// const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
// const { expect } = require("chai");
// const { ethers } = require("hardhat");

// describe("CrowdSale", function () {
//   const ONE_WEEK = 7 * 24 * 60 * 60;

//   async function initialDeployFixture() {
//     // Contracts are deployed using the first signer/account by default
//     const [owner, otherAccount, feeReceiver] = await ethers.getSigners();

//     const CustomTokenFactory = await ethers.getContractFactory("CustomToken");
//     const customToken = await CustomTokenFactory.deploy();

//     const CrowdSaleFactory = await ethers.getContractFactory("CrowdSale");
//     const crowdsale = await CrowdSaleFactory.deploy(owner);

//     const latestTimestamp = await time.latest();
//     const nextBlockTimestamo = latestTimestamp + 10;
//     await time.setNextBlockTimestamp(nextBlockTimestamo);

//     const startTime = nextBlockTimestamo + 1000;
//     const endTime = startTime + ONE_WEEK;
//     const tokensToSale = ethers.parseUnits("50000", 8);
//     await customToken.approve(crowdsale.getAddress(), tokensToSale)

//     await crowdsale.initialize(
//       startTime,
//       endTime,
//       50,
//       feeReceiver.address,
//       await customToken.getAddress(),
//       tokensToSale
//     );

//     return {
//       crowdsale,
//       customToken,
//       owner,
//       otherAccount,
//       feeReceiver,
//       startTime,
//       endTime,
//       tokensToSale
//     };
//   }

//   describe("Buy token", function () {
//     it("Should revert if sale ended", async function () {

//       const { crowdsale, endTime, otherAccount } = await loadFixture(initialDeployFixture);

//       await time.increaseTo(endTime + 1);
//       await expect(crowdsale.connect(otherAccount).buyShares(otherAccount.address)
//       ).to.be.revertedWithCustomError(crowdsale, "OutOfSalePeriod");
//     });

//     it("Should send tokens on success", async function () {

//       const { crowdsale, otherAccount, startTime } = await loadFixture(initialDeployFixture);

//       await time.increaseTo(startTime + 10000);

//       const amount = ethers.parseEther("0.5");
//       await expect(crowdsale.connect(otherAccount).buyShares(otherAccount.address, { value: amount })
//       ).to.changeEtherBalances([otherAccount, crowdsale], [-amount, amount]);
//     });
//   })

//   describe("FinalizeSale", function () {
//     it("Should revert if already finished", async function () {

//       const { crowdsale, owner, startTime, otherAccount } = await loadFixture(initialDeployFixture);

//       await time.increaseTo(startTime + 10000);

//       const amount = ethers.parseEther("0.5");
//       await crowdsale
//         .connect(otherAccount)
//         .buyShares(otherAccount.address, { value: amount });

//       await expect(
//         crowdsale.connect(owner).finalizeSale()
//       ).to.be.revertedWithCustomError(crowdsale, "SaleIsStillActive")
//     });


//     it("Should successfuly finish sale and withdraw profit", async function () {

//       const { crowdsale,
//         owner,
//         startTime,
//         otherAccount,
//         customToken,
//         tokensToSale,
//         endTime
//       } = await loadFixture(initialDeployFixture);

//       await time.increaseTo(startTime + 10000);

//       const amount = ethers.parseEther("0.5");
//       const tokensToReceive = ethers.parseUnits("25", 8);

//       await expect(await crowdsale
//         .connect(otherAccount)
//         .buyShares(otherAccount.address, { value: amount })
//       ).to.changeTokenBalances(
//         customToken,
//         [otherAccount, await crowdsale.getAddress()],
//         [tokensToReceive, -tokensToReceive]
//       );

//       time.increaseTo(endTime + 1);

//       await expect(
//         crowdsale.connect(owner).finalizeSale()
//       ).to.changeTokenBalances(
//         customToken,
//         [owner, await crowdsale.getAddress()],
//         [tokensToSale - tokensToReceive, (tokensToSale - tokensToReceive) * -1n]
//       );
//     });

//   })
// });
