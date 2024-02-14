// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

/**
 * @title Godly2Step
 * @dev Contract module which provides a God role that will be transferred in two steps
 */
abstract contract Godly2Step {
    address public god;
    address public pendingGod;

    event GodRoleTransferStarted(address indexed previousGod, address indexed newGod);
    event GodRoleTransferred(address indexed previousGod, address indexed newGod);

    error GodlyUnauthorizedAccount(address account);
    error GodlyInvalidGod(address god);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial god
     * @param initialGod The initial god of the contract
     */
    constructor(address initialGod) {
        if (initialGod == address(0)) {
            revert GodlyInvalidGod(address(0));
        }
        _transferGodRole(initialGod);
    }

    /**
     * @dev Throws if called by any account other than the god
     */
    modifier onlyGod() {
        if (god != msg.sender) {
            revert GodlyUnauthorizedAccount(msg.sender);
        }
        _;
    }

    /**
     * @dev Starts the god role transfer of the contract to a new account. Replaces the pending transfer if there is one
     * Can only be called by the current god
     * @param newGod The address to transfer the god role to
     */
    function transferGodRole(address newGod) public onlyGod {
        pendingGod = newGod;
        emit GodRoleTransferStarted(god, newGod);
    }

    /**
     * @dev The new god accepts the god role transfer
     */
    function acceptGodRole() public {
        address sender = msg.sender;
        if (pendingGod != sender) {
            revert GodlyUnauthorizedAccount(sender);
        }
        _transferGodRole(sender);
    }

    /**
     * @dev Transfers god role of the contract to a new account (`newGod`) and deletes any pending god
     * @param newGod The address to transfer the god role to
     */
    function _transferGodRole(address newGod) internal {
        delete pendingGod;
        address oldGod = god;
        god = newGod;
        emit GodRoleTransferred(oldGod, newGod);
    }
}
