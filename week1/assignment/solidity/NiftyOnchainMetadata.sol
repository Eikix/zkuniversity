// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./5_MerkleTree.sol";


/** 
* @title NiftyOnchainMetadata
* @dev Implements ERC721 standard from Openzeppelin with onchain metadata (name + description fields).
*/

contract NiftyOnchainMetadata is ERC721("zkNifty", "ZKNFT"), MerkleProof {

    // The token ID incrementor. 
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    
    // We will create a merkle tree to store mint transactions of this collection.
    // Thus, we need to pre-decide on a size for the tree and create an empty tree at first.
    uint256 numberOfLeaves;
    bytes32[] private merkleTreeNodes;
    Counters.Counter private _currentLeaf;
    

    // The metadata format for on-chain. Name and Description of each NFT.
    struct Metadata {
        string name;
        string description;
    }
    // Mapping that links a token ID to its metadata.
    mapping(uint256 => Metadata) private _tokenMetadata;

    constructor(uint256 _nLeaves) {
        numberOfLeaves = _nLeaves;

        // Merkle Tree Initialization
       
        for (uint i = 0; i < _nLeaves; i++) {
            merkleTreeNodes.push(keccak256(abi.encodePacked("createNewEmptyMerkleTree")));
        }

        uint n = _nLeaves;
        uint offset = 0;

        while (n > 0) {
            for (uint i = 0; i < n - 1; i += 2) {
                merkleTreeNodes.push(
                    keccak256(
                        abi.encodePacked(merkleTreeNodes[offset + i], merkleTreeNodes[offset + i + 1])
                    )
                );
            }
            offset += n;
            n = n / 2;
        }
    }

    // Merkle Tree

    /**
    * @dev Updates a Merkle Tree given that we have added one leaf to it at position _leafPosition.
    */
    function updateMerkleTree(uint256 _leafPosition) public {
        uint n = numberOfLeaves;
        uint offset = numberOfLeaves;
        uint tempNodePosition = _leafPosition;
        // Current Level (as in Building Floor) of the Tree. Starts at 1 for base leafs.
        uint currentTreeLevel = 2;
        while (n > 0) {
            uint treePosition = offset + tempNodePosition/2;
            if (tempNodePosition % 2 == 0) {
                merkleTreeNodes[treePosition] =
                    keccak256(
                        abi.encodePacked(merkleTreeNodes[tempNodePosition], merkleTreeNodes[tempNodePosition + 1])
                    );
            } else if (tempNodePosition % 2 == 1) {
                merkleTreeNodes[treePosition] =
                    keccak256(
                        abi.encodePacked(merkleTreeNodes[tempNodePosition - 1], merkleTreeNodes[tempNodePosition])
                    );
            }
            n = n / 2;
            offset += n;
            currentTreeLevel += 1;
            tempNodePosition = treePosition % (numberOfLeaves/currentTreeLevel);
        }
    }

    /**
    * @dev Adds a leaf to the Merkle Tree
    */
    function addLeaf(bytes32 _leaf) public {
        _currentLeaf.increment();
        uint256 currentLeaf = _currentLeaf.current() - 1;
        require(currentLeaf < numberOfLeaves - 1, "You have exceeded the number of base leaves in the tree");
        merkleTreeNodes[currentLeaf] = _leaf;
        updateMerkleTree(currentLeaf);
    }

    /**
    * @dev Getter for Merkle Root
    */
    function getRoot() public view returns(bytes32) {
        return merkleTreeNodes[numberOfLeaves*2 - 2];
    }

    /**
    * @dev Get the whole merkle tree as array
    */
    function getMerkleTree() public view returns(bytes32[] memory) {
        return merkleTreeNodes;
    }

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
        bytes32 newMintHash = keccak256(
            abi.encodePacked(msg.sender, to, newNiftyId, _name, _description)
        );
        addLeaf(newMintHash);
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