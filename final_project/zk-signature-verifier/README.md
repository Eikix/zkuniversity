# Hey everyone ! Welcome to my Zero-Knowledge University Final Project: Zero-Knowledge Signatures Verifier

### The aim of this project is to provide a small app (circuit as well as a UI) that will enable users to verify off-chain a large amount of signatures and verify on-chain the produced zero-knowledge proof.

Who might want or need this app in the future?

## Introduction: Who might need this product?

1. Bridges

Decentralised Bridges essentially rely on a decentralized network of relayer nodes. These nodes typically need to sign on payloads very often. These signatures are then verified on-chain. Depending on the signature scheme, this verification can be very costly in gas and computation.
Let's put aside BLS, TSS and Schnorr Signature for a second, and consider the simplest case: aggregating signatures linearly. Say a bridge has 20 relayer nodes, then at every bridge request, these nodes sign on a message. At the end of the process, some smart contract needs to loop over these 20 signatures and run a signature recovering algorithm to verify the payload's authenticity.

Using Solidity and the EVM, we'd do it using `ecrecover` built-in function. On the Ethereum blockchain, looping over many signatures is obnoxiously expensive at the moment (in 2022, as we speak:) let's hope the merge happens soon :sparkles:). Moreover, it is not scalable: if the Bridge protocol wants to incorporate more nodes in its network, the gas fees grow linearly, virtually forever.
On Ethereum, it gets really expensive, but on other networks, it's just quite inefficient, and might become expensive. For instance, fees are quite low at the moment on Polygon, but it's mainly because the MATIC coin is not too expensive. That being said, when the Polygon network is congested, fees can get quite high and would be almost as expensive as those on Ethereum if MATIC was more expensive.

2. DAOs

Decentralised Autonomous Organisation essentially want to enable the ability to for all members to vote freely on proposals. Thus one of their challenges is to facilitate democratic processes.
One barrier to entry can be gas fees: if a DAO's proposal needs signatures from 2000 members, it'll usually settle for off-chain voting. This defeats somehow the purpose of on-chain voting and web3 democrary.

One solution to this particular issue would be to allow on-chain signature verification for the 200 members using the zkSignature Verifier. You'd end up with the best of both worlds: web3 enabled voting, i.e. on-chain security as well as low fees.

Someone could argue that gas fees are not a problem on other low fees chains, such as Near, Harmony or Terra. This is very true. These chains are using different techniques to achieve high tps, among which sharding. Nonetheless, it is still reasonable to believe that as these network get more traction, fees will increase (even if they stay below the dollar at all times). Big organisations might not want to pay 50 cents everytime they emit a proposal but rather 1 cent.

3. Anyone!

I can't predict the future. Web3 has proven to evolve so quickly, one year in Blockchain is at least 5 years in web2 years (blockchain years are the new dog years?). Time will tell who can use this app. It is also worth it to mention that maybe no one will use it and that it's not needed. We'll see :)

## Description of the ideal flow

For example's sake, let us take a dummy DAO as the User entity. The business need is to coordinate the signature of a proposal X. The number of signers is 50.

We are operating on Harmony, so consider an EVM environment. The signature scheme is EDDSA, as it offers many advantages for circom and the circuit complexity compared to ECDSA.

> Fret not! You might think that since we're operating on the EVM, we should choose ECDSA, as it is the "native" signature scheme of the Ethereum virtual machine. Let's think about it for a second, you only ever need a private key to sign on a specific message. Here, users have their Harmony private key, a 256-bits private key. This will allow them to sign using EDDSA! And since we're not verifying the signature on-chain using built-in Solidity functions, we don't have to worry about compatibility.

- Proposal X is emitted. This allows us to construct a payload object to sign. Just a JSON object describing uniquely this proposal.

```
{
    name: "Proposal X",
    date: "April 21rst 2022",
    block: 50212123,
    proposal: "20% of the treasury should be donated to a charity"
}

```

- Users can sign online and off-chain the proposal. These signatures are aggregated inside an array.

```
[signature1, signature2, ..., signature50]
```

- The payload object, the signatures along with the set of "whitelisted" public addresses (the members of the DAO, those authorised to vote) are sent to the zkSignature verifier circom circuit. The circuit verifies that the each signature is part of the list of accepted addresses. If all of the signatures are accepted (or a subset), then the circuit will output a valid proof of correct & truthful voting!

- The last step is therefore to send this newly created proof on-chain to be read by our smart contract! The smart contract will need the set of authorised public addresses as parameters for the `verify` function, as it is the public input of the circuit.