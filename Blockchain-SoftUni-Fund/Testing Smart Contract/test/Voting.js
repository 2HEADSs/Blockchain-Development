const { loadFixture, } = require("@nomicfoundation/hardhat-toolbox/network-helpers")
const { expect } = require("chai");

describe.only("Voting", function () {
    async function deployVotingFixture() {
        const [deployer] = await ethers.getSigners();

        const VotingFactory = await ethers.getContractFactory("VotingSystem");
        const VotingContract = await VotingFactory.deploy();

        return { VotingContract, deployer };
    }

    describe("Deployment", async function () {
        it("Should set the right owner", async function () {
            const { VotingContract, deployer } = await loadFixture(deployVotingFixture);
            expect(await VotingContract.owner()).to.be.equal(deployer.address);
        });

        it("Should set proposal count to 0", async function () {
            const { VotingContract, deployer } = await loadFixture(deployVotingFixture);
            expect(await VotingContract.proposalCount()).to.be.equal(0);
        });
    });

    describe("createProposal()", function () {
        it("Should revert when caller is not owner", async function () {
            const { VotingContract } = await loadFixture(deployVotingFixture);
            const [, user] = await ethers.getSigners();
            await expect(VotingContract.connect(user).createProposal("testDescription", 1)
            ).to.be.revertedWithCustomError(VotingContract, "NotOwner");
        });


        it("Should revert when voting period is zero", async function () {
            const { VotingContract } = await loadFixture(deployVotingFixture);
            await expect(VotingContract.createProposal("testDescription", 0)
            ).to.be.revertedWithCustomError(VotingContract, "InvalidVotingPeriod");
        });
    })

});