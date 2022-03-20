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

## Question 3

### Question 3.1: What problem does MACI not solve?

MACI does not solve the issue of creating tons of accounts and flooding the voting pools. There would need to be some proof-of-identity, or some kind of unique voting system to counteract multiplying keys to influence a vote.

### Question 3.2: How can a pseudorandom dice roll be simulated using just Solidity?

#### Q3.2.1

You could take the current block and hash it and then cast the hash to a uint256. You could try as much as possible to make this sophisticated: add in the user's address, some nonce and even a contract function call to provide some kind of external number, but this is all deterministic. This is made by design as a Blockchain's VM must have determinism at its core values in order to function. The obvious problem is that someone could design a program to obtain exactly a number they want with the correct inputs.

#### Q3.2.2: How would you design a multi party system that performs a dice roll?

I would create a smart contract where:
0. a global variable called lastRandomRoll is bytes32, initiated at 0, private.
1. a function can be called to open a dice roll round. 
2. the round lasts X blocks (decided by design or by global variable)
3. while the dice roll round is open, a function called `addRandomness` can be called by anyone. this function takes the msg.sender, the block timespan of the call, and hash the current lastRandomRoll and these two variables together, and stores it in lastRandomRoll.
4. when the round finishes, you cannot call this function `addRandomness` anymore. You can now call `getRoll` which exposes lastRandomRoll to anyone that wants to see the result as a typecasted uint256, until a new round starts.

#### Q3.2.3
I would believe that the first approach is deterministic so it's not reliable to achieve pseudo-randomness. As for the second approach, it is a bit better (also very expensive in terms of gas) as the more players play, the harder it is to predict the end result. I believe it is more fair, although convoluted. 

#### Q2.2.4
I'm not sure how to manipulate the result. I guess one way would be to monitor the calls to this function and reconstruct the lastRandomRoll variable from these calls (who called the smart contract, i.e. what address and what timestamp) and try to grab the "last" call to predict the outcome.

Now the last person of the round cannot guess the outcome with better information than other people! VDF solves this issue 🚀🚀 by adding a last step to ensure randomness.

### Question 3

#### Question 3.1

Interep uses Semaphore in order to hide (mixer functionality?) the identity of users that connected their OAuth to Interep. Their reputation on the connected social media is saved and can now be used to gain trustworthiness (in terms of credibility as a user and not being a bot). Their identity however, remains private.

It appears Interep needs a centralized server to enable OAuth (register as app?) and persist the OAuth connection.

#### Question 3.2


