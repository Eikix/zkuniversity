### This command compiles the circuit to get a system of arithmetic equations representing it.

# --r1cs:
## The --r1cs contains the Rank-1 Constraint System (R1CS) in binary format. With circom, you design your own circuits with your own constraints, and the compiler outputs the R1CS representation that you will need for your zero-knowledge proof.

# --wasm:
## Generates a directory [name]_js where the .wasm file lives. These files are used to generate the witness, i.e., the set of signals that satisfy the circuit.

# --sym:
## Generates the file [name].sym. These symbols file are used to debugging/printing the constraint system in an annotated mode.

# --c:
## Generates the directory [name]_cpp. Contains the equivalent of the wasm directory used to generate the witness of the circuit.

circom merkle.circom --r1cs --wasm --sym --c


### Then, we need to generate a witness: a set of signals that satisfy the circuit. We'll need an inputs JSON file that contains all the circuit's inputs.

# Logic/programmatic logic files: generate_witness.js, merkle.wasm 
# Input file: input.json
# Output file: witness.wtns 

node merkle_js/generate_witness.js merkle_js/merkle.wasm input.json witness.wtns


# Intermediary remark: After compiling the circuit and running the witness calculator with an appropriate input, we will have a file with extension .wtns that contains all the computed signals and, a file with extension .r1cs that contains the constraints describing the circuit. Both files will be used to create our proof.


### We use Groth16 here. It is a zk-SNARK protocol. To use it, one needs to generate a trusted setup. As per the paper by cryptographic researchers, we need a common source of entropy to generate the proof. The trusted setup generation is equivalent to some ceremony where people agree to some source of randomness. It is considered a potential point of failure as any actor should not know the seed to the randomness used by all participants (unlikely in the real world, but important to know). 

# Phase 1 of the trusted setup generation is called the powers of tau. It is independent of the circuit itself. Note that one should choose a power of tau high enough to run phase 2, otherwise will get an error of the from "X > 2^n".

snarkjs powersoftau new bn128 14 pot14_0000.ptau -v

snarkjs powersoftau contribute pot14_0000.ptau pot14_0001.ptau --name="First contribution" -v

# Phase 2 is circuit-specific and is used to generate a .zkey file. This file contains proving and verification keys.

snarkjs powersoftau prepare phase2 pot14_0001.ptau pot14_final.ptau -v

snarkjs groth16 setup merkle.r1cs pot14_final.ptau merkle_0000.zkey

snarkjs zkey contribute merkle_0000.zkey merkle_0001.zkey --name="1st Contributor Name" -v

snarkjs zkey export verificationkey merkle_0001.zkey verification_key.json

### Generate a proof. To compute the proof, you need a witness and a trusted setup for your circuit.

snarkjs groth16 prove merkle_0001.zkey witness.wtns proof.json public.json

### You're done ! You can now verify the proof from the CLI by running :

snarkjs groth16 verify verification_key.json public.json proof.json

# Or by verifying it from a smart contract :

snarkjs zkey export solidityverifier merkle_0001.zkey verifier.sol


