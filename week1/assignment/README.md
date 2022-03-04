# Welcome to zkUniversity's first week assignment.

## Q1

### Q1.1

Check out merkle.circom !

### Q1.2

Upon trying to generate phase 2 of trusted setup, encountered an error:
<img src="./zku_assignment1_elias.PNG">

I fixed the error by using powers of tau: 14. ` 2**14 = 16,384` Which is bigger than the value we obtain in the error, ~14K.

Here is a screenshot of the execution.

<img src="./zku_assignment1_execution_elias.PNG">

### Q1.3

#### Do we really need zkProofs for this?

Well, not really! Here, we are constructing a merkle root using initial leaves as public inputs. Many different programming languages could construct a merkle root using leaves as parameters.
A smart contract like <a href="https://solidity-by-example.org/app/merkle-tree/"> this </a> could achieves a similar thing as it verifies if a leaf is inside a merkle tree using a merkle root and some well-chosen tree nodes. Or simply creating a smart contract that takes in leaves as input and returns the merkle root is perfectly feasible.

My only guess is that it must cost a lot of gas, meaning that on congested network, it might be expensive to create a merkle tree such as Ethereum.

#### Are there any technologies implementing this type of proof?

I guess zkRollups are somehow close to this: many transactions (leaves) are bundled up together and submitted on an L1 for a verifier contract to verify that they are valid.
