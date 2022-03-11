// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.11;

import "@solmate/tokens/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// interface IERCharity721 is IERC721{

// 	//function changeRecipient (address _newRecipient) public;

// 	//function setTimeout(uint256 newTimeout) public;

// }

contract ERCharity721 is ERC721, Ownable {

	address payable public recipient;
	uint256 public timeout = 7 days;
	uint256 public MAX_SUPPLY = 10_000;
	uint256 public COST = 0.05 ether;
	uint256 public MAXMINTPERTX = 100;
	uint256 public currentSupply;

	string public baseURI;

	constructor(string memory name_, string memory symbol_, address payable recipient_) ERC721(name_, symbol_) {
		recipient = recipient_;
	}

	function mintAssembly(uint256 _count) external payable {
		require(_count <= MAXMINTPERTX, "EXCEEDED MAX MINT PER TX");
		require(msg.value == COST * _count, "MSG VALUE MUST MATCH COST");
		unchecked {
			require(_count + currentSupply < MAX_SUPPLY, "EXCEEDED MAX SUPPLY");
			for (uint id = currentSupply; id < currentSupply + _count; ++id){
				assembly {
					mstore(0x0, id)
					mstore(0x20, ownerOf.slot)
					sstore(keccak256(0x0, 0x40), caller())
				}
			}
			assembly {
				mstore(0x0, caller())
				mstore(0x20, balanceOf.slot)
				let loc := keccak256(0x0, 0x40)
				sstore(loc, add(sload(loc), _count))
			}
		}
	}

	function mintSane(uint256 _count) external payable {
		require(_count <= MAXMINTPERTX, "EXCEEDED MAX MINT PER TX");
		require(msg.value == COST * _count, "MSG VALUE MUST MATCH COST");
		unchecked {
			require(_count + currentSupply < MAX_SUPPLY, "EXCEEDED MAX SUPPLY");

			for(uint id = currentSupply; id < currentSupply + _count; ++id){
				ownerOf[id] = msg.sender;
			}
			balanceOf[msg.sender] += _count;
			currentSupply += _count;
		}

	}

	function tokenURI(uint256 _id) public view virtual override returns (string memory) {
		require(_id < currentSupply, "NOT YET MINTED");
		return string(abi.encodePacked(baseURI, Strings.toString(_id), ".json"));

	}









}
