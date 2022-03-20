pragma solidity ^0.6.11;

import "./IVerifier.sol";

contract CardCommit {
    address public verifierAddress;

    struct Card {
        bytes32 cardHash;
        uint8 cardSuite;
    }

    struct Proof {
        uint[2] a;
        uint[2][2] b;
        uint[2] c;
        uint[2] input;
    }

    mapping(address => Card) public playerCards;

    constructor(address _verifierAddress) {
        verifierAddress = _verifierAddress;
    }

    function commitCard(
        bytes32 cardHash,
        uint8 cardSuite,
        Proof memory proof
    ) public {
        require(
            IVerifier(verifierAddress).verifyProof(proof.a, proof.b, proof.c, proof.input),
            "Failed to verify the proof"
        );
        playerCards[msg.sender] = Card(cardHash, cardSuite);

    }
}
