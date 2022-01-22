// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract ERC721 {
    mapping(uint256 => address) owners;
    mapping(address => uint256) balances;
    mapping(uint256 => address) tokenApprovals;
    mapping(address => mapping(address => bool)) operatorApprovals;

    event Transfer(address indexed _from, address indexed _to, uint256 _tokens);
    event Approval(address indexed _tokenOwner, address indexed _spender, uint256 _tokens);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    constructor () {
        owners[0] = msg.sender;
        balances[msg.sender] = 21000000;
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(owners[_tokenId] == _from);
        owners[_tokenId] = _to;
    }

    function approve(address to, uint256 _tokenId) public virtual {
        address owner = this.ownerOf(_tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            msg.sender == owner || this.isApprovedForAll(owner, msg.sender),
            "ERC721: approve caller is not owner nor approved for all"
        );

        tokenApprovals[_tokenId] = to;
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return operatorApprovals[owner][operator];
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        require(msg.sender != _operator, "ERC721: approve to caller");
        operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) public view returns (address) {
        require(owners[_tokenId] != address(0), "ERC721: approved query for nonexistent token");

        return tokenApprovals[_tokenId];
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        this.approve(address(0), _tokenId);

        balances[_from] -= 1;
        balances[_to] += 1;
        owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }
 
    function balanceOf(address _tokenOwner) public view returns (uint256) {
        return balances[_tokenOwner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return owners[_tokenId];
    }
}
