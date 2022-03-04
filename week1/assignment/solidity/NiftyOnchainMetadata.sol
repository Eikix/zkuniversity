// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


/** 
* @title NiftyOnchainMetadata
* @dev Implements ERC721 standard from Openzeppelin with onchain metadata (name + description fields).
*/

contract NiftyOnchainMetadata is ERC721("zkNifty", "ZKNFT") {

    // The token ID incrementor. 
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // The metadata format for on-chain. Name and Description of each NFT.
    struct Metadata {
        string name;
        string description;
    }
    // Mapping that links a token ID to its metadata.
    mapping(uint256 => Metadata) private _tokenMetadata;


    /**
    * @dev Mints a new NFT. Will:
        - increment the global counter acting as tokenId.
        - mint the NFT with tokenId === current counter
        - store on-chain the metadata (name & description) of this NFT.
        - return the tokenId.
    */
    function mint(address to, string memory _name, string memory _description) public returns(uint256) {
        _tokenIds.increment();
        uint256 newNiftyId = _tokenIds.current();
        _safeMint(to, newNiftyId);
        Metadata memory _metadata = Metadata(
            _name,
            _description
        );
        _tokenMetadata[newNiftyId] = _metadata;
        return newNiftyId;
    }

    /**
    * @dev Returns the NFT metadata (name + description) corresponding to the tokenId provided.
    */
    function tokenMetadata(uint256 tokenId) public view returns(Metadata memory) {
        return _tokenMetadata[tokenId];
    }
}