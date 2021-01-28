const { deployProxy } = require('@openzeppelin/truffle-upgrades');
const game = artifacts.require("Gacha");

module.exports = async function (deployer) {
  const instance = await deployProxy(game, { deployer, unsafeAllowCustomTypes: true });
  console.log('Deployed', instance.address);
};
