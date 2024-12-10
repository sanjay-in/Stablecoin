// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {StableUSDCoin} from "./StableUSDCoin.sol";

contract SUSDC_Engine is ReentrancyGuard {
    // Errors
    error SUSDC_Engine__AmountCantBeZero();
    error SUSDC_Engine__TransferFailed();

    // Events
    event Deposited(
        address indexed sender,
        address indexed collateralAddress,
        uint256 amount
    );

    // State Variables
    StableUSDCoin private immutable i_SUSDC;

    mapping(address user => mapping(address collateral => uint amount))
        private s_userCollateral;

    // Modifiers
    modifier moreThanZero(uint256 value) {
        if (value <= 0) {
            revert SUSDC_Engine__AmountCantBeZero();
        }
        _;
    }

    constructor(address SUSDC) {
        i_SUSDC = StableUSDCoin(SUSDC);
    }

    /**
     * @notice depositCollateral updates the collateral for the user and transfers the collateral to SUSDC_Engine contract
     * @param _amount no of collateral tokens to transfer
     * @param _collateralAddress address of the collateral
     */
    function depositCollateral(
        uint256 _amount,
        address _collateralAddress
    ) internal moreThanZero(_amount) nonReentrant {
        s_userCollateral[msg.sender][_collateralAddress] += _amount;
        emit Deposited(msg.sender, _collateralAddress, _amount);
        bool success = IERC20(_collateralAddress).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        if (!success) {
            revert SUSDC_Engine__TransferFailed();
        }
    }
}
