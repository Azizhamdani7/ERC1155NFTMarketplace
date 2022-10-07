// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract erc1155 is ERC1155{

    mapping(uint256 => string) public uris;

    constructor() ERC1155("") {}

    function setTokenUri(uint _tokenId, string memory _uri) public {
        uris[_tokenId] = _uri;
    }

    function mintNFT(address account, uint256 tokenId, uint256 amount, string memory _uri)
        public
    {
        _mint(account, tokenId, amount, "");
        setTokenUri(tokenId,_uri);
        // setApprovalForAll(marketplace, true);
    }

}