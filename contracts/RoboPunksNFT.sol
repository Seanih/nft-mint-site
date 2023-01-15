//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RoboPunksNFT is ERC721, Ownable {
    uint256 public mintPrice;
    uint256 public totalSupply;
    uint256 public maxSupply;
    uint256 public maxPerWallet;
    bool public isPublicMintEnabled;
    string internal baseTokenUri; //url that points to image(s)
    address payable public withdrawalWallet;

    mapping(address => uint256) public walletMints;

    constructor() payable ERC721("RoboPunks", "RP") {
        mintPrice = 0.02 ether;
        totalSupply = 0;
        maxSupply = 1000;
        maxPerWallet = 3;
    }

    function setIsPublicMintEnabled(bool _isPublicMintEnabled)
        external
        onlyOwner
    {
        isPublicMintEnabled = _isPublicMintEnabled;
    }

    function setBaseTokenUri(string calldata _baseTokenUri) external onlyOwner {
        baseTokenUri = _baseTokenUri;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(_exists(_tokenId), "No token linked to that ID");

        return
            // concats tokenUri, tokenId & .json file-type into a string that is used by nft marketplaces to retrieve NFT images
            string(
                abi.encodePacked(
                    baseTokenUri,
                    Strings.toString(_tokenId),
                    ".json"
                )
            );
    }

    function withdrawFunds() external onlyOwner {
        (bool success, ) = withdrawalWallet.call{value: address(this).balance}(
            ""
        );

        require(success, "Sorry, the withdrawal failed");
    }

    function mint(uint256 _quantity) public payable {
        require(isPublicMintEnabled, "minting is currently disabled");
        require(msg.value == _quantity * mintPrice, "wrong mint value");
        require(totalSupply + _quantity <= maxSupply, "sold out");
        require(
            walletMints[msg.sender] + _quantity <= maxPerWallet,
            "exceeded max wallet amount"
        );

        for (uint256 i = 0; i < _quantity; i++) {
            uint256 newTokenId = totalSupply + 1;
            totalSupply++;
            _safeMint(msg.sender, newTokenId);
        }
    }
}
