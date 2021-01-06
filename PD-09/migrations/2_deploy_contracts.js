const game = artifacts.require("Gacha");

module.exports = function (deployer) {
  deployer.deploy(game);
};
