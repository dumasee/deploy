1. fullnode 节点从timelord 或其它fullnode节点获取signage_point,广播给farmer节点。
2. farmer从full_node获取挑战数据，广播给所有的harvester，并保存Signage points和cache_add_time。
3. harvester的new_signage_point_harvester首先在passes_plot_filter中计算plot_id, challenge_hash, signage_point前9位是否为0，排除511/512的文件，
剩下的并行执行blocking_lookup计算挑战，计算通过的给farmer发送new_proof_of_space。
4. farmer收到new_proof_of_space，计算quality_string , required_iters,给对应的harvester发送request_signatures，并进行矿池逻辑的一些计算。
5. harvester收到request_signatures, 生成plot公钥并做签名，返回respond_signatures
6. farmer收到respond_signatures,判断是sps的签名还是block的签名，并分别根据两种情况生成应答给full_node.
 sps签名是declare_proof_of_space，block签名是signed_values消息。
7. full_node收到declare_proof_of_space，生成区块数据，加入备选区块，给farmer发送request_signed_values。
8. farmer收到request_signed_values,解析node_id(harvester),发送request_signatures。
9. full_node收到signed_values，创建一个unfinished_block,验证是否是正确的block,然后推送到其他full_node和timelords.