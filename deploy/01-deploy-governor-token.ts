import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"
import verify from "../helper-functions"
import { networkConfig, developmentChains } from "../helper-hardhat-config"
import { ethers } from "hardhat"

const deployGovernanceToken: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  // @ts-ignore
  const { getNamedAccounts, deployments, network } = hre
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  log("----------------------------------------------------")
  log("Deploying BlacktownToken and waiting for confirmations...")
  const governanceToken = await deploy("BlacktownToken", {
    from: deployer,
    args: [],
    log: true,
    // we need to wait if on a live network so we can verify properly
    waitConfirmations: networkConfig[network.name].blockConfirmations || 1,
  })
  log(`BlacktownToken at ${governanceToken.address}`)
  if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
    await verify(governanceToken.address, [])
  }
  log(`Delegating to ${deployer}`)
  await delegate(governanceToken.address, deployer)
  log("Delegated!")
}

const delegate = async (governanceTokenAddress: string, delegatedAccount: string) => {
  const governanceToken = await ethers.getContractAt("BlacktownToken", governanceTokenAddress)
  const transactionResponse = await governanceToken.delegate(delegatedAccount)
  await transactionResponse.wait(1)
  console.log(`Checkpoints: ${await governanceToken.numCheckpoints(delegatedAccount)}`)
}

export default deployGovernanceToken
deployGovernanceToken.tags = ["all", "governor"]
