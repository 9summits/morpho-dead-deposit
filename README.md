# Morpho Dead Deposit

Perform a dead deposit on a Morpho market to prevent share inflation attacks.

## Usage

```shell
./dead-deposit.sh <MARKET_ID> <RPC_URL> <PRIVATE_KEY>
```

### Parameters

- `MARKET_ID` — The `bytes32` identifier of the Morpho market.
- `RPC_URL` — The RPC endpoint URL.
- `PRIVATE_KEY` — The private key used to sign the transaction.

### Example

```shell
./dead-deposit.sh 0xabc...def https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY 0xYOUR_PRIVATE_KEY
```
