// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

enum Role {
    None,
    Minter,
    Burner,
    Admin
}

function toUint8(Role role) pure returns (uint8) { return uint8(role); }

using { toUint8 } for Role global;

error Unauthorized(Role requriedRole);

contract RolesAuthority {
    event AdminChange(address indexed previous, address indexed current);
    event SelectorRoleSet(bytes4 indexed selector, Role indexed role);
    event AccountRoleSet(address indexed account, Role indexed role);

    address public admin;
    mapping(bytes4 selector => Role role) public selectorRole;
    mapping(address account => Role role) public accountRole;

    constructor() { admin = msg.sender; }

    function authenticate(bytes4 selector, address caller) external view returns (bool) {
        Role role = accountRole[caller];
        return role == Role.Admin || role == selectorRole[selector];
    }

    function setAdmin(address newAdmin) external {
        if (msg.sender != admin) revert Unauthorized(Role.Admin);
        admin = newAdmin;
        emit AdminChange(msg.sender, newAdmin);
    }

    function setSelectorRole(bytes4 selector, Role role) external {
        if (msg.sender != admin) revert Unauthorized(Role.Admin);
        selectorRole[selector] = role;
        emit SelectorRoleSet(selector, role);
    }

    function setAccountRole(address account, Role role) external {
        if (msg.sender != admin) revert Unauthorized(Role.Admin);
        accountRole[account] = role;
        emit AccountRoleSet(account, role);
    }
}
