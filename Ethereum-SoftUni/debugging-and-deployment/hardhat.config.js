const env = require("hardhat");

require("@nomicfoundation/hardhat-toolbox");
require("./tasks/index.js");

require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: process.env.WEB3_PROIDER_URL,
      accounts: [process.env.PRIVATE_KEY]
    }
  }

};
