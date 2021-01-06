const HDWalletProvider = require('truffle-hdwallet-provider');

const fs = require('fs');
const Seed_Phrase = fs.readFileSync(".secret").toString().trim();
const Infura_Link = "https://rinkeby.infura.io/v3/9d7bc8e7778a4a4f8e789f935bb51687"

module.exports = {
  networks: {
    rinkeby: {
      provider: () => new HDWalletProvider(Seed_Phrase, Infura_Link),
      network_id: 4,       // Ropsten's id
      gas: 5500000,        // Ropsten has a lower block limit than mainnet
      confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    }
  },

  mocha: {
  },

  compilers: {
    solc: {
    }
  },


};
