//SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ApolloSpaceToken} from "./AST.sol";


contract StarRegistry is ERC721{

    address public owner;

    address public tokenAddress;

    mapping(uint256=>address) public tokenCreators;

    mapping(uint256=>uint256) public tokenPriceinWEI;

    mapping(uint256=>uint256) private highestCurrentBid;

    mapping(uint256 => address) public highestBidder;

    mapping(address=>bool) private approvedMinters;

    constructor(address _tokenAddress) ERC721("Star Registry","STR") public{
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }

    function approveMinter(address minter) public  {
        require(msg.sender == owner);
        approvedMinters[minter] = true;
    }

    function createNFT(uint256 id,uint256 price) external {
        require(msg.sender==owner || approvedMinters[msg.sender] == true,"Not approved Minter" );
        _safeMint(msg.sender, id);
        tokenPriceinWEI[id] = price;
        
    }

    function bid(uint256 id,uint256 bidAmt) public {
        require(IERC20(tokenAddress).balanceOf(msg.sender)>=bidAmt,"Low AST balance to bid");
        require(msg.sender != ownerOf(id),"Token owner cannot bid");
        if(bidAmt > highestCurrentBid[id]){
            highestCurrentBid[id] = bidAmt;
            highestBidder[id] = msg.sender;
        }else{
            revert();
        }
    }

    function buy(uint256 id) external {
        require(_exists(id) && IERC20(tokenAddress).transferFrom(msg.sender,ownerOf(id),tokenPriceinWEI[id]));
        safeTransferFrom(ownerOf(id),msg.sender,id);

    }

    function acceptBid(uint256 id) external {
        require(msg.sender == ownerOf(id));
        require(IERC20(tokenAddress).transferFrom(msg.sender,ownerOf(id),tokenPriceinWEI[id]));
        safeTransferFrom(ownerOf(id), highestBidder[id],id);
    }
}