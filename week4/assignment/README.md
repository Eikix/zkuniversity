# Week 4 - Assignment 4 

Welcome 😊😊! Good to see you again.

## Question 1: Scaling the future

### Question 1.1. 

| Solution / Characteristic | Need to join | Capital inefficient   | Reliant on trusted watcher/relayer                                                         | Relationship to the main chain      | Fast                                                 | Cheap                                                          |
|---------------------------|--------------|-----------------------|--------------------------------------------------------------------------------------------|-------------------------------------|------------------------------------------------------|----------------------------------------------------------------|
| Payment channels          | Yes          | Yes (locking amounts) | Yes                                                                                        | Settlement on main chain            | Yes                                                  | Very cheap (only transact on-chain 2 times: to enter and exit) |
| Sidechains                | No           | No                    | Not really (usually just a validator set)                                                  | Bridge from and to main chain       | Yes                                                  | Depends but mostly                                             |
| Plasma                    | Yes          | No                    | Yes, an operator to commit data as merkle root                                             | Commit merkle root                  | No, challenge periods are very long (7 days approx.) | Yes                                                            |
| Optimistic Rollups        | No           | No                    | Yes                                                                                        | Commit batching of state transition | Yes, very (if not fastest, but only for processing, not withdrawals)                           | Yes                                                            |
| ZK Rollups                | No           | No                    | No, only reliant on proper setup (correct trusted setup for SNARKs, transparent for STARK) | Commit zkproof of state transition  | Yes, very                                            | Yes                                                            |


It feels as though main problems for Plasma approach are: data availability (i.e. an operator withholding the merkle root to block people's freedom to move funds) and delay to withdraw.

Here's a small comparison table from [Preethi Kasireddy](https://www.preethikasireddy.com/post/a-normies-guide-to-rollups) to conclude this question.
<img src="./small_comparison.png">

### Question 1.2

