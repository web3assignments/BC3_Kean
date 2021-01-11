pragma solidity >= 0.6.12;
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    constructor() public ERC20("vryvrynaiss", "vvn") {
        _mint(msg.sender,10000*(10**0));
    }
}