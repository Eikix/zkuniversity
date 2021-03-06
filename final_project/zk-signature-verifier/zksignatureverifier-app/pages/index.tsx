import type { NextPage } from 'next'
import Head from 'next/head'
import SignaturesVerifier from '../components/SignaturesVerifier'
import { useContractFunction, useEthers } from '@usedapp/core'
import { HarmonyOneTestShards } from '../utils/chains'
import { utils } from 'ethers'
import { Contract } from '@ethersproject/contracts'
import oneCharityAbi from '../public/contracts/OneCharity.json'

const oneCharityInterface = new utils.Interface(oneCharityAbi)
const oneCharityTestnetAddress = '0xcae24a4742B9357AAd0E3504272877F22FFE2AE2'
const contract = new Contract(oneCharityTestnetAddress, oneCharityInterface)

const Home: NextPage = () => {
  const { activateBrowserWallet, account, deactivate, switchNetwork, chainId } =
    useEthers()

  const { state, send } = useContractFunction(contract, 'fundNonProfit')

  const fundNonProfit = (
    address: string,
    a: string[],
    b: string[][],
    c: string[],
    input: string[]
  ) => {
    send(address, a, b, c, input)
  }

  const checkCorrectChainId = () => {
    if (chainId !== HarmonyOneTestShards[0].chainId) {
      switchNetwork(HarmonyOneTestShards[0].chainId)
    }
  }

  const callSmartContract = (input: any[]) => {
    fundNonProfit(input[0], input[1], input[2], input[3], input[4])
  }

  return (
    <div className="flex min-h-screen flex-col items-center justify-center py-2">
      <Head>
        <title>zk Signature Verifier</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className="my-8 flex w-full flex-1 flex-col items-center justify-start gap-2 px-20 text-center">
        {!account ? (
          <button
            className="self-end rounded-lg bg-blue-900 px-4 py-2 text-slate-50"
            onClick={() => {
              activateBrowserWallet()
              checkCorrectChainId()
            }}
          >
            Connect your wallet
          </button>
        ) : (
          <button
            className="self-end rounded-lg bg-blue-900 px-4 py-2 text-slate-50 hover:bg-red-900"
            onClick={() => deactivate()}
          >
            {account.substring(0, 5)}...{account.substring(35, 42)}
          </button>
        )}

        <div className="rounded-lg border bg-blue-50 p-6 text-gray-700">
          <details>
            <summary className="text-3xl font-bold text-blue-900">
              Welcome to zk-Signature Verifier
            </summary>
            <p className="mt-3 max-w-md text-2xl lg:max-w-xl">
              Get started by signing on a message. For this toy app, you own the
              15 private keys that control the DAO's funds!
            </p>
            <p className="mt-3 max-w-md text-2xl lg:max-w-xl">
              You'll be able to fund a dummy non-profit by signing off-chain on
              a specific message (containing an address, a signature threshold,
              and a nonce).
            </p>
          </details>
        </div>
        <SignaturesVerifier callSmartContract={callSmartContract} />
        <div>State of your call to the contract: {JSON.stringify(state)}</div>
      </main>

      <footer className="flex h-24 w-full flex-1 items-center justify-center gap-3 border-t">
        <p>Special thanks to:</p>
        <p>
          <a href="https://open.harmony.one/zkdao-succinct-private-fair">
            zkDAO{' '}
          </a>
          and{' '}
          <a href="https://twitter.com/icodeblockchain">sacrificialpancakes</a>{' '}
          at Vega Protocol for your help.
        </p>
      </footer>
    </div>
  )
}

export default Home
