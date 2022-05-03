### This command compiles the circuit to get a system of arithmetic equations representing it.

# --r1cs:
## The --r1cs contains the Rank-1 Constraint System (R1CS) in binary format. With circom, you design your own circuits with your own constraints, and the compiler outputs the R1CS representation that you will need for your zero-knowledge proof.

# --wasm:
## Generates a directory [name]_js where the .wasm file lives. These files are used to generate the witness, i.e., the set of signals that satisfy the circuit.

# --sym:
## Generates the file [name].sym. These symbols file are used to debugging/printing the constraint system in an annotated mode.

# --c:
## Generates the directory [name]_cpp. Contains the equivalent of the wasm directory used to generate the witness of the circuit.

circom ./eddsasignaturesverifier.circom --r1cs --wasm --sym --c


### Then, we need to generate a witness: a set of signals that satisfy the circuit. We'll need an inputs JSON file that contains all the circuit's inputs.

# Logic/programmatic logic files: generate_witness.js, merkle.wasm 
# Input file: input.json
# Output file: witness.wtns 

node eddsasignaturesverifier_js/generate_witness.js eddsasignaturesverifier_js/eddsasignaturesverifier.wasm input.json witness.wtns


# Intermediary remark: After compiling the circuit and running the witness calculator with an appropriate input, we will have a file with extension .wtns that contains all the computed signals and, a file with extension .r1cs that contains the constraints describing the circuit. Both files will be used to create our proof.


### We use Groth16 here. It is a zk-SNARK protocol. To use it, one needs to generate a trusted setup. As per the paper by cryptographic researchers, we need a common source of entropy to generate the proof. The trusted setup generation is equivalent to some ceremony where people agree to some source of randomness. It is considered a potential point of failure as any actor should not know the seed to the randomness used by all participants (unlikely in the real world, but important to know). 

# Phase 1 of the trusted setup generation is called the powers of tau. It is independent of the circuit itself. Note that one should choose a power of tau high enough to run phase 2, otherwise will get an error of the from "X > 2^n".

snarkjs powersoftau new bn128 17 pot17_0000.ptau -v

snarkjs powersoftau contribute pot17_0000.ptau pot17_0001.ptau --name="First contribution" -v

# Phase 2 is circuit-specific and is used to generate a .zkey file. This file contains proving and verification keys.

snarkjs powersoftau prepare phase2 pot17_0001.ptau pot17_final.ptau -v

snarkjs groth16 setup eddsasignaturesverifier.r1cs pot17_final.ptau eddsasignaturesverifier_0000.zkey

snarkjs zkey contribute eddsasignaturesverifier_0000.zkey eddsasignaturesverifier_0001.zkey --name="1st Contributor Name" -v

snarkjs zkey export verificationkey eddsasignaturesverifier_0001.zkey verification_key.json

### Generate a proof. To compute the proof, you need a witness and a trusted setup for your circuit.

snarkjs groth16 prove eddsasignaturesverifier_0001.zkey witness.wtns proof.json public.json

### You're done ! You can now verify the proof from the CLI by running :

snarkjs groth16 verify verification_key.json public.json proof.json

# Or by verifying it from a smart contract :

snarkjs zkey export solidityverifier eddsasignaturesverifier_0001.zkey verifier.sol


### snarkjs generatecall
## result example:
### ["0x11294576a8beed4aef560d591fbdc2d5e220c2b6e9a3768e34f54c4865e08361", "0x1b341eeccf9fbe60ae9f4088b54d4758fad8dfc6123c55569b3bf9351d4f8504"],[["0x025e2d15cae24d75f1c2881e01918dc9297c0fb50a6c15f13951e444cf3b87a8", "0x16b970e44cd82af2c62e2b3ea6dbb2402932f02079db2eb082c476f710c0f965"],["0x14195fd027b43aece3852bf9db1f478e4e20f429b3da88835567619cf75bc102", "0x16fbdc0d6f528f6e56477af43f4cca5b0be9f79b0d08385f851589d6b1d6a148"]],["0x023d45f1d68402e2e7a89d2622d67797281331d958a137b9398fa5ba198a160e", "0x270360837669f74451ce9cbdf726dbe93926daaad3f70c54014ba54e8db88e80"],["0x20c82879377e86f93447ff8bfadf05477b5aadd636673b2686b5c092b8187def","0x0000000000000000000000000000000000000000000000000000000000000001","0x00000000000000000000000000000000000000000000000000000000000004d2"]