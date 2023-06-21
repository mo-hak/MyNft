// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNft is ERC721A, Ownable {
    uint public constant maxMintPerUser = 10;
    uint public constant maxMintPerBatch =50 ;
    uint public constant maxMintSupply = 300;
    string private baseURI;
     mapping(address => bool) private mintApproval;
      event ApprovalRequested(address indexed user);
       event ApprovalRevoked(address indexed user);
    constructor() ERC721A("MyNft", "MTK") {}

    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
    
    function requestApproval() external {
        require(!mintApproval[msg.sender], "Already requested approval");
        mintApproval[msg.sender] = true;
        emit ApprovalRequested(msg.sender);
    }

    function revokeApproval() external {
        require(mintApproval[msg.sender], "Approval not requested");
        mintApproval[msg.sender] = false;
        emit ApprovalRevoked(msg.sender);
    }

    function isApproved(address user) external view returns (bool) {
        return mintApproval[user];
    }


    function safeMint(address[] calldata users, uint[] calldata quantities) public{
        uint count = users.length;
        require(count == quantities.length, "Invalid input");

         for (uint i = 0; i < count;) {
            address user = users[i];
            uint quantity = quantities[i];

            require(mintApproval[user], "Approval required");
            require(_numberMinted(user) + quantity <= maxMintPerUser, "Mint Limit");
            require(_totalMinted() + quantity <= maxMintSupply, "SOLD OUT");

            _safeMint(user, quantity);
            unchecked{
                i++;
            }
        }
    }
   
}