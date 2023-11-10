// SPDX-License-Identifier: MIT

pragma solidity =0.8.22;

/// @title Bond Depository
/// @author Izanagi Dev
/// @notice Hold Koto tokens to slowly drip them into circulation with bonds
/// @dev there is no functions in order to save users from accidently sending tokens or eth to this contract.
/// this is done to remove necessary trust assumptions (ie "dev can take underlying eth / tokens") and this
/// contract should never really be made easily usable by unknowledgable participants.

import {IKoto} from "./interfaces/IKoto.sol";

interface IUniswapV2Router02 {
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract BondDepository {
    // ========================== STORAGE ========================== \\

    IKoto public koto;
    bool public set;

    // =================== CONSTANTS / IMMUTABLES =================== \\

    address public constant OWNER = 0x0688578EC7273458785591d3AfFD120E664900C2;
    IUniswapV2Router02 private constant UNISWAP_V2_ROUTER =
        IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    // ========================= CONTRUCTOR ========================= \\

    constructor() {}

    // ========================= ADMIN FUNCTIONS ========================= \\

    ///@notice deposit Koto tokens into the Koto contract to be sold as bonds
    ///@param amount the amount of koto tokens to send.
    function deposit(uint256 amount) external {
        if (msg.sender != OWNER) revert OnlyOwner();
        if (address(koto) == address(0)) revert KotoNotSet();
        koto.transfer(address(koto), amount);
        emit BondDeposit(msg.sender, amount);
    }

    ///@notice set the koto contract address
    ///@param _koto the address to set koto too
    function setKoto(address _koto) external {
        if (msg.sender != OWNER) revert OnlyOwner();
        if (set) revert KotoAlreadySet();
        koto = IKoto(payable(_koto));
        koto.approve(address(UNISWAP_V2_ROUTER), type(uint256).max);
        set = true;
        emit KotoSet(msg.sender, _koto);
    }

    ///@notice redeem koto tokens held within the contract for their underlying eth reserves
    ///@param value the amount of koto tokens to redeem
    function redemption(uint256 value) external {
        if (msg.sender != OWNER) revert OnlyOwner();
        uint256 payout = koto.redeem(value);
        emit DepositoryRedemption(value, payout);
    }

    ///@notice swap koto tokens for eth or vis versa
    ///@param amount the amount of eth or koto to swap for the other
    ///@param zeroForOne if you are swapping koto for eth or vis versa
    ///@dev true for zeroForOne means swapping for eth, it does not matter which token is
    /// actually token zero and which one is token one. The tokens / eth must already be in the contract
    function swap(uint256 amount, bool zeroForOne) external {
        if (msg.sender != OWNER) revert OnlyOwner();
        uint256 preKotoBalance = koto.balanceOf(address(this));
        uint256 preEthBalance = address(this).balance;
        if (zeroForOne) {
            address[] memory path = new address[](2);
            path[0] = address(koto);
            path[1] = WETH;
            UNISWAP_V2_ROUTER.swapExactTokensForETHSupportingFeeOnTransferTokens(
                amount, 0, path, address(this), block.timestamp
            );
        } else {
            address[] memory path = new address[](2);
            path[0] = WETH;
            path[1] = address(koto);
            UNISWAP_V2_ROUTER.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
                0, path, address(this), block.timestamp
            );
        }
        emit DepositorySwap(preKotoBalance, koto.balanceOf(address(this)), preEthBalance, address(this).balance);
    }

    function bond(uint256 value) external {
        if (msg.sender != OWNER) revert OnlyOwner();
        uint256 payout = koto.bond{value: value}();
        emit DepositoryBond(value, payout);
    }

    // ========================= EVENTS ========================= \\

    event BondDeposit(address indexed sender, uint256 depositedBonds);
    event DepositoryBond(uint256 ethAmount, uint256 payout);
    event DepositoryRedemption(uint256 kotoOut, uint256 ethIn);
    event DepositorySwap(
        uint256 kotoBalanceBefore, uint256 kotoBalanceAfter, uint256 ethBalanceBefore, uint256 ethBalanceAfter
    );
    event EthRescued(address indexed sender, address indexed user, uint256 amount);
    event KotoSet(address indexed sender, address _koto);

    // ========================= ERRORS ========================= \\

    error KotoAlreadySet();
    error KotoNotSet();
    error OnlyOwner();

    receive() external payable {}
}
