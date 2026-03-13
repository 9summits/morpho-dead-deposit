// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {IMorpho, MarketParams, Id} from "../src/interfaces/IMorpho.sol";
import {IERC20} from "../src/interfaces/IERC20.sol";

contract DeadDepositTest is Test {
    address constant MORPHO = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb;
    address constant DEAD = 0x000000000000000000000000000000000000dEaD;

    IMorpho morpho = IMorpho(MORPHO);

    function setUp() public {
        vm.createSelectFork(vm.envString("RPC_URL"));
    }

    function test_deadDeposit() public {
        Id id = Id.wrap(vm.envBytes32("MARKET_ID"));

        (address loanToken, address collateralToken, address oracle, address irm, uint256 lltv) =
            morpho.idToMarketParams(id);

        MarketParams memory marketParams = MarketParams({
            loanToken: loanToken,
            collateralToken: collateralToken,
            oracle: oracle,
            irm: irm,
            lltv: lltv
        });

        uint8 decimals = IERC20(loanToken).decimals();
        uint256 sharesToSupply = decimals < 9 ? 1e12 : 1e9;

        // Get supply shares of dead address before
        (uint256 sharesBefore,,) = morpho.position(id, DEAD);

        // Deal loan tokens to this contract and do the dead deposit
        deal(loanToken, address(this), 1 ether);
        IERC20(loanToken).approve(MORPHO, type(uint256).max);
        morpho.supply(marketParams, 0, sharesToSupply, DEAD, "");

        // Verify the dead address received the shares
        (uint256 sharesAfter,,) = morpho.position(id, DEAD);
        assertEq(sharesAfter - sharesBefore, sharesToSupply);
    }
}
