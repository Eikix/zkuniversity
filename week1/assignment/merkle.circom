pragma circom 2.0.0;

include "../../../circomlib/circuits/mimcsponge.circom";

template MerkleRoot(nInputs) {
    signal input leaves[nInputs];
    signal output merkleRoot;
    var k = 0;
    component treeNodes[nInputs*2 -1];
    var hashes[nInputs*2 -1];

    // First for loop: hashing all the base components in the tree. 
    for (var i = 0; i < nInputs; i++) {
        treeNodes[i] = MiMCSponge(1, 220, 1);
        treeNodes[i].ins[0] <== leaves[i];
        treeNodes[i].k <== k;
        hashes[i] = treeNodes[i].outs[0];
    }

    // Second for loop: computing the tree nodes
    for (var i = 2; i < nInputs*2 - 1; i=i+2) {
        treeNodes[i/2 + nInputs - 1] = MiMCSponge(2, 220, 1);
        treeNodes[i/2 + nInputs - 1].ins[0] <== hashes[i-2];
        treeNodes[i/2 + nInputs - 1].ins[1] <== hashes[i-1];
        treeNodes[i/2 + nInputs - 1].k <== k;
        hashes[i/2 + nInputs - 1] = treeNodes[i].outs[0];
    }

    merkleRoot <== treeNodes[nInputs*2-2].outs[0];
}

component main {public [leaves]} = MerkleRoot(8);