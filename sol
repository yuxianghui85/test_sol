const Web3 = require('web3');
const { abi } = require('./OKBToken.json'); // 从编译后的代币合约中导入 ABI
const { address: tokenAddress } = require('./OKBToken.json'); // 从编译后的代币合约中导入合约地址

// 连接到以太坊节点
const web3 = new Web3('https://mainnet.infura.io/v3/your_infura_project_id');

// 设置发送者地址和私钥
const senderAddress = '0xYourSenderAddress';
const privateKey = '0xYourPrivateKey';

// 设置接收者地址
const recipientAddress = '0xRecipientAddress';

// 实例化代币合约
const tokenContract = new web3.eth.Contract(abi, tokenAddress);

// 设置转账金额（以最小单位为单位，例如对于 18 位小数的代币，1 个代币的最小单位为 10^18）
const amount = web3.utils.toBN(web3.utils.toWei('100', 'ether'));

// 构造交易对象
const txObject = {
  from: senderAddress,
  to: tokenAddress,
  gas: 100000, // 设置 gas 限额
  gasPrice: web3.utils.toWei('10', 'gwei'), // 设置 gas 价格
  data: tokenContract.methods.transfer(recipientAddress, amount).encodeABI(), // 调用代币合约的转账方法
};

// 签名并发送交易
web3.eth.accounts.signTransaction(txObject, privateKey)
  .then(signedTx => {
    return web3.eth.sendSignedTransaction(signedTx.rawTransaction);
  })
  .then(receipt => {
    console.log('Transaction receipt:', receipt);
  })
  .catch(error => {
    console.error('Error occurred:', error);
  });
