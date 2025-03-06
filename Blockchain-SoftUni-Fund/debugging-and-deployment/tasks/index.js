const { task } = require("hardhat/config");

task("deploy", "Deploy contract", async (taskArgs, hre) => {
    if (!taskArgs.unlockTime) {
        throw new Error("unlocTtime is required")
    }

    const ContractFactory = await hre.ethers.getContractFactory("Lock");
    const contract = await ContractFactory.deploy(taskArgs.unlockTime);

    console.log("Contract deployed to:", contract.target);
    const res = await contract.waitForDeployment();

    const unlockTimeSet = await contract.unlockTime();
    if (unlockTimeSet.toString() !== taskArgs.unlockTime) {
        throw new Error("unlockTime was not set correctly")
    }
}).addParam("unlockTime", "The unix timestamp after which the contract will be unlocked.")