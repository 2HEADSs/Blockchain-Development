task("deploy", "Deploy contract", async(_,hre)=>{
    const ContractFactory = await hre.ethers.getContractFactory("Lock");
    const contract = await ContractFactory.deploy(1738079698);

    console.log("Contract deployed to:", contract.target);
    
})