// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

error InvalidAuthority();

contract Auth {
    address immutable authority;

    constructor(address _authority) {
        authority = _authority;
    }

    modifier validAuthority(function(bytes4,address) external view returns (bool) authFunc) {
        if (authFunc.address != authority) revert InvalidAuthority();
        _;
    }

    function canCall(
        function(bytes4,address) external view returns (bool) authenticate,
        bytes4 selector,
        address caller
    )
        external
        view
        validAuthority(authenticate)
        returns (bool)
    {
        return authenticate(selector, caller);
    }
}
