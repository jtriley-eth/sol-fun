// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {ERC20} from "lib/solmate/src/tokens/ERC20.sol";
import {Auth} from "src/Auth.sol";

error NotMinter();

contract MockToken is ERC20("Mock Token", "MT", 18), Auth {
    constructor(address authority) Auth(authority) {}

    function mint(
        function(bytes4,address) external view returns (bool) authenticator,
        address to,
        uint256 amount
    ) external {
        if (!this.canCall(authenticator, this.mint.selector, msg.sender))
            revert NotMinter();

        _mint(to, amount);
    }
}
