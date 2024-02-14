// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TokenTransfersTest is Test {
    Token public token;

    address god = address(1);
    address account1 = address(2);
    address account2 = address(3);

    function setUp() public {
        token = new Token(god, "Godly Token", "TKN", 100_000);
        setUpAccounts();
    }

    function setUpAccounts() internal {
        vm.startPrank(god);
        token.transfer(account1, 10_000);
        token.transfer(account2, 10_000);
        vm.stopPrank();
    }

    // Base ERC20 transfers

    function test_Transfer() public {
        uint256 value = 1000;

        address from = account1;
        address to = account2;

        uint256 fromBalanceBefore = token.balanceOf(from);
        uint256 toBalanceBefore = token.balanceOf(to);

        vm.prank(from);
        token.transfer(to, value);

        uint256 fromBalanceAfter = token.balanceOf(from);
        uint256 toBalanceAfter = token.balanceOf(to);

        assertEq(fromBalanceBefore - value, fromBalanceAfter);
        assertEq(toBalanceBefore + value, toBalanceAfter);
    }
}
