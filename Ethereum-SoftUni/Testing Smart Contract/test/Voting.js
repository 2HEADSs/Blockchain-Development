const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers")
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
        });

        expect(await VotingContract.owner()).to.be.equal(deployer.addres);
    });
});