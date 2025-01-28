task("deploy", "Deploy contract", async (_, hre) => {
    if (!taskArgs.unlockTime) {
        throw new Error("unlocTtime is required")
    }

    const ContractFactory = await hre.ethers.getContractFactory("Lock");
    const contract = await ContractFactory.deploy(1738079698);

    console.log("Contract deployed to:", contract.target);
}).addParam("unlockTime", "The unix timestamp after which the contract will be unlocked.")