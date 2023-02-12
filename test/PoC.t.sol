// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "lib/forge-std/src/Test.sol";
import "src/RolesAuthority.sol";
import "src/MockToken.sol";

contract PoC is Test {
    address admin = vm.addr(1);
    address minter = vm.addr(2);
    address alice = vm.addr(3);
    address attacker = vm.addr(4);

    RolesAuthority rolesAuth;
    MockToken token;
    function(bytes4,address) external view returns (bool) authenticator;

    function setUp() external {
        // set up roles authority
        vm.startPrank(admin);
        rolesAuth = new RolesAuthority();
        rolesAuth.setAccountRole(minter, Role.Minter);
        rolesAuth.setSelectorRole(MockToken.mint.selector, Role.Minter);
        token = new MockToken(address(rolesAuth));
        vm.stopPrank();

        // set authenticator
        authenticator = rolesAuth.authenticate;

        // mint tokens
        vm.prank(minter);
        token.mint(authenticator, alice, 1 ether);
    }

    function testSmokeCheck() external {
        assertEq(rolesAuth.admin(), admin);
        assertEq(token.balanceOf(alice), 1 ether);
        assertEq(token.balanceOf(attacker), 0);
        assertEq(rolesAuth.selectorRole(MockToken.mint.selector).toUint8(), Role.Minter.toUint8());
        assertEq(rolesAuth.accountRole(minter).toUint8(), Role.Minter.toUint8());
        assertEq(rolesAuth.accountRole(attacker).toUint8(), Role.None.toUint8());
        assertTrue(rolesAuth.authenticate(MockToken.mint.selector, minter));
        assertFalse(rolesAuth.authenticate(MockToken.mint.selector, attacker));
    }

    function testPoC() external {
        vm.startPrank(attacker);
        // -- poc start --

        // -- poc stop --
        __validate();
    }

    function __validate() internal {
        assertTrue(token.balanceOf(attacker) > 0);
    }
}