// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {IMorpho, MarketParams, Id} from "../src/interfaces/IMorpho.sol";
import {IERC20} from "../src/interfaces/IERC20.sol";

contract DeadDeposit is Script {
    address constant DEAD = 0x000000000000000000000000000000000000dEaD;

    // Morpho Blue is deployed at the same address on all supported chains.
    address constant MORPHO = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;

    function run(bytes32 marketId) external {
        IMorpho morpho = IMorpho(MORPHO);

        // Fetch on-chain market params from the market id.
        (address loanToken, address collateralToken, address oracle, address irm, uint256 lltv) =
            morpho.idToMarketParams(Id.wrap(marketId));

        require(loanToken != address(0), "Market does not exist");

        MarketParams memory marketParams = MarketParams({
            loanToken: loanToken,
            collateralToken: collateralToken,
            oracle: oracle,
            irm: irm,
            lltv: lltv
        });

        // Determine the number of shares to supply based on loan token decimals.
        // 1e9 shares for tokens with >= 9 decimals, 1e12 shares for tokens with < 9 decimals.
        uint8 decimals = IERC20(loanToken).decimals();
        uint256 shares = decimals < 9 ? 1e12 : 1e9;

        console.log("Loan token:", loanToken);
        console.log("Loan token decimals:", decimals);
        console.log("Shares to supply:", shares);

        vm.startBroadcast();

        IERC20(loanToken).approve(MORPHO, type(uint256).max);
        morpho.supply(marketParams, 0, shares, DEAD, "");

        vm.stopBroadcast();

        console.log("Dead deposit completed successfully");
    }
}
