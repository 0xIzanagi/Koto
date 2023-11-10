// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

import "lib/forge-std/src/Test.sol";
import {Koto} from "../src/Koto.sol";
import {PricingLibrary} from "../src/PricingLibrary.sol";

interface IUniswapV2Pair {
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112, uint112, uint32);
}

interface IUniswapRouter02 {
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

contract KotoTest is Test {
    Koto public koto;
    IUniswapV2Pair public pool;
    IUniswapRouter02 public router = IUniswapRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address alice = address(0x01);
    address bob = address(0x02);

    function setUp() public {
        koto = new Koto();
        pool = IUniswapV2Pair(koto.pool());
    }

    // function testLaunch() public {
    //     assertNotEq(koto.pool(), address(0));
    //     assertEq(pool.token0(), address(koto));
    //     assertEq(pool.token1(), address(WETH));
    //     assertEq(koto.allowance(address(koto), address(router)), type(uint256).max);
    //     assertEq(koto.totalSupply(), 10_000_000e18);
    //     assertEq(koto.name(), "Koto");
    //     assertEq(koto.symbol(), "KOTO");
    //     assertEq(koto.decimals(), 18);
    // }

    // function testTransfer(uint256 x) public {
    //     vm.assume(x > 1e18 && x < 2_000_000e18);
    //     vm.startPrank(koto.ownership());
    //     koto.removeLimits();
    //     koto.transfer(alice, x);
    //     vm.stopPrank();

    //     vm.prank(alice);
    //     koto.transfer(bob, 1e18);

    //     // No fees on transfer
    //     assertEq(koto.balanceOf(bob), 1 ether);
    // }

    // function testSwap() public {
    //     vm.deal(koto.ownership(), 1000 ether);
    //     address[] memory path = new address[](2);
    //     path[0] = address(WETH);
    //     path[1] = address(koto);
    //     vm.startPrank(koto.ownership());
    //     koto.removeLimits();
    //     (bool success,) = address(koto).call{value: 10 ether}("");
    //     require(success, "error");
    //     koto.increaseLiquidity(koto.balanceOf(address(koto)), 10 ether);
    //     uint256 post = koto.balanceOf(address(0x0420420420420420420420420420420420420069));
    //     router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: 1 ether}(0, path, alice, block.timestamp + 10);
    //     assertGt(koto.balanceOf(0x0420420420420420420420420420420420420069), post);
    //     vm.stopPrank();
    // }

    // function testAdminReverts(address x) public {
    //     vm.assume(x != address(0) && x != koto.ownership());
    //     vm.startPrank(x);
    //     vm.expectRevert();
    //     koto.removeLimits();
    //     vm.expectRevert();
    //     koto.exclude(address(0x03));
    //     vm.expectRevert();
    //     koto.increaseLiquidity(100, 100);
    //     vm.expectRevert();
    //     koto.addAmm(address(0x124321));
    //     vm.expectRevert();
    //     koto.launch();
    //     vm.expectRevert();
    //     koto.open();
    //     vm.stopPrank();
    // }

    // function testAdminSuccess() public {
    //     vm.deal(address(koto), 1000e18);
    //     vm.startPrank(koto.ownership());
    //     koto.removeLimits();
    //     koto.exclude(alice);
    //     koto.launch();
    //     koto.transfer(bob, 2_000_000e18);
    //     koto.addAmm(address(0x069));
    //     vm.stopPrank();

    //     uint256 pre = koto.balanceOf(address(koto));

    //     vm.prank(bob);
    //     koto.transfer(address(0x04), 2_000_000e18);

    //     vm.prank(address(0x04));
    //     koto.transfer(alice, 100e18);

    //     address[] memory path = new address[](2);
    //     path[0] = address(koto);
    //     path[1] = WETH;

    //     vm.startPrank(alice);
    //     koto.approve(address(router), type(uint256).max);
    //     router.swapExactTokensForETHSupportingFeeOnTransferTokens(100e18, 0, path, alice, block.timestamp);
    //     vm.stopPrank();

    //     //Alice has been excluded so there should not be any additional tokens in the process, and no taxes on transfers
    //     assertEq(koto.balanceOf(address(koto)), pre);
    // }

    // function testApprove(uint256 x) public {
    //     koto.approve(alice, x);
    //     assertEq(koto.allowance(address(this), alice), x);
    // }

    // function testBond() public {
    //     vm.deal(address(koto), 1000e18);
    //     vm.startPrank(koto.ownership());
    //     koto.removeLimits();
    //     koto.launch();
    //     (bool success,) = address(this).call{value: address(koto.ownership()).balance}("");
    //     require(success, "lint");
    //     koto.transfer(address(koto), 1_000_000e18);
    //     koto.open();
    //     (PricingLibrary.Market memory market, PricingLibrary.Term memory terms,) = koto.marketInfo();
    //     vm.stopPrank();

    //     assertEq(koto.bondPrice(), koto._getPrice());
    //     assertEq(terms.conclusion, (block.timestamp + 86400));
    //     assertEq(market.maxPayout, market.capacity / 6);

    //     vm.deal(alice, 100 ether);
    //     vm.startPrank(alice);
    //     koto.bond{value: 1 ether}();
    //     assertGt(koto.balanceOf(alice), 0);
    //     vm.expectRevert();
    //     koto.bond{value: 99 ether}();
    //     vm.stopPrank();
    // }

    // function testBondReceive() public {
    //     vm.deal(alice, 100 ether);
    //     vm.deal(address(koto), 1000e18);
    //     vm.startPrank(koto.ownership());
    //     koto.removeLimits();
    //     koto.launch();
    //     (bool success,) = address(this).call{value: address(koto.ownership()).balance}("");
    //     require(success, "lint");
    //     koto.transfer(address(koto), 1_000_000e18);
    //     koto.open();
    //     (PricingLibrary.Market memory market1,,) = koto.marketInfo();
    //     vm.stopPrank();

    //     vm.prank(alice);
    //     (bool successful,) = address(koto).call{value: 1 ether}("");
    //     require(successful, "lint");
    //     assertGt(koto.balanceOf(alice), 0);
    //     (PricingLibrary.Market memory market,,) = koto.marketInfo();
    //     assertGt(market.totalDebt, market1.totalDebt);
    //     assertGt(market1.capacity, market.capacity);
    //     assertGt(market.sold, 0);
    //     assertGt(market.purchased, 0);
    // }

    // function testRedeem() public {
    //     vm.deal(address(koto), 10_000_000 ether);
    //     uint256 pre = address(this).balance;
    //     vm.startPrank(koto.ownership());
    //     koto.removeLimits();
    //     koto.transfer(address(this), 2_000_000e18);
    //     vm.stopPrank();
    //     koto.redeem(2_000_000e18);
    //     assertEq(address(this).balance, pre + 2_000_000e18);
    //     assertEq(koto.totalSupply(), 8_000_000e18);
    //     assertEq(koto.balanceOf(address(this)), 0);
    // }

    // function testTransferFrom(uint256 x) public {
    //     uint256 startingBalance = koto.balanceOf(koto.ownership());
    //     vm.assume(x > 0 && x < koto.balanceOf(koto.ownership()));
    //     address owner = koto.ownership();
    //     vm.startPrank(alice);
    //     vm.expectRevert();
    //     koto.transferFrom(owner, alice, x);
    //     vm.stopPrank();

    //     vm.startPrank(owner);
    //     koto.removeLimits();
    //     koto.approve(alice, x);
    //     vm.stopPrank();

    //     vm.startPrank(alice);
    //     koto.transferFrom(owner, alice, x);
    //     vm.stopPrank();

    //     assertEq(koto.allowance(owner, alice), 0);
    //     assertEq(koto.balanceOf(alice), x);
    //     assertEq(koto.balanceOf(owner), startingBalance - x);
    // }

    // function testLimits() public {
    //     vm.prank(koto.ownership());
    //     koto.transfer(alice, 2_000_000e18);

    //     vm.prank(alice);
    //     vm.expectRevert();
    //     koto.transfer(bob, 2_000_000e18);
    // }

    // function testBondRefund() public {
    //     vm.deal(alice, 100 ether);
    //     vm.prank(alice);
    //     koto.bond{value: 1 ether}();
    //     assertEq(address(alice).balance, 100 ether);

    //     // Test refund on receive
    //     (bool success,) = address(koto).call{value: 1 ether}("");
    //     require(success, "lint");
    //     assertEq(address(alice).balance, 100 ether);
    // }

    // function testTransferReverts(uint256 x, address y) public {
    //     vm.assume(x > 0 && x < koto.balanceOf(koto.ownership()));
    //     vm.assume(y != address(0) && y != koto.ownership());
    //     vm.startPrank(koto.ownership());
    //     vm.expectRevert();
    //     koto.transfer(address(0), x);
    //     vm.expectRevert();
    //     koto.transfer(y, 0);
    // }

    // function testGetPrice() public {
    //     vm.deal(koto.ownership(), 1000 ether);

    //     vm.startPrank(koto.ownership());
    //     (bool success,) = address(koto).call{value: 100 ether}("");
    //     require(success, "lint is annoying");
    //     koto.removeLimits();
    //     koto.increaseLiquidity(koto.balanceOf(address(koto)), 100 ether);
    //     vm.stopPrank();

    //     address token0 = pool.token0();
    //     (uint112 reserve0, uint112 reserve1,) = pool.getReserves();
    //     uint256 price;
    //     if (token0 == address(koto)) {
    //         price = uint256(reserve1) * 1e18 / uint256(reserve0);
    //     } else {
    //         price = uint256(reserve0) * 1e18 / uint256(reserve1);
    //     }

    //     assertEq(price, koto._getPrice());
    // }

    // function testGetTokens() public {
    //     address token0 = pool.token0();
    //     address token1 = pool.token1();
    //     (address koto0, address koto1) = koto._getTokens(address(pool));
    //     assertEq(token0, koto0);
    //     assertEq(token1, koto1);
    // }

    // function testBurn(uint256 x) public {
    //     vm.assume(x > 0 && x < koto.balanceOf(koto.ownership()));
    //     vm.startPrank(koto.ownership());
    //     koto.burn(x);
    //     vm.expectRevert();
    //     koto.burn(2_000_000e18);
    //     vm.stopPrank();

    //     assertEq(koto.totalSupply(), 10_000_000e18 - x);
    //     assertEq(koto.balanceOf(koto.ownership()), 2_000_000e18 - x);
    // }

    function testInitialLp() public {
        vm.deal(address(koto), 10 ether);
        vm.startPrank(koto.ownership());
        koto.launch();
        koto.transfer(alice, 150_000 ether);
        vm.stopPrank();

        vm.startPrank(alice);
        vm.expectRevert();
        koto.transfer(bob, 150_000 ether);
    }

    // function testBondPrice() public {}

    // function testRedeemPrice() public {}

    // function testBondsPreOpen() public {}

    receive() external payable {}
}
