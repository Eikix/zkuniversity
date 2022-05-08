interface Chain {
  chainId: number
  chainName: string
  isTestChain: boolean
  isLocalChain: boolean
  rpcUrl: string
}

export const HarmonyOneTestShards: Chain[] = [
  {
    chainId: 1666700000,
    chainName: 'Testnet Shard 0',
    isTestChain: true,
    isLocalChain: false,
    rpcUrl: 'https://api.s0.b.hmny.io',
  },
  {
    chainId: 1666700001,
    chainName: 'Testnet Shard 1',
    isTestChain: true,
    isLocalChain: false,
    rpcUrl: 'https://api.s1.b.hmny.io',
  },
  {
    chainId: 1666700002,
    chainName: 'Testnet Shard 2',
    isTestChain: true,
    isLocalChain: false,
    rpcUrl: 'https://api.s2.b.hmny.io',
  },
  {
    chainId: 1666700003,
    chainName: 'Testnet Shard 3',
    isTestChain: true,
    isLocalChain: false,
    rpcUrl: 'https://api.s3.b.hmny.io',
  },
]
export const HarmonyOneShards: Partial<Chain>[] = [
  {
    chainId: 1666600000,
    chainName: 'Shard 0',
    isTestChain: false,
    isLocalChain: false,
    rpcUrl: 'https://api.harmony.one',
  },
  {
    chainId: 1666600001,
    chainName: 'Shard 1',
    isTestChain: false,
    isLocalChain: false,
    rpcUrl: 'https://s1.api.s1.b.hmny.io',
  },
  {
    chainId: 1666600002,
    chainName: 'Shard 2',
    isTestChain: false,
    isLocalChain: false,
    rpcUrl: 'https://s2.api.s2.b.hmny.io',
  },
  {
    chainId: 1666600003,
    chainName: 'Shard 3',
    isTestChain: false,
    isLocalChain: false,
    rpcUrl: 'https://s3.api.s3.b.hmny.io',
  },
]
