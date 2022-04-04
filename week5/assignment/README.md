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

I've decided to build the following project: a private inventory dApp for web3 MMOs.

### Overview

The point of this project is to provide an easy standard to extend from for web3 game developers. The insight is that right now, any MMO or RPG based on a blockchain that incorporates items for its players has to be settle for public inventory. All transactions are public on general purpose blockchains and ownership of items is also public.

If items in a game are ERC721 or equivalents on blockchains, then it's easy to reconstruct what every player possesses at any given moment. This defeats the feeling that players have the right and the freedom to reveal their most valuables treasures as well as hide them from others.

This is where private inventories come into play. There is a need for gamefi to offer privacy and fairness to players. This

#### How?

So far, my lead is that I'd like to extend the ERC721 standard to allow shielded ownership. This would work in the following way:

- The set of all items in a game is contained in a smart contract that resembles ERC721 standard.

- Each item (NFT) stores its owner's address in the form of a salted hash.

- Each owner knows an item is theirs because they know the pre-image of that hash. They know their address (public key) and they know the secret string that was used to salt their public key.

- At any milestone (crucial) moment in the life of the item - i.e. sell, transfer, destroy or just reveal that you own the item - players can choose to reveal their ownership and perform an action with a zero-knowledge proof. The verifier of the zero-knowledge proof checks that the player knows the pre-image of the hash stored on-chain: `POSEIDON(player_public_key, secret_string)`. The player now can prove that they own the item without actually revealing the secret.

- When players sell or transfer the item, they actually erase their hash from the ownership mapping and the item becomes available again. Either for some chosen player (transfer) or for a price (sell). The next person to possess the item will be responsible for chosing a secret string to hash their public key with and then store it on chain when they take ownership of the item.

- The smart contract will perform transfer of ownership per rounds (so as to shield identity of buyers and new owners). At each "tick" (for instance each day, or after there is 20 transfers), the smart contract will attribute the items to their new owner by storing their identity commitment.

### Use cases

Any MMORPG, RPG, strategy on-chain game with items might want to include this smart contract and UI in their set of smart contracts. This would greatly improve player experience as well as possibility for shenanigans!

This could also be extended for other use cases: private art NFTs, private and shielded property (medical insurance, real estate, etc.)

### Competing products

I believe the idea of secretly owned NFTs is not new. Mixers achieve this functionality pretty well already.

### Differentiating characteristics

I believe that the differentiating factor is that mixers are meant to shield money transfers whereas here, the ownership of a digital item is shielded, but can be revealed. The idea that a player can own an item and choose to reveal it or not frees so many possibilities!

Even on-chain board games can now be played through this system, as player can secretly own any type of asset (NFTs are just digital properties in the end), and then decide to reveal their proof of ownership.

Although this idea is neither new nor very advanced, good might come out of it as people will build on top of it or challenge me through iterative PRs or productive criticism.
