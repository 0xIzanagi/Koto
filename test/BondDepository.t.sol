// SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.22;

import {ERC20} from "../lib/solmate/src/tokens/ERC20.sol";
import {BondDepository} from "../src/BondDepository.sol";
import "lib/forge-std/src/Test.sol";

contract MockToken is ERC20 {
    constructor(string memory name, string memory symbol, uint8 decimals) ERC20(name, symbol, decimals) {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract BondDepositoryTest is Test {
    BondDepository public depository;
    MockToken public mock;

    function setUp() public {
        depository = new BondDepository();
        mock = new MockToken("Mock", "MOCK", 18);
    }

    function testKotoSetting(address testor) public {
        vm.prank(testor);
        vm.expectRevert();
        depository.setKoto(address(mock));

        vm.prank(depository.OWNER());
        depository.setKoto(address(mock));

        assertEq(address(depository.koto()), address(mock));

        vm.prank(depository.OWNER());
        vm.expectRevert();
        depository.setKoto(address(mock));
    }

    function testDeposit(address testor) public {
        mock.mint(address(depository), 1_000_000e18);
        vm.prank(depository.OWNER());
        depository.setKoto(address(mock));
        vm.prank(testor);
        vm.expectRevert();
        depository.deposit(100e18);

        vm.prank(depository.OWNER());
        depository.deposit(1000e18);

        assertEq(mock.balanceOf(address(mock)), 1000e18);
    }
}
