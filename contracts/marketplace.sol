// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "./erc1155.sol";

contract  Marketplace is ERC1155Holder, erc1155 {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _nftSold;
    address private owner;
    uint256 private platformFee = 25;

    constructor() erc1155(){}

    struct NFTMarketItem{
        uint256 tokenId;
        uint256 nftId;
        uint256 amount;
        uint256 price;
        address payable seller;
        address payable owner;
        bool sold;
    }

    mapping(uint256 => NFTMarketItem) private marketItem;

      function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155Receiver, ERC1155) returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
    }

    function ListNft(uint256 nftId,uint256 amount, uint256 price) external {

        uint _nft = balanceOf(msg.sender,nftId);
        require(_nft > 0, "Token doesnot exist");

        
        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        marketItem[tokenId] = NFTMarketItem(
            tokenId,
            nftId,
            amount,
            price,
            payable(msg.sender),
            payable(msg.sender),
            false
        );
        
        _safeTransferFrom(msg.sender, address(this), nftId, amount, "");
    }

    function BuyNFT(uint256 tokenId, uint256 amount) external payable {


        uint256 price = marketItem[tokenId].price ;
        uint256 nftamount = marketItem[tokenId].amount;
        address NftSeller = marketItem[tokenId].seller;

        require(nftamount >= amount, " Amount limit exceed");
        require( msg.value == price*amount ,"Insuffecent funds");

        marketItem[tokenId].owner = payable(msg.sender);

       // onERC1155Received(address(this), msg.sender, tokenId, amount, "");
        _safeTransferFrom(address(this), msg.sender, tokenId, amount, "");

        (bool success, ) = NftSeller.call{value:msg.value}("");
        require(success, "Transfer failed sending to owner.");

        _nftSold.increment();
    }


    // function GetMarket_listing(uint _tokenid) public view returns(uint,uint,uint,address,bool){

    //     return (marketItem[_tokenid].nftId ,marketItem[_tokenid].amount, marketItem[_tokenid].price,marketItem[_tokenid].seller,marketItem[_tokenid].sold);
    // }

       function GetMarket_listing(uint _tokenid) public view returns(NFTMarketItem memory){
           return marketItem[_tokenid];
    }

}