pragma circom 2.0.0;
include "./circomlib/circuits/eddsaposeidon.circom";
include "./circomlib/circuits/poseidon.circom";
include "./circomlib/circuits/comparators.circom";

template EdDSASignaturesVerifier(nInputs) {
    signal input signatureThreshold;

    signal input Ax[nInputs];
    signal input Ay[nInputs];

    signal input S[nInputs];
    signal input R8x[nInputs];
    signal input R8y[nInputs];

    signal input message;

    signal input isEnabled[nInputs];

    signal output hashedPubkeys;
    signal output validThreshold;
    signal output messageHash;

    messageHash <== message;

    var validSignatures = 0;

    component poseidonHashedPubkeys = Poseidon(nInputs);
    component verifiers[nInputs];
    for (var sig_idx = 0; sig_idx < nInputs; sig_idx++) {
        // Checking the signature using circomlib EdDSAPoseidonVerifier() template
        verifiers[sig_idx] = EdDSAPoseidonVerifier();
        // If equal to 1, verifier.enabled will try to recover the signature. If 0, sig verification will be skipped.
        // This enables the circuit to skip signers who did not sign.
        // Checking that isEnabled[sig_idx] is either 0 or 1.
        isEnabled[sig_idx]*(1-isEnabled[sig_idx]) === 0;
        verifiers[sig_idx].enabled <== isEnabled[sig_idx];

        verifiers[sig_idx].Ax <== Ax[sig_idx];
        verifiers[sig_idx].Ay <== Ay[sig_idx];
        verifiers[sig_idx].S <== S[sig_idx];
        verifiers[sig_idx].R8x <== R8x[sig_idx];
        verifiers[sig_idx].R8y <== R8y[sig_idx];
        verifiers[sig_idx].M <== message;

        validSignatures++;
        // Storing the pubkeys' hash one by one and for it to be outputed to the smart contract to check for consistency and coherence.
        poseidonHashedPubkeys.inputs[sig_idx] <== Ax[sig_idx];
    }

    hashedPubkeys <== poseidonHashedPubkeys.out;
    component greaterEqThan = GreaterEqThan(252);
    greaterEqThan.in[0] <== validSignatures;
    greaterEqThan.in[1] <== signatureThreshold;
    validThreshold <== greaterEqThan.out;
}

// Compile with max_inputs 100, fill with zeros where needed until you reach max capacity.
component main = EdDSASignaturesVerifier(15);