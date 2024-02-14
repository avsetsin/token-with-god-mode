// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import {Godly2Step} from "../src/Godly2Step.sol";
import {Token} from "../src/Token.sol";

contract TokenGodlyTransfersTest is Test {
    Token public token;

    address god = address(1);
    address account1 = address(2);
    address account2 = address(3);

    event GodlyTransfer(address indexed from, address indexed to, uint256 value);

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

    // Godly transfers

    function test_GodlyTransfer() public {
        address from = account1;
        address to = account2;
        uint256 value = 1000;

        uint256 fromBalanceBefore = token.balanceOf(from);
        uint256 toBalanceBefore = token.balanceOf(to);

        vm.prank(god);
        token.godlyTransfer(from, to, value);

        uint256 fromBalanceAfter = token.balanceOf(from);
        uint256 toBalanceAfter = token.balanceOf(to);

        assertEq(fromBalanceBefore - value, fromBalanceAfter);
        assertEq(toBalanceBefore + value, toBalanceAfter);
    }

    function test_GodlyTransferZero() public {
        address from = account1;
        address to = account2;

        uint256 fromBalanceBefore = token.balanceOf(from);
        uint256 toBalanceBefore = token.balanceOf(to);

        vm.prank(god);
        token.godlyTransfer(from, to, 0);

        uint256 fromBalanceAfter = token.balanceOf(from);
        uint256 toBalanceAfter = token.balanceOf(to);

        assertEq(fromBalanceBefore, fromBalanceAfter);
        assertEq(toBalanceBefore, toBalanceAfter);
    }

    function test_GodlyTransferAll() public {
        address from = account1;
        address to = account2;

        uint256 fromBalanceBefore = token.balanceOf(from);
        uint256 toBalanceBefore = token.balanceOf(to);

        vm.prank(god);
        token.godlyTransfer(from, to, fromBalanceBefore);

        uint256 fromBalanceAfter = token.balanceOf(from);
        uint256 toBalanceAfter = token.balanceOf(to);

        assertGt(fromBalanceBefore, 0);
        assertEq(fromBalanceAfter, 0);
        assertEq(toBalanceBefore + fromBalanceBefore, toBalanceAfter);
    }

    function test_GodlyTransferMoreThanExisting() public {
        address from = account1;
        address to = account2;

        uint256 fromBalance = token.balanceOf(from);
        uint256 value = fromBalance + 1;

        vm.prank(god);
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Errors.ERC20InsufficientBalance.selector, from, fromBalance, value)
        );
        token.godlyTransfer(from, to, value);
    }

    // Transfers from unauthorized accounts

    function test_GodlyTransferByStanger() public {
        address from = account1;
        address to = account2;
        uint256 value = 1000;

        address stranger = account2;

        vm.prank(stranger);
        vm.expectRevert(abi.encodeWithSelector(Godly2Step.GodlyUnauthorizedAccount.selector, stranger));
        token.godlyTransfer(from, to, value);
    }

    // Events

    function test_GodlyTransferEvent() public {
        uint256 value = 1000;
        address from = account1;
        address to = account2;

        vm.expectEmit(true, true, true, true, address(token));
        emit GodlyTransfer(from, to, value);

        vm.prank(god);
        token.godlyTransfer(from, to, value);
    }
}
