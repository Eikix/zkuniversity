import type { NextPage } from 'next'
import Head from 'next/head'
import SignaturesVerifier from '../components/SignaturesVerifier'

const Home: NextPage = () => {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center py-2">
      <Head>
        <title>zk Signature Verifier</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className="flex w-full flex-1 flex-col items-center justify-center gap-2 px-20 text-center">
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
        <SignaturesVerifier />
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
