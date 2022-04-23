pragma circom 2.0.0;
include "../circomlib/circuits/eddsaposeidon.circom";
include "../circomlib/circuits/poseidon.circom";

template EdDSASignaturesVerifier(n) {
    signal input signatureThreshold;

    signal input Ax[n];
    signal input Ay[n];

    signal input S[n];
    signal input R8x[n];
    signal input R8y[n];

    signal input message;

    signal output hashedPubkeys;
    signal output validThreshold;

    var validSignatures = 0;

    for (int i = 0; i < n; i++) {
        if (S[i] != 0) {
            component verifier = EdDSAPoseidonVerifier();
            verifier.enabled <== 1;
            verifier.Ax <== Ax[i];
            verifier.Ay <== Ay[i];
            verifier.S <== S[i];
            verifier.R8x <== R8x[i];
            verifier.R8y <== R8y[i];
            verifier.M <== message;
            validSignatures += 1;
        }
    }

    component poseidonHashedPubkeys = Poseidon(n);
    for (int i = 0; i < n; i++) {
        poseidonHashedPubkeys.inputs[i] <== Ax[i];
    }

    hashedPubkeys <== poseidonHashedPubkeys.out;
    var isValidVote = validSignatures > signaturesThreshold ? 1 : 0;
    validThreshold <== isValidVote;
}