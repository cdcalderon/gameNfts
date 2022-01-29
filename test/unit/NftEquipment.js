const { assert, expect } = require("chai")
const { network, deployments, getNamedAccounts, ethers } = require("hardhat")

!developmentChains.includes(network.name)
    ? describe.skip
    : describe("NftEquipment Unit Tests", () => {
          let nftEquipment, nftEquipmentContract
          const chainId = network.config.chainId

          beforeEach(async () => {
              const { deployer } = await getNamedAccounts()
              await deployments.fixture(["all"])
              nftEquipmentContract = await ethers.getContract("NftEquipment")
              nftEquipment = await ethers.getContract("NftEquipment", deployer)
          })
      })
