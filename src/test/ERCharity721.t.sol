// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import 'ds-test/test.sol';
import "src/ERCharity721.sol";
import 'src/test/utils/IVM.sol';

contract ContractTest is DSTest {

	ERCharity721 c;
	Vm vm = Vm(address(HEVM_ADDRESS));
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
}
