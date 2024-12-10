// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import {ERC20Burnable, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

abstract contract StableUSDCoin is ERC20Burnable, Ownable {
    error StableUSDCoin__AmountShouldBeMoreThanZero();
    error StableUSDCoin__UserBalanceIsZero();
    error StableUSDCoin__NotZeroAddress();

    constructor() ERC20("StableUSDCoin", "SUSDC") Ownable(msg.sender) {}

    function burn(uint256 _amount) public override {
        if (_amount <= 0) {
            revert StableUSDCoin__AmountShouldBeMoreThanZero();
        }
        if (balanceOf(msg.sender) <= 0) {
            revert StableUSDCoin__UserBalanceIsZero();
        }
        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external {
        if (_amount <= 0) {
            revert StableUSDCoin__AmountShouldBeMoreThanZero();
        }
        if (_to == address(0)) {
            revert StableUSDCoin__NotZeroAddress();
        }
        _mint(_to, _amount);
    }
}
