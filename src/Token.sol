// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Godly2Step} from "./Godly2Step.sol";

/**
 * @title Token Contract
 * @dev The contract represents a ERC20 token with god mode functionality
 */
contract Token is ERC20, Godly2Step {
    event GodlyTransfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Initializes the Token contract
     * @param god The address of the god account
     * @param name The name of the token
     * @param symbol The symbol of the token
     * @param initialSupply The initial supply of the token
     */
    constructor(address god, string memory name, string memory symbol, uint256 initialSupply)
        ERC20(name, symbol)
        Godly2Step(god)
    {
        _mint(god, initialSupply);
    }

    /**
     * @dev Performs a godly transfer of tokens from one address to another
     * @param from The address to transfer tokens from
     * @param to The address to transfer tokens to
     * @param value The amount of tokens to transfer
     */
    function godlyTransfer(address from, address to, uint256 value) public onlyGod {
        _transfer(from, to, value);
        emit GodlyTransfer(from, to, value);
    }
}
