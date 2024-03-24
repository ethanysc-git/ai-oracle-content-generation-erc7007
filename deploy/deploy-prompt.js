const { network } = require("hardhat")
const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
    let _aiOracleAddress

    if (chainId == 31337) {
    } else {
        _aiOracleAddress = networkConfig[chainId].aiOracleAddress
    }

    const arguments_prompt = [_aiOracleAddress]
    const prompt = await deploy("Prompt", {
        from: deployer,
        args: arguments_prompt,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })

    log("----------------------------------------------------")
    // Verify the deployment
    if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
        log("Verifying...")
        await verify(prompt.address, arguments_prompt)
    }
}

module.exports.tags = ["all", "prompt"]
