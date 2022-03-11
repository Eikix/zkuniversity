## :rocket: :rocket: Welcome to Assignment no. 2, week 2 of zkUniversity, by Harmony One. I'm Elias, and this is my attempt at this challenge. :rocket: :rocket:

---

## Question 1: Privacy & ZK VMs

### Q1.1: Explain in brief, how does the existing blockchain state transition to a new state?

As explained in the [zCloak Network overview](https://zcloaknetwork.medium.com/zcloak-network-a-technical-overview-254e59a8d1c2), present blockchains grab inputs in the form of a transaction and depending on some pre-defined rules, change the general state. This process is replicated accross all distributed nodes by re-execution of the State Transtion Function (STF).
We get:
`STF(current_state, input_data) = new_state`

With verification over re-execution, you get the following advantages:

- Privacy: Users might not want to expose their input data y as part of the STF(x, y) computation. Some zkVM allow for enhanced user privacy. If I remember correctly though, in Polygon Hermez, the state as well as user inputs are public when performing zkRollups, therefore privacy is optional in this case. Someone creating a zkVM can choose to make these input data private or not.
  Note: I believe as of this moment (March 11th 2022) Polygon Hermez does not have a zkVM in mainnet, but in preparation.

- Scalability: re-execution is extremely computationally expensive for nodes accross a network. Verification would free up a lot of computation usage.

- Computation restriction: One could compute something extremely costly off-chain and submit on-chain the "proof of computation", i.e. a ZKP proving that the calculation is correct and genuine.

- Storage: If a node could boot up using the latest state of the network and a proof that this state results from the full history of the blockchain, then the community could circumvent the risk of excluding smaller nodes from the network.

---

### Q1.2: Explain in brief what is a ZK VM (virtual machine) and how it works?

The simplest definition I found is the following, from [Koh Wei Jie](https://medium.com/zeroknowledge/zero-knowledge-virtual-machines-the-polaris-license-and-vendor-lock-in-ab2c631cf139):

> A ZK VM is a circuit that executes bytecode. It allows a prover to show that, given a set of inputs, as well as some bytecode, they have correctly executed the program code on said inputs.

Here is a schema explaining zkVM, taken from [Bobbin Threadbare](https://ethresear.ch/t/a-sketch-for-a-stark-based-vm/7048).

<img src="https://miro.medium.com/max/1400/0*qDEAgBo2DVxebgnF">
