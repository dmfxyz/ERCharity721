// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import 'ds-test/test.sol';
import "src/ERCharity721.sol";
import 'src/test/utils/IVM.sol';
import 'src/test/utils/Console.sol';

contract ContractTest is DSTest {

	ERCharity721 c;
	Vm vm = Vm(HEVM_ADDRESS);
	string constant TOKEN_NAME = "TestName";
	string constant TOKEN_SYMBOL = "TestSymbol";
	address payable constant recepient = payable(address(0xFAB));

    function setUp() public {
    	c = new ERCharity721(TOKEN_NAME, TOKEN_SYMBOL, recepient, 1 ether);
    }

    function testConstructor() public {
        assertEq(c.name(), TOKEN_NAME);
        assertEq(c.symbol(), TOKEN_SYMBOL);
        assertEq(c.recipient(), recepient);
    }

    function testMintTenAssembly(uint8 count) public {
        vm.assume(count <= c.MAXMINTPERTX());
        address minter = address(0xB33F);
        vm.deal(minter, count * c.COST());
        vm.startPrank(minter);
        c.mintAssembly{value: c.COST() * count}(count);
        vm.stopPrank();
        for (uint i; i < count; ++i) {
            assertEq(minter, c.ownerOf(i));
        }
        assertEq(count, c.balanceOf(minter));
    }

    function testMintTenSane(uint8 count) public {
        vm.assume(count <= c.MAXMINTPERTX());
        address minter = address(0xB33F);
        vm.deal(minter, count * c.COST());
        vm.startPrank(minter);
        c.mintSane{value: c.COST() * count}(count);
        vm.stopPrank();

       for (uint i; i < count; ++i) {
            assertEq(minter, c.ownerOf(i));
        }
        assertEq(count, c.balanceOf(minter));
    }

    function testFailMintTooManyAssembly(uint256 count) public {
        vm.assume(count > c.MAXMINTPERTX());
        vm.expectRevert("EXCEEDED MAX SUPPLY");
        c.mintAssembly{value: c.COST() * count}(count);
    }

    function testFailMintTooManySane(uint256 count) public {
        vm.assume(count > c.MAXMINTPERTX());
        vm.expectRevert("EXCEEDED MAX SUPPLY");
        c.mintSane{value: c.COST() * count}(count);
    }

    function testGetTokenURI() public {
        c.mintSane{value: c.COST()}(1);
        c.tokenURI(0);
    }

    function testSendToRecipient() public {
        vm.deal(address(c), 1 ether);
        uint256 charityBalance = address(c).balance;
        c.sendToRecipient();
        assertEq(recepient.balance, charityBalance);
    }

    function testFailSendToRecipientBelowMinimum () public {
        vm.expectRevert("Contract balance below withdrawal minimum");
        vm.deal(address(c), 0.5 ether);
        c.sendToRecipient();
    }

    function testSetMinimumWithdrawal(uint256 minimum) public {
        c.setMinimumWithdrawal(minimum);
        assertEq(c.minumumWithdrawal(), minimum);
    }
}
