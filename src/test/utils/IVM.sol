pragma solidity >=0.8.0;

import 'ds-test/test.sol';

interface Vm {
	function prank(address) external;
	function warp(uint256) external;
	function deal(address, address) external;
}