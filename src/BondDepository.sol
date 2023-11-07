// SPDX-License-Identifier: MIT

pragma solidity =0.8.22;

/// @title Bond Depository
/// @author Izanagi Dev
/// @notice Hold Koto tokens to slowly drip them into circulation with bonds

import {ERC20} from "lib/solmate/src/tokens/ERC20.sol";

contract BondDepository {
    address public constant OWNER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Todo: Change this
    ERC20 public koto;
    bool public set;

    constructor() {}

    function deposit(uint256 amount) external {
        if (msg.sender != OWNER) revert OnlyOwner();
        koto.transfer(address(koto), amount);
        emit BondDeposit(msg.sender, amount);
    }

    function setKoto(address _koto) external {
        if (msg.sender != OWNER) revert OnlyOwner();
        if (set) revert KotoAlreadySet();
        koto = ERC20(_koto);
        set = true;
        emit KotoSet(msg.sender, _koto);
    }

    function redeemption(uint256 value) external {}

    function rescueEth(address to, uint256 value) external {}

    event BondDeposit(address indexed sender, uint256 depositedBonds);
    event KotoSet(address indexed sender, address _koto);

    error KotoAlreadySet();
    error OnlyOwner();

    receive() external payable {}
}
