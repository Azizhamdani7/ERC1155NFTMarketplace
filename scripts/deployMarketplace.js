async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
  
    const MARKETPLACE = await ethers.getContractFactory("Marketplace");
    console.log("Deploying Marketplace Contract");
    const instance = await MARKETPLACE.deploy();
    
    await instance.deployed();
  
    console.log("ERC155 contract deployed at: ", instance.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });