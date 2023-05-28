task("deploy", "Prints an account's balance")
    .addParam("account", "The account's address")
    .setAction(async () => {
        const [deployer] = await ethers.getSigners();
        const MarketplaceFactory = await ethers.getContractFactory("NFTMarketplace", deployer);

        const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

        await lock.deployed();

        console.log(
            `Lock with ${ethers.utils.formatEther(
                lockedAmount
            )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`
        );
    });