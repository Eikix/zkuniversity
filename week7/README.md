# ZKDao: Zero-Knowledge University - Week 7

Welcome!!! Let's get into it.

## Question 1: Celestia

Celestia's solution is quite impressive and cool! I believe it is interesting for the use case of rollups and Ethereum, where posting calldata to Ethereum remains expensive to this day. A good example of this is zkSync on-chain smart contract vs. ZkPorter. The former uses on-chain data (safeguarding data availability and being more expensive) while the latter uses off-chain data (not guaranteed data availability but cheaper).

I'm not convinced that it's so practical to use two different solutions like Celestia suggests: one for settlement, the other for data availability. I believe the market tends to be attracted towards simplicity and security. The best solution in that case is L2s solutions on top of a scalable blockchain (i.e. one including sharding).

## Question 2: zk-STARKs

zk-Starts have several advantages over zk-Snarks:

- zk-Starks don't require a trusted setup but a universal and transparent setup. I believe this to be a good perk but in action, serious players will never risk running a trusted setup in an exploitable manner.
- Nonetheless, the above advantage has a very cool consequence: zk-Starks typically don't need to run a ceremony for every new circuit implementation, but rather one for the whole scheme.
- That being said, zk-SNARKs tend to be lighter (in Kb) as well as lighter computationally to verify.
- zk-Starks that rely solely on Hash functions are post quantum secure (any zkp that relies on elliptic curve is not post-quantum secure)

## Question 3: Polygon Zk-Products Stack

1. Polygon PoS Sidechain: The First Product

It is the chain people refer to as "Polygon" by default. It is a proof-of-stake chain that's basically an L1 with EVM technology. Many projects from Ethereum bridged over to Polygon, sometimes with a one for one equivalence (burn & mint) or just simply migrated.

2. Polygon Hermez: Decentralized and Active

A zk-Rollup L2 chain that is essentially used for business operations. Does not have EVM compatibility. Key information: 2000 tps (and rising) for 90% less gas costs.

3. Polygon Zero: Need for Speed

A zk-Rollup L2 chain that utilizes recursive SNARKs (Plonky2). Not gone public yet. Revolutionary in its time to generate proofs (170 ms).

4. Polygon Miden: STARKs not SNARKs

A zk-Rollup L2 chain that utilizes STARKs. Key points: Miden VM compatible with EVM, general purpose computing (Solidity, Vyper, etc.) so more freedom for developers.

5. Polygon Nightfall: Privacy for Enterprises

Created by EY (one of the big 4 auditing firms) along with Polygon. Key points: L2 Optimistic rollup + fraud proof.

6. Polygon Avail: Data Availability for Ethereum

Quote:

> meaning the entirety of the Avail chain is purposed to store Ethereum ‘calldata’ tracking changes to the Ethereum state machine. No smart contracts are intended to be deployed on Avail, and no applications can be built on Avail either. Rather, the entire purpose of Avail’s existence is to sequence and store data in order to ensure data remains accessible by a sampling process conducted by light client nodes.

TL;DR: very close to Celestia in a way. Big storage blockchain layer for data availability purposes.

7. Polygon Edge: Made With Developers in Mind

An SDK made to build modular blockchains: kind of like Polkadot's substrate, Cosmos and tendermint, or Avalanche's SDK.

## Question 4: What I have learnt

Oh damn! What have I learnt? It's not an easy question but it's a good time to settle down and look back:)!

- Through studying zero-knowledge proofs, I have learnt about the basics of cryptography: elliptic curves, different hash algorithms as well as hardware description languages. I learnt how to build a circuit and how to implement it.

- I also understood better the ins-and-out of SNARKs (trusted setup, power of tau, common random string, etc.), STARKs (transparency, proof size...) and other zero-knowledge mechanisms (FRI, etc.).

- On top of scalability and security, I discovered new essential challenges for blockchain, namely: the data availability issue, privacy necessity, fairness and anti-collusion protection.

- I also witnessed the power of open source, cooperation and kindness;)!

## Question 5: Update on final project (Stream B)

After speaking lovelace on discord, I found out my first idea was a bit too niche. The first idea was to provide users with a shielded identity NFT.

The new idea I submitted to the TAs group is an aggregated signature verifier. The aim is to provide bridges and DAOs on EVMs (or VMs that use ECDSA) the ability to sign messages and verify the signatures off-chain.

The idea is the following:

- In some given scenario, a certain number of users sign on a message using their private key. This results in a message being passed around as well as a bunch of signatures for that message.
- This would typically mean that some smart contract would have to loop through all these signatures and run ecrecover on that particular message and then verify recovered public addresses against a list.
- This is very costly in gas on Ethereum.

As an alternative, I offer an in-browser solution (or directly as a package) for verifying a high number of signatures for a given message. The zkp is then processed on-chain for a fixed size.

The ECDSA recovering method is implemented using this [repository](https://github.com/0xPARC/circom-ecdsa). This repository would allow me to use a circuit called `verify`. This circuit allows a programmer to provide: `r, s, msghash and pubKey` and runs an ECDSA signature verification on it.

The only remaining challenge would be to implement some kind of for loop for this signature verification inside the circom circuit.

I'll test that as soon as possible.
