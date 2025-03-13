const { task } = require("hardhat/config");

task("deploy", "Deploys NFT and AuctionHouse contracts")
    .addParam("owner", "Initial owner of NFT contract")
    .setAction(async (taskArgs, hre) => {
        const [deployer] = await hre.ethers.getSigners();
        console.log("Deploying contracts with account:", deployer.address);

        // CustomToken
        const CustomToken = await hre.ethers.getContractFactory("NFT");
        console.log(taskArgs.owner);
        const customToken = await CustomToken.deploy(taskArgs.owner);

        await customToken.waitForDeployment();

        console.log("CustomToken deployed to:", await customToken.getAddress());

        // AuctionHouse
        const AuctionHouse = await hre.ethers.getContractFactory("AuctionHouse");
        const auctionHouse = await AuctionHouse.deploy();
        await auctionHouse.waitForDeployment();
        console.log("AuctionHouse deployed to:", await auctionHouse.getAddress());

        // Verify contracts if on Sepolia
        if (hre.network.name === "sepolia") {
            console.log("\nVerifying contracts on Sepolia...");

            // Wait for a few block confirmations
            console.log("Waiting for block confirmations...");
            await customToken.deploymentTransaction().wait(5);
            await auctionHouse.deploymentTransaction().wait(5);

            // Verify CustomToken
            try {
                await hre.run("verify:verify", {
                    address: await customToken.getAddress(),
                    constructorArguments: [taskArgs.owner],
                });
                console.log("CustomToken verified successfully");
            } catch (error) {
                console.log("CustomToken verification failed:", error.message);
            }

            // Verify AuctionHouse
            try {
                await hre.run("verify:verify", {
                    address: await auctionHouse.getAddress(),
                    constructorArguments: [],
                });
                console.log("auctionHouse verified successfully");
            } catch (error) {
                console.log("auctionHouse verification failed:", error.message);
            }
        }

        console.log("\nDeployment Summary:");
        console.log("-------------------");
        console.log("CustomToken:", await customToken.getAddress());
        console.log("auctionHouse:", await auctionHouse.getAddress());
    });