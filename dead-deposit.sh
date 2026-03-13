#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <MARKET_ID> <RPC_URL> <PRIVATE_KEY>"
    exit 1
fi

MARKET_ID="$1"
RPC_URL="$2"
PRIVATE_KEY="$3"

forge script script/DeadDeposit.s.sol --sig "run(bytes32)" "$MARKET_ID" \
    --rpc-url "$RPC_URL" --private-key "$PRIVATE_KEY" --broadcast
