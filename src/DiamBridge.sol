// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DiamBridge {
    address public owner;
    address public relayer;
    mapping(address => bool) public isTokenAllowed;
    mapping(address => string) public tokenName;

    uint256 public bridgeId = 0;
    mapping(uint256 => string) public processed;

    event bridge(address user, string token, uint256 amount);
    event bridgeFromDiam(address user, address token, uint256 amount);

    constructor(address _relayer) {
        owner = msg.sender;
        relayer = _relayer;
    }

    function addToken(
        address _token,
        string memory _tokenName
    ) public returns (bool) {
        require(msg.sender == owner, "Only Owner is allowed to add tokens");
        require(isTokenAllowed[_token] == false, "Token is already added");
        isTokenAllowed[_token] = true;
        tokenName[_token] = _tokenName;
        return true;
    }

    function bridgeToDiam(
        address _token,
        uint256 _amount,
        string memory _diamAddress
    ) public returns (uint256) {
        require(isTokenAllowed[_token], "Token is not allowed to transfer");
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        bridgeId++;
        processed[bridgeId] = _diamAddress;
        emit bridge(msg.sender, tokenName[_token], _amount);
        return bridgeId;
    }

    function bridgeBack(
        address _token,
        uint256 _amount,
        address _user
    ) public returns (bool) {
        require(isTokenAllowed[_token], "Token is not allowed to transfer");
        require(msg.sender == relayer, "You are not allowed to transer");
        IERC20(_token).transfer(_user, _amount);

        emit bridgeFromDiam(_user, _token, _amount);
        return true;
    }
}
