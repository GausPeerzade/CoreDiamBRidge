// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "../src/DiamBridge.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./SampleERC20.sol";

contract CounterScript is Script {
    address public bridge = 0xeBEEEb9764e4bE3D7C32272214f314b5c5942Efc;
    address public usdc = 0x3287ec4f30f18230C4e0e9AC0395923371BcD1bc;

    function setUp() public {}

    function run() public {
        uint256 privateKey = 0x3f66a86fa9d57ed2535e9e36802e3ec0d82488e7c24984cb150203e1a6229c88;
        address owner = vm.addr(privateKey);
        console.log(owner);
        vm.startBroadcast(privateKey);
        // SERC20 usdc = new SERC20("USDC", "USDC", 18);
        // console.log(address(usdc));
        // usdc.mint(owner, 1000000e18);
        // DiamBridge dbridge = new DiamBridge(owner);
        // console.log(address(dbridge));
        // dbridge.addToken(address(usdc), "USDC");

        IERC20(usdc).approve(bridge, 1000e18);
        DiamBridge(bridge).bridgeToDiam(usdc, 1e18, "gg");

        vm.stopBroadcast();
    }
}
//forge script script/Counter.s.sol:CounterScript --rpc-url https://rpc.test.btcs.network --broadcast -vvv --legacy --slow
