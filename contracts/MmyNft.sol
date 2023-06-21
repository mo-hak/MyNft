// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNft is ERC721A, Ownable {
    uint public constant maxMintPerUser = 10;
    uint public constant maxMintPerBatch =50 ;
    uint public constant maxMintSupply = 300;
    string private baseURI;
    IERC20 public TokenAddress;
    uint256 public rate = 100 * 10 ** 18;
    
    constructor(address _tokenaddress) ERC721A("MyNft", "MTK") {
        TokenAddress= IERC20(_tokenaddress);
    }

    function setBaseURI(string memory __baseURI) external {
        baseURI = __baseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
   

    function safeMint(address[] calldata users, uint[] calldata quantities) public{
        uint count = users.length;
        require(count == quantities.length, "Invalid input");

         for (uint i = 0; i < count;) {
            address user = users[i];
            uint quantity = quantities[i];
            TokenAddress.transferFrom(user, address(this), rate*quantity);
            require(_numberMinted(user) + quantity <= maxMintPerUser, "Mint Limit");
            require(_totalMinted() + quantity <= maxMintSupply, "SOLD OUT");

            _safeMint(user, quantity);
            unchecked{
                i++;
            }
        }
    }
   
}