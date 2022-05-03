// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

import "./Verifier.sol";

/* 
This is an example of a contract that can utilize an off-chain signature verification scheme.
Here, the 15 charity members vote off-line using 32bytes private keys and an EdDSA Poseidon scheme.
They vote on which address to fund: which non-profit to give their treasury to. This vote utilizes the Verifier contract created from the snark proof.
*/

contract OneCharity is Verifier {
    uint hashedSignersSet;
    mapping(uint => bool) private processedTransactions;

    constructor(uint _hashedSignersSet) {
        hashedSignersSet = _hashedSignersSet;
    }

    modifier isVerified(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[3] memory input
    ) {
        require(
            input[0] == hashedSignersSet,
            "Hashed Signers' Set does not match the one registered on-chain"
        );
        require(verifyProof(a, b, c, input), "Proof unsuccessfully verified");
        _;
    }

    receive() external payable {}

    function fundNonProfit(
        address payable _nonprofit,
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[3] memory input
    ) external isVerified(a, b, c, input) returns (bool) {
        require(
            processedTransactions[input[2]] != true,
            "Txn already processed"
        );
        processedTransactions[input[2]] = true;
        _nonprofit.transfer(10 ether);
        return true;
    }
}
