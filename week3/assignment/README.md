## 🚀🚀 Week 3 Assignment: Hey y'all ! Welcome 👋👋🚀🚀

## Question 1

### Question 1.1: Write a Circom circuit that verifies the triangle move.

See [triangle_move](./triangle_move/)

## Question 2

### Question 2.1: Card commitment 

I would design the process as follows:

1. Create a circuit that takes as private inputs: the card number (0 to 51) and a random number - the so-called salt - to be concatenated with the card number to produce a protected hash of the card number. 

Note that if we wanted to be super safe, we could do several rounds of salt (I read that it's a thing?). For our usecase, taking a sufficiently large range for random number generation will make brute force almost impossible (i.e. int254).

2. Use the circuit to hash (MiMCSponge for instance) the card number and the salt together and produce an output hash. That is to say:
`signal output out` such that `out <== MiMCSponge.outs[0]`.

3. Commit to a smart contract the following: the proof generated from the above circuit and the salted hash of the card number.

### Question 2.2: Picking another card from the suite

See [commit_card](./card_commit)
