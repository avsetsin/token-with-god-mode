// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TokenSetupTest is Test {
    Token public token;

    address god = address(1);

    function setUp() public {
        token = new Token(god, "Godly Token", "TKN", 100_000);
    }

    function test_God() public {
        assertEq(token.god(), god);
    }

    function test_TokenName() public {
        assertEq(token.name(), "Godly Token");
    }

    function test_TokenSymbol() public {
        assertEq(token.symbol(), "TKN");
    }

    function test_InitialSupply() public {
        assertEq(token.totalSupply(), 100_000);
    }

    function test_GodBalance() public {
        assertEq(token.balanceOf(god), 100_000);
    }
}
