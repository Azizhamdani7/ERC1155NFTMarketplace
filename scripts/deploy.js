async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  const ERC1155Token = await ethers.getContractFactory("erc1155");
  console.log("Deploying ERC1155 Contract");
  const instance = await ERC1155Token.deploy();
  
  await instance.deployed();

  console.log("ERC155 contract deployed at: ", instance.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });