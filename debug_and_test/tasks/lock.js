const { task } = require("hardhat/config");

task("accounts", "Prints the list of accounts")
    .addParam("acc", "acount numbers")
    .setAction(async (taskArgs, hre) => {
        const accounts = await hre.ethers.getSigners();
        // for (const account of accounts) {
        //     console.log(account.address);
        // }

        for (let i = 0; i < taskArgs.acc; i++) {
            console.log(accounts[i].address);
        }
    });

