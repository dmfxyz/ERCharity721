pragma solidity >=0.8.0;

import 'ds-test/test.sol';

interface Vm {
	function prank(address) external;
	function startPrank(address) external;
	function stopPrank() external;
	function warp(uint256) external;
	function deal(address, uint256) external;
	function expectRevert(string memory) external;
	function assume(bool) external;
}