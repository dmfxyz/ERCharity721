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
	uint256 public minumumWithdrawal;

	string public baseURI;

	constructor(string memory name_
			,string memory symbol_
			,address payable recipient_
			,uint256 minumumWithdrawal_) 
			ERC721(name_, symbol_) 
			{
				recipient = recipient_;
				minumumWithdrawal = minumumWithdrawal_;
			}

	function mintAssembly(uint256 _count) external payable {
		require(_count <= MAXMINTPERTX, "EXCEEDED MAX MINT PER TX");
		require(msg.value == COST * _count, "MSG VALUE MUST MATCH COST");
		unchecked {
			require(_count + currentSupply <= MAX_SUPPLY, "EXCEEDED MAX SUPPLY");
            // can probably make this assembly too? I did this but reverted it. Can't remember why 
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

	function sendToRecipient() external {
		require(address(this).balance >= minumumWithdrawal, "Contract balance below withdrawal minimum");
		uint256 balance = address(this).balance;
		(bool transferTx, ) = recipient.call{value: balance}("");
		require(transferTx);
	}

	function setMinimumWithdrawal(uint256 newMinimum_) external onlyOwnerOrRecipient {
        minumumWithdrawal = newMinimum_;
    }

	/* Lots to think about here. 
    * Recipient may not be an EOA or may not be able to interact
	* Implies that owner can be trusted
	* Maybe can have something that checks recipient codesize OR if it implements something like *receiver?
    * !! to come back to and seek community opinion !!
	*/	
	modifier onlyOwnerOrRecipient() {
		require(msg.sender == owner() || msg.sender == recipient);
        _;
	}

	//fallback() external payable {}
	receive() external payable {}









}
