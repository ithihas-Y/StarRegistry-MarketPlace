const Web3 = require("web3");

const web3 = new Web3("https://kovan.infura.io/v3/b3866b1857994f17b06df9cd3d915610");

const marketPlace = require("../build/contracts/StarRegistry.json")

const abi = marketPlace.abi;

const accountObj =web3.eth.accounts.privateKeyToAccount("88ec91095776157552212f5d7a79705131878c440980ebff564b19300c29bc2b")

const contract = new web3.eth.Contract(abi,"0x3f2202f7180C8485368156E983A0f21E4d703E9F");

const acc = accountObj.address

contract.methods.createNFT(11,10000).send({
    from:acc,
}).then(console.log).catch(console.error)

/** 
const tx = {
    from:acc,
    to:contract.options.address,
    gas:300000000,
    data:contract.methods.createNFT(11,10000).encodeABI()
}

signedTx0 =web3.eth.accounts.signTransaction(tx, "88ec91095776157552212f5d7a79705131878c440980ebff564b19300c29bc2b")

const serializedTx = signedTx0.serialize();

web3.eth.sendSignedTransaction('0x' + serializedTx.toString('hex'))
.on('receipt', console.log);
*/
            



