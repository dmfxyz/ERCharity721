// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import 'ds-test/test.sol';
import "src/ERCharity721.sol";
import 'src/test/utils/IVM.sol';
import 'src/test/utils/console.sol';

contract ContractTest is DSTest {

	ERCharity721 c;
	Vm vm = Vm(HEVM_ADDRESS);
	string constant TOKEN_NAME = "TestName";
	string constant TOKEN_SYMBOL = "TestSymbol";
	address payable constant recepient = payable(address(0xFAB));

    function setUp() public {
    	c = new ERCharity721(TOKEN_NAME, TOKEN_SYMBOL, recepient);
    }

    function testConstructor() public {
        assertEq(c.name(), TOKEN_NAME);
        assertEq(c.symbol(), TOKEN_SYMBOL);
        assertEq(c.recipient(), recepient);
    }

    function testMintTenAssembly() public {
        address minter = address(0xB33F);
        vm.deal(minter, 1 ether);
        vm.startPrank(minter);
        c.mintAssembly{value: c.COST() * 10}(10);
        vm.stopPrank();

        assertEq(minter, c.ownerOf(0));
        assertEq(minter, c.ownerOf(1));
        assertEq(minter, c.ownerOf(2));
        assertEq(minter, c.ownerOf(3));
        assertEq(minter, c.ownerOf(4));
        assertEq(minter, c.ownerOf(5));
        assertEq(minter, c.ownerOf(6));
        assertEq(minter, c.ownerOf(7));
        assertEq(minter, c.ownerOf(8));
        assertEq(minter, c.ownerOf(9));
        assertEq(10, c.balanceOf(minter));
    }

    function testMintTenSane() public {
        address minter = address(0xB33F);
        vm.deal(minter, 1 ether);
        vm.startPrank(minter);
        c.mintSane{value: c.COST() * 10}(10);
        vm.stopPrank();

        assertEq(minter, c.ownerOf(0));
        assertEq(minter, c.ownerOf(1));
        assertEq(minter, c.ownerOf(2));
        assertEq(minter, c.ownerOf(3));
        assertEq(minter, c.ownerOf(4));
        assertEq(minter, c.ownerOf(5));
        assertEq(minter, c.ownerOf(6));
        assertEq(minter, c.ownerOf(7));
        assertEq(minter, c.ownerOf(8));
        assertEq(minter, c.ownerOf(9));
        assertEq(10, c.balanceOf(minter));
    }

    function testGetTokenURI() public {
        c.mintSane{value: c.COST()}(1);
        c.tokenURI(0);
    }

    function testSendDirect() public {
        address minter = address(0xf00f);
        vm.deal(minter, 1 ether);
        vm.startPrank(minter);
        address(c).call{value: 1 ether}("");
        assertEq(address(c).balance, 1 ether);
        vm.stopPrank();
    }
}
