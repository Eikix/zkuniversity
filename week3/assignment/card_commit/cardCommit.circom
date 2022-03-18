pragma circom 2.0.3;

include "../../../../circomlib/circuits/mimcsponge.circom";


/* 
* @dev - This Template is meant to allow a player to commit their card to a smart contract that stores your picked card.
* The smart contract stores the salted hash of the card and the card's suite as a public integer (0 for clubs, 1 for spades, 2 for hearts and 3 for diamonds).
*/
template CommitCard() {
    signal input cardNumber; // Number between 0 and 12
    signal input cardSuite; // Number between 0 and 3
    signal input salt; // Secret int254
    signal output outputs[2]; // Will output the hash of the card and its suite.

    component digest = MiMCSponge(3, 220, 1);
    digest.k <== 0;
    digest.ins[0] <== cardNumber;
    digest.ins[1] <== cardSuite;
    digest.ins[2] <== salt;

    outputs[0] <== digest.outs[0];
    outputs[1] <== cardSuite;
}

component main = CommitCard();