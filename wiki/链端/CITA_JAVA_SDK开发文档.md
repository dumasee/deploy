## 简介

cita-sdk-java 是对以太坊 Web3j 进行改写，适配 CITA 的一个 Java 开发包。cita-sdk-java 集成了与 CITA 客户端交互的功能，可以用来对 CITA 发送交易，系统配置，信息查询。

 ## 特性

- 通过 HTTP 协议，实现了 CITA 所定义的所有 JSON-RPC 方法。
- 可以通过 Solidity 智能合约生成该合约的 Java 类。这个智能合约的 Java 类作为 java 对智能合约的包裹层，可以使开发和通过 java 方便地对智能合约进行部署和合约方法的调用（支持 Solidity 和 Truffle 的格式）。
- 适配安卓

 开始

# 预装组件

Java 8
Gradle 5.0

# 安装

通过远程仓库安装：

```markdown
<dependency>
  <groupId>com.citahub.cita</groupId>
  <artifactId>core</artifactId>
  <version>20.2.0</version>
</dependency>
```

Gradle

```markdown
compile 'com.citahub.cita:core:20.2.0'
```

手动安装
如果你想使用最新的 CITA，编译 CITA 生成 jar 包，并手动引入。

```markdown
git clone https://github.com/citahub/cita-sdk-java.git
gradle shadowJar
```

# 快速教程

# 部署智能合约

与以太坊类似，智能合约是通过发送交易来部署的。CITA 交易对象定义在 [Transaction.java](https://github.com/citahub/cita-sdk-java/blob/master/core/src/main/java/com/citahub/cita/protocol/core/methods/request/Transaction.java)。 在 CITA 交易中，有三个特殊的参数：

- nonce： 随机数或者通过特定的逻辑生成的随机信息，nonce 是为了避免重放攻击。
- quota： 交易执行费用，也就是矿工费，就像以太坊中的 gasPrice * gasLimit。
- valid_until_block： 超时机制，valid_until_block 可以定义的范围是 (currentHeight, currentHeight + 100]。交易在`valid_until_block`之后会作废。

以下是一个智能合约部署的例子。

通过 solc 生成智能合约的二进制文件，命令如下：

根据生成的二进制文件和其他 3 个参数构造一个交易，代码如下：

```java
String contractCode = “6080604052600160005534801561001557600080fd5b5060df806100246000396000f3006080604052600436106049576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806360fe47b114604e5780636d4ce63c146078575b600080fd5b348015605957600080fd5b5060766004803603810190808035906020019092919050505060a0565b005b348015608357600080fd5b50608a60aa565b6040518082815260200191505060405180910390f35b8060008190555050565b600080549050905600a165627a7a723058202dd6056ea84968f05202910ca070fe13f6f46ff5507867f313d9c98bf2d2e55c0029”;
CITAj service = CITAj.build(new HttpService("CITA RPC 地址和端口")));
AppMetaData appMetaData;
appMetaData = service.appMetaData(DefaultBlockParameter.valueOf(”latest“)).send();
String chainIdHex = appMetaData.getAppMetaDataResult().getChainIdV1();
BigInteger chainId = new BigInteger(chainIdHex.substring(2), 16);
int version = appMetaData.getAppMetaDataResult().getVersion();
long currentHeight = service.appBlockNumber().send().getBlockNumber().longValue();
long validUntilBlock = currentHeight + 80;
Random random = new Random(System.currentTimeMillis());
String nonce = String.valueOf(Math.abs(random.nextLong()));
long quota = 1000000;
Transaction tx = Transaction.createContractTransaction(nonce, quota, validUntilBlock, version, chainId,”0", contractCode);
```

用发送者的私钥对交易进行签名然后发送到 CITA 网络，代码如下：

```java
String privateKey = “0x5f0258a4778057a8a7d97809bd209055b2fbafa654ce7d31ec7191066b9225e6”;  your private key
String rawTx = tx.sign(privateKey);
AppSendTransaction result = service.appSendRawTransaction(rawTx).send();
```

请注意因为 CITA 只支持 `sendRawTransaction` 方法而不是 `sendTransaction` ，所以所有发送给 CITA 的交易都需要被签名。

# 调用智能合约的函数

在 CITA 中，正如智能合约的部署，智能合约中函数的调用也是通过发送交易来实现的，调用合约函数的交易是通过两个参数构造的：

- 合约地址： 已部署合约的地址。
- 函数编码数据： 函数以及入参的 ABI 的编码后数据。

智能合约成功部署以后，可以通过交易回执得到合约地址。以下是调用合约函数的例子，在例子中，`functionCallData` 通过对合约 ABI 中的函数名和入参编码得到。入参为 1 的`set()` 函数的编码数据 `functionCallData` 是 `60fe47b10000000000000000000000000000000000000000000000000000000000000001`.

```java
get receipt and address from transaction
String txHash = result.getSendTransactionResult().getHash();
TransactionReceipt txReceipt = service.appGetTransactionReceipt(txHash).send().getTransactionReceipt();
String contractAddr = txReceipt.getContractAddress();
```

```java
sign and send the transaction
List inputParameters = Arrays.asList(new Uint(BigInteger.valueOf(4l)));
String funcData = CITASystemContract.encodeFunction(“set”, inputParameters);
Transaction tx = new Transaction(contractAddr, nonce, 10000000L, validUntilBlock, version, chainId, “0”, funcData);
String rawTx = tx.sign(privateKey);
String txHash = service.appSendRawTransaction(rawTx).send().getSendTransactionResult().getHash();
```

请在 [TokenTransactionTest.java](https://github.com/citahub/cita-sdk-java/blob/master/tests/src/test/java/com/citahub/cita/tests/TokenTransactionTest.java) 中查看完整代码。

# 通过 cita-sdk-java 中的 wrapper 与智能合约交互

以上例子展示了直接通过合约二进制码和函数的编码构造交易，并且发送与链上合约进行交互。除此方法以外，cita-sdk-java 提供了 codeGen 工具可以通过 solidity 合约生成 java 类。通过 cita-sdk-java 生成的 java 类，可以方便对合约进行部署和函数调用。

在 release 页面下载 cita-sdk-java 的 jar 包，或者在源项目中运行 `gradle shadowJar` 生成 jar 包，jar 包会在 `build/libs` 中生成，名字是 `cita-sdk-$version.jar`。

solidity 合约转化为 java 类操作如下：

```dos
$ java -jar cita-sdk-20.2.0.jar solidity generate [–javaTypes|–solidityTypes] /path/to/{smart-contract}.bin /path/to/{smart-contract}.abi -o /path/to/src/main/java -p {package-path}
```

这个例子通过 `Token.sol`, `Token.bin` and `Token.abi` 这三个文件在 `tests/src/main/resources` 生成对应的 java 类，命令如下：

```dos
java -jar build/libs/cita-sdk-20.2.0.jar solidity generate tests/src/main/resources/Token.bin tests/src/main/resources/Token.abi -o tests/src/main/java/ -p com.citahub.cita.tests
```

`Token.java` 会通过以上命令生成， `Token` 可以与 `TransactionManager` 一起使用来和 Token 合约交互。请注意在 CITA 中应该使用 [TransactionManager](https://github.com/citahub/cita-sdk-java/blob/master/core/src/main/java/com/citahub/cita/tx/TransactionManager.java) 而不是 TransactionManager。 请在 [TokenCodegenTest.java](https://github.com/citahub/cita-sdk-java/blob/master/tests/src/test/java/com/citahub/cita/tests/TokenCodegenTest.java) 查看完整代码.

# 通过 CITAj 中的 Account 与智能合约交互（测试阶段）

cita-sdk-java 还提供了接口 [Account](https://github.com/citahub/cita-sdk-java/blob/master/core/src/main/java/com/citahub/cita/protocol/account/Account.java) 与智能合约交互。 通过智能合约的名字，地址，函数名和函数入参，Account 可以进行合约的部署和合约函数的调用。通过 Account 这个方式，开发者无需进行合约二进制文件和 abi 细节处理。

合约部署示例代码：

```java
 Deploy contract in sync and async way. public AppSendTransaction deploy(File contractFile, String nonce, BigInteger quota)
public Future deployAsync(File contractFile, String nonce, BigInteger quota)
```

合约函数调用示例代码：

```java
public Object callContract(String contractAddress, String funcName, String nonce, BigInteger quota, Object… args)

function is a encapsulation of method including name, argument datatypes, return type and other info.
public Object callContract(String contractAddress, AbiDefinition functionAbi, String nonce, BigInteger quota, Object… args)
```

虽然在第一次部署合约的时候需要提供合约文件，但是在以后调用合约函数的时候 cita-sdk-java 通过 CITA 提供的 getAbi 接口根据合约地址得到对应的 abi。
请在 [TokenAccountTest](https://github.com/citahub/cita-sdk-java/blob/master/tests/src/test/java/com/citahub/cita/tests/TokenTransactionTest.java) 中查看完整代码。