// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title NFTMinter
 * @dev Implementation of a gas-optimized ERC721A NFT collection.
 */
contract NFTMinter is ERC721A, Ownable {
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant MINT_PRICE = 0.01 ether;
    string private _baseTokenURI;

    constructor(string memory name, string memory symbol, string memory initialBaseURI) 
        ERC721A(name, symbol) 
        Ownable(msg.sender) 
    {
        _baseTokenURI = initialBaseURI;
    }

    /**
     * @dev Public minting function. 
     * Requirement: Correct payment and supply remaining.
     */
    function mint(uint256 quantity) external payable {
        require(totalSupply() + quantity <= MAX_SUPPLY, "Reached max supply");
        require(msg.value >= MINT_PRICE * quantity, "Insufficient funds");
        
        _safeMint(msg.sender, quantity);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    /**
     * @dev Withdraw contract balance to owner wallet.
     */
    function withdraw() external onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }
}
