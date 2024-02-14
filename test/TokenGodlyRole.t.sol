// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Godly2Step} from "../src/Godly2Step.sol";
import {Token} from "../src/Token.sol";

contract TokenGodlyRoleTest is Test {
    Token public token;

    address god = address(1);

    event GodRoleTransferStarted(address indexed previousGod, address indexed newGod);
    event GodRoleTransferred(address indexed previousGod, address indexed newGod);

    function setUp() public {
        token = new Token(god, "Godly Token", "TKN", 100_000);
    }

    // Initial state

    function test_God() public {
        assertEq(token.god(), god);
    }

    function test_PendingGod() public {
        assertEq(token.pendingGod(), address(0));
    }

    // Role transfers

    function test_TransferGodRole() public {
        address from = god;
        address to = address(2);

        assertEq(token.god(), from);
        assertEq(token.pendingGod(), address(0));

        vm.prank(from);
        token.transferGodRole(to);

        assertEq(token.god(), from);
        assertEq(token.pendingGod(), to);
    }

    function test_AcceptGodRole() public {
        address from = god;
        address to = address(2);

        vm.prank(from);
        token.transferGodRole(to);

        vm.prank(to);
        token.acceptGodRole();

        assertEq(token.god(), to);
        assertEq(token.pendingGod(), address(0));
    }

    // Role transfers from unauthorized accounts

    function test_TransferGodRoleByStranger() public {
        address from = address(2);
        address to = address(3);

        assertNotEq(token.god(), from);

        vm.prank(from);
        vm.expectRevert(abi.encodeWithSelector(Godly2Step.GodlyUnauthorizedAccount.selector, from));
        token.transferGodRole(to);
    }

    function test_AcceptGodRoleByStranger() public {
        address from = god;
        address to = address(2);
        address stranger = address(3);

        vm.prank(from);
        token.transferGodRole(to);

        vm.prank(stranger);
        vm.expectRevert(abi.encodeWithSelector(Godly2Step.GodlyUnauthorizedAccount.selector, stranger));
        token.acceptGodRole();
    }

    // Events

    function test_TransferGodRoleEmitEvent() public {
        address from = god;
        address to = address(2);

        vm.expectEmit(true, true, false, false, address(token));
        emit GodRoleTransferStarted(from, to);

        vm.prank(from);
        token.transferGodRole(to);
    }

    function test_AcceptGodRoleEmitEvent() public {
        address from = god;
        address to = address(2);

        vm.prank(from);
        token.transferGodRole(to);

        vm.expectEmit(true, true, false, false, address(token));
        emit GodRoleTransferred(from, to);

        vm.prank(to);
        token.acceptGodRole();
    }
}
