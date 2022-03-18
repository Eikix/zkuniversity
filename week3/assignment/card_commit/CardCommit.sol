pragma solidity ^0.6.11;

import "./IVerifier.sol";

contract CardCommit {
    address public verifierAddress;

    struct Card {
        bytes32 cardHash;
        uint8 cardSuite;
    }
    mapping(address => Card) public playerCards;

    constructor(address _verifierAddress) {
        verifierAddress = _verifierAddress;
    }

    function commitCard(
        bytes32 cardHash,
        uint8 cardSuite,
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[2] memory input
    ) public {
        require(
            IVerifier(verifierAddress).verifyProof(a, b, c, input),
            "Failed to verify the proof"
        );
    }
}
