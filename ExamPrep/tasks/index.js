task("deploy", "Prints an account's balance")
    .addParam("account", "The account's address")
    .setAction(async () => {
        const Lock = await hre.ethers.getContractFactory("Lock");
        const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

        await lock.deployed();

        console.log(
            `Lock with ${ethers.utils.formatEther(
                lockedAmount
            )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`
        );
    });