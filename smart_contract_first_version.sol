pragma solidity ^0.8.24;
// SPDX-License-Identifier: MIT

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TradeChain is ERC20 {
    IERC20 public immutable token;

    constructor(IERC20 token_) ERC20("TradeChain-Stable-coin", "TCC") {
        token = token_;
    }

    function invest(uint256 amount) external {
        require(amount > 0);

        uint256 amountInvested = amount;
        uint256 supplyStableCoins = this.totalSupply();
        uint256 balanceToken = token.balanceOf(address(this));

        uint256 amountStable;
        if (supplyStableCoins == 0) {
            amountStable = amountInvested;
        } else {
            amountStable = (amountInvested * supplyStableCoins) / balanceToken;
        }

        _mint(msg.sender, amountStable);
        token.transferFrom(msg.sender, address(this), amountInvested);
    }

    function divest(uint256 amount) external {
        require(amount > 0);

        uint256 amountStable = amount;
        uint256 supplyStableCoins = this.totalSupply();
        uint256 balanceToken = token.balanceOf(address(this));

        uint256 amountDivested = (amountStable * balanceToken) / supplyStableCoins;

        _burn(msg.sender, amountStable);
        token.transfer(msg.sender, amountDivested);
    }

}
