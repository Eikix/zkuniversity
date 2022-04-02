# ZKDao: Zero-Knowledge University - Week 5

Welcome!!! Let's get into it.

## Question 1: Shielding the TX

### Question 1.1: You have been asked to present a mechanism that will allow a user to privately and securely bridge 100,000 UST tokens from Ethereum to Harmony.

Let's describe this mechanisms in terms of flow:

1. User deposits 100k UST tokens on the Ethereum blockchain onto a bridge smart contract.

2. WebApp allows the user to construct a zk-proof that will allow them to prove to anyone that they did in fact perform this deposit. I believe this this can be achieved through a state transition proof, just like validating a block on a zk-rollup, or stateless clients. Note that the challenges are that user experience must be really simple and efficient for user to compute their proof (also how to do trusted setup efficiently?).

3. User takes their proof and posts it on the destination blockchain to claim their bridged tokens.

4. Verifier contract checks that the user is telling the "truth". This amounts to the Verifier contract being a stateless client for the origin blockchain.

### Question 1.2:

I believe the main risks for the above mechanism is cross-chain double spending. Performing L1-to-L1 transfers, as one L1 may fork while the bridge request is taking place, thus essentially creating "double spending" of money.

The other risks such as tamper information or collusion (in case of guardian nodes) are abstracted away by zero-knowledge proofs.

Smart contract security is another big challenge and I don't have a strong solution except for decentralized mechanisms on the smart contract (no ownership or too much power concentrated: e.g. proxy rights, or ownable / pausable rights for EVM contracts). It will need to be audited and reviewed.

## Question 2: Aztec

### Question 2.1: Aztec Notes

Aztec notes are basically encrypted values, i.e. cypher messages. I'm guessing they can map to different things but they mostly have a token or asset counterpart. Which means you're essentially shielding from view your asset's details through an AZTEC note as you would with a ticket. And this ticket allows you to transact with the Aztec protocol: spend, view, etc. with the help of cryptographic keys (that only the owner of the assets has access to)

## Question 3: Webb

### Question 3.1:

Commitments to Anchor have ChainID, nullifier and secret as poseidon hash, whereas VAnchor have ChainID, amount, nullifier and so-called "blinding" (which is the secret from Anchor commitment). I'm not sure how to propose a new commitment scheme, maybe we could commit the tokenAddress (or tokenId) of the token we're depositing as well as the tokenId we want to withdraw from the protocol.

### Question 3.3: Describe how the UTXO scheme works on the VAnchor contract.

Firstly, here is a definition of UTXO from [Investopedia](https://www.investopedia.com/terms/u/utxo.asp):

> A UTXO is the amount of digital currency remaining after a cryptocurrency transaction is executed.

> UTXOs are processed continuously and are responsible for beginning and ending each transaction.

> When a transaction is completed, any unspent outputs are deposited back into a database as inputs which can be used at a later date for a new transaction.

So I'm guessing UTXO works in the following way for VAnchor: any unspent amount of your transfer (output) is immediately available (input).

## Question 4: Thinkign in ZK

Hey Aztec people! I'd like to ask you how you handle the risk of forking (when bridging from Ethereum to any L1)? Must you still await 5 to 6mins for finality? Thanks a lot.

## Question 5: Final project
