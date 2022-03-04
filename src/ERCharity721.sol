// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.11;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IERCharity721 is IERC721{

	//function changeRecipient (address _newRecipient) public;

	//function setTimeout(uint256 newTimeout) public;

}

contract ERCharity721 is IERCharity721, ERC721, Ownable {

	address payable public recipient;
	uint256 public timeout = 7 days;

	constructor(string memory name_, string memory symbol_, address payable recipient_) ERC721(name_, symbol_) {
		recipient = recipient_;
	}





}
