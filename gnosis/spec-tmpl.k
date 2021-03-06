  // {RULENAME} {COMMENT}
  rule
    <k> {K} </k>
    <exit-code> 1 </exit-code>
    <mode> NORMAL </mode>
    <schedule> BYZANTIUM </schedule>
    <ethereum>
      <evm>
        <output> {OUTPUT} </output>
        <statusCode> {STATUSCODE} </statusCode>
        <callStack> {CALLSTACK} </callStack>
        <interimStates> _ </interimStates>
        <touchedAccounts> _ => _ </touchedAccounts>
        <callState>
          <program> #asMapOpCodes(#dasmOpCodes(#parseByteStack({CODE}), BYZANTIUM)) </program>
          <programBytes> #parseByteStack({CODE}) </programBytes>
          <id> {THIS} </id> // this
          <caller> {MSG_SENDER} </caller> // msg.sender
          <callData> {CALLDATA} </callData> // msg.data
          <callValue> {CALLVALUE} </callValue> // msg.value
          <wordStack> {WORDSTACK} </wordStack>
          <localMem> {LOCALMEM} </localMem>
          <pc> {PC} </pc>
          <gas> {GAS} </gas>
          <memoryUsed> {MEMORYUSED} </memoryUsed>
          <callGas> _ => _ </callGas>
          <static> false </static> // NOTE: non-static call
          <callDepth> {CALLDEPTH} </callDepth>
        </callState>
        <substate>
          <selfDestruct> _ </selfDestruct>
          <log> {LOG} </log>
          <refund> {REFUND} </refund>
        </substate>
        <gasPrice> _ </gasPrice>
        <origin> ORIGIN_ID </origin> // tx.origin
        <previousHash> _ </previousHash>
        <ommersHash> _ </ommersHash>
        <coinbase> {COINBASE} </coinbase> // block.coinbase
        <stateRoot> _ </stateRoot>
        <transactionsRoot> _ </transactionsRoot>
        <receiptsRoot> _ </receiptsRoot>
        <logsBloom> _ </logsBloom>
        <difficulty> _ </difficulty>
        <number> BLOCK_NUM </number> // block.number
        <gasLimit> _ </gasLimit>
        <gasUsed> _ </gasUsed>
        <timestamp> NOW </timestamp> // now = block.timestamp
        <extraData> _ </extraData>
        <mixHash> _ </mixHash>
        <blockNonce> _ </blockNonce>
        <ommerBlockHeaders> _ </ommerBlockHeaders>
        <blockhash> BLOCK_HASHES </blockhash> // block.blockhash
      </evm>
      <network>
        <activeAccounts> {ACTIVEACCOUNTS} </activeAccounts>
        <accounts>
          <account>
            <acctID> #MASTER_COPY_ID </acctID>
            <balance> {MASTER_COPY_BAL} </balance>
            <code> #parseByteStack({MASTER_COPY_CODE}) </code>
            <storage>
{MASTER_COPY_STORAGE}
            </storage>
            <origStorage>
{MASTER_COPY_ORIGSTORAGE}
            </origStorage>
            <nonce> {MASTER_COPY_NONCE} </nonce>
          </account>

          <account>
            <acctID> #PROXY_ID </acctID>
            <balance> {PROXY_BAL} </balance>
            <code> #parseByteStack({PROXY_CODE}) </code>
            <storage>
{PROXY_STORAGE}
            </storage>
            <origStorage>
{PROXY_ORIGSTORAGE}
            </origStorage>
            <nonce> {PROXY_NONCE} </nonce>
          </account>

          <account>
            <acctID> #ORIGIN_ID </acctID>
            <balance> {ORIGIN_BAL} </balance>
            <code> {ORIGIN_CODE} </code>
            <storage>
{ORIGIN_STORAGE}
            </storage>
            <origStorage>
{ORIGIN_ORIGSTORAGE}
            </origStorage>
            <nonce> {ORIGIN_NONCE} </nonce>
          </account>

          <account>
            <acctID> #EXEC_ACCT_TO </acctID>
            <balance> {ACCT_TO_BAL} </balance>
            <code> {ACCT_TO_CODE} </code>
            <storage>
{ACCT_TO_STORAGE}
            </storage>
            <origStorage>
{ACCT_TO_ORIGSTORAGE}
            </origStorage>
            <nonce> {ACCT_TO_NONCE} </nonce>
          </account>

          <account>
            <acctID> #REFUND_RECEIVER </acctID>
            <balance> {RECEIVER_BAL} </balance>
            <code> {RECEIVER_CODE} </code>
            <storage>
{RECEIVER_STORAGE}
            </storage>
            <origStorage>
{RECEIVER_ORIGSTORAGE}
            </origStorage>
            <nonce> {RECEIVER_NONCE} </nonce>
          </account>

          <account>
            <acctID> #TOKEN_CONTRACT </acctID>
            <balance> {TOKEN_CONTRACT_BAL} </balance>
            <code> {TOKEN_CONTRACT_CODE} </code>
            <storage>
{TOKEN_CONTRACT_STORAGE}
            </storage>
            <origStorage>
{TOKEN_CONTRACT_ORIGSTORAGE}
            </origStorage>
            <nonce> {TOKEN_CONTRACT_NONCE} </nonce>
          </account>

          <account>
            // precompiled account for ECCREC
            <acctID> 1 </acctID>
            <balance> 0 </balance>
            <code> .WordStack </code>
            <storage> .Map </storage>
            <origStorage> .Map </origStorage>
            <nonce> 0 </nonce>
          </account>

{ACCOUNTS}
          ...
        </accounts>
        <txOrder> _ </txOrder>
        <txPending> _ </txPending>
        <messages> _ </messages>
      </network>
    </ethereum>
    requires #rangeAddress(ORIGIN_ID)
     andBool #rangeAddress(#MASTER_COPY_ID)
     andBool #rangeAddress(#PROXY_ID)
     andBool #rangeAddress(#ORIGIN_ID)
     andBool #rangeAddress(#EXEC_ACCT_TO)
     andBool #rangeAddress(#REFUND_RECEIVER)
     andBool #rangeAddress(#TOKEN_CONTRACT)
     andBool #rangeUInt(256, NOW)
     andBool #rangeUInt(128, BLOCK_NUM) // Solidity

     andBool #MASTER_COPY_ID  =/=Int #PROXY_ID
     andBool #MASTER_COPY_ID  =/=Int #ORIGIN_ID
     andBool #MASTER_COPY_ID  =/=Int #EXEC_ACCT_TO
     andBool #MASTER_COPY_ID  =/=Int #REFUND_RECEIVER
     andBool #MASTER_COPY_ID  =/=Int #TOKEN_CONTRACT
     andBool #PROXY_ID        =/=Int #ORIGIN_ID
     andBool #PROXY_ID        =/=Int #EXEC_ACCT_TO
     andBool #PROXY_ID        =/=Int #REFUND_RECEIVER
     andBool #PROXY_ID        =/=Int #TOKEN_CONTRACT
     andBool #ORIGIN_ID       =/=Int #EXEC_ACCT_TO
     andBool #ORIGIN_ID       =/=Int #REFUND_RECEIVER
     andBool #ORIGIN_ID       =/=Int #TOKEN_CONTRACT
     andBool #EXEC_ACCT_TO    =/=Int #REFUND_RECEIVER
     andBool #EXEC_ACCT_TO    =/=Int #TOKEN_CONTRACT
     andBool #REFUND_RECEIVER =/=Int #TOKEN_CONTRACT

     // Account address normality
     andBool #MASTER_COPY_ID  >Int 0 andBool (notBool #MASTER_COPY_ID  in #precompiledAccounts(BYZANTIUM))
     andBool #PROXY_ID        >Int 0 andBool (notBool #PROXY_ID        in #precompiledAccounts(BYZANTIUM))
     andBool #ORIGIN_ID       >Int 0 andBool (notBool #ORIGIN_ID       in #precompiledAccounts(BYZANTIUM))
     andBool #EXEC_ACCT_TO    >Int 0 andBool (notBool #EXEC_ACCT_TO    in #precompiledAccounts(BYZANTIUM))
     andBool #REFUND_RECEIVER >Int 0 andBool (notBool #REFUND_RECEIVER in #precompiledAccounts(BYZANTIUM))
     andBool #TOKEN_CONTRACT  >Int 0 andBool (notBool #TOKEN_CONTRACT  in #precompiledAccounts(BYZANTIUM))
{REQUIRES}
    ensures true
{ENSURES}
{ATTRIBUTE}
