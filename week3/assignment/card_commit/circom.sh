## Compile circuit file

circom cardCommit.circom --r1cs --wasm --sym --c

## Witness generation 

node cardCommit_js/generate_witness.js cardCommit_js/cardCommit.wasm input.json witness.wtns

## Power of tau generation 

# Phase 1

snarkjs powersoftau new bn128 12 pot12_0000.ptau -v

snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v

# Phase 2

snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v

snarkjs groth16 setup cardCommit.r1cs pot12_final.ptau cardCommit_0000.zkey

snarkjs zkey contribute cardCommit_0000.zkey cardCommit_0001.zkey --name="1st Contributor Name" -v

snarkjs zkey export verificationkey cardCommit_0001.zkey verification_key.json

snarkjs groth16 prove cardCommit_0001.zkey witness.wtns proof.json public.json

snarkjs zkey export solidityverifier cardCommit_0001.zkey Verifier.sol
