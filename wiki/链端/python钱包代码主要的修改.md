1、以太坊区块数以及交易详情获取
https://mainnet.infura.io获取区块数以及交易详情

2、充值交易均会返回from_address

3、每个已经录入的提现任务，调用节点的交易回执接口，确定充值已经到账则更改充值数据状态，发送通知消息给kafka，通知java程序完成充值到账
```
def wallet_transaction_withdrawal_comfirm(series='eth'):
    client = get_client(series, 'withdrawal')
    worker_logger.info("")
    block_number = client.get_latest_blocknumber()
    if isinstance(block_number, str):
        worker_logger.warning("eth confirm, get latest block number wrong!")
        return False
    transactions = WithDrawalTransaction.query.filter(WithDrawalTransaction.status == 4).filter(DepositTranscation.coin_code == series).all()
    worker_logger.info("%s confirm, wait confirm transaction:%s" % (series, [t.id for t in transactions]))
    for index, transaction in enumerate(transactions):
        status = client.check_transaction_valid(transaction.tx_id)
        transaction.block_number = client.getBlockNumbyTxid(transaction.txid)
        if status == 0:
            transaction.status = 4
            worker_logger.info("%s confirmed, failed transaction %s ." % (series, transaction.tx_id))
        elif status == 1:
            transaction.status = 3
            worker_logger.info("%s confirmed, succeeded transaction %s ." % (series, transaction.tx_id))
        else:
            worker_logger.info(
                "%s confirmed, no receipt transaction %s for msg %s." % (series, transaction.tx_id, status))
            continue
        worker_logger.info("%s confirmed, %s" % (series, sqlalchemy_object_to_json(transaction)))
        transaction_json = sqlalchemy_object_to_json(transaction)
        withdrawal_producer.send_json_or_dict(transaction_json)
        db.session.commit()
```