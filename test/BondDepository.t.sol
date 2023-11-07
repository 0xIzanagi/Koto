// SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.22;

import {Koto} from "../src/Koto.sol";
import {BondDepository} from "../src/BondDepository.sol";
import "lib/forge-std/src/Test.sol";

contract BondDepositoryTest is Test {
    BondDepository public depository;
    Koto public koto;

    function setUp() public {
        depository = new BondDepository();
        koto = new Koto();

        vm.deal(address(koto), 10 ether);

        vm.startPrank(koto.ownership());
        koto.removeLimits();
        koto.launch();
        vm.stopPrank();
        vm.deal(address(koto), 1000 ether);
    }

    function testKotoSetting(address testor) public {
        vm.prank(testor);
        vm.expectRevert();
        depository.setKoto(address(koto));

        vm.prank(depository.OWNER());
        depository.setKoto(address(koto));

        assertEq(address(depository.koto()), address(koto));
        assertEq(koto.allowance(address(depository), 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), type(uint256).max);

        vm.prank(depository.OWNER());
        vm.expectRevert();
        depository.setKoto(address(koto));
    }

    function testDeposit(address testor) public {
        vm.prank(koto.ownership());
        koto.transfer(address(depository), 50_000e18);
        vm.prank(depository.OWNER());
        depository.setKoto(address(koto));
        vm.prank(testor);
        vm.expectRevert();
        depository.deposit(100e18);

        vm.prank(depository.OWNER());
        depository.deposit(1000e18);

        assertEq(koto.balanceOf(address(koto)), 1000e18);
    }

    function testRedemption(uint256 x, address y) public {
        vm.prank(koto.ownership());
        koto.transfer(address(depository), 50_000 ether);
        uint256 pre = address(depository).balance;
        vm.assume(x > 1 ether && x < 100 ether);
        vm.deal(address(depository), 100 ether);
        vm.prank(y);
        vm.expectRevert();
        depository.redemption(x);

        vm.startPrank(depository.OWNER());
        depository.setKoto(address(koto));
        depository.redemption(x);
        vm.stopPrank();

        assertGt(address(depository).balance, pre);
    }

    function testSwapKoto() public {
        vm.prank(koto.ownership());
        koto.transfer(address(depository), 50_000 ether);

        uint256 pre = address(depository).balance;

        vm.expectRevert();
        vm.prank(address(0x01));
        depository.swap(100 ether, true);

        vm.startPrank(depository.OWNER());
        depository.setKoto(address(koto));
        depository.swap(100 ether, true);

        assertGt(address(depository).balance, pre);
    }

    function testSwapEth(uint256 x) public {
         vm.assume(x > 1 ether && x < 1000 ether);
        vm.deal(address(depository), 1000 ether);

         uint256 pre = koto.balanceOf(address(depository));

        vm.expectRevert();
       
        vm.prank(address(0x01));
        depository.swap(x, false);

        vm.startPrank(depository.OWNER());
        depository.setKoto(address(koto));
        depository.swap(x, false);

        assertGt(koto.balanceOf(address(depository)), pre);

    }

    function testBond(uint256 x, address y) public {
        uint256 pre = koto.balanceOf(address(depository));
        vm.assume(x > 1 ether && x < 100 ether);
        vm.deal(address(depository), 100 ether);
        vm.prank(y);
        vm.expectRevert();
        depository.bond(x);

        vm.prank(koto.ownership());
        koto.transfer(address(depository), 50_000 ether);

        vm.startPrank(depository.OWNER());
        depository.setKoto(address(koto));
        depository.deposit(10000 ether);
        vm.stopPrank();

        vm.prank(koto.ownership());
        koto.open();

        vm.prank(depository.OWNER());
        depository.bond(x);

        assertGt(koto.balanceOf(address(depository)), pre);
    }
}
