import { NextPage } from 'next'
import { useState } from 'react'
import { createInput } from '../utils/createInput'
import { privateKeys } from '../utils/privateKeys'
const { buildPoseidon } = require('circomlibjs')
import { exportCallDataGroth16 } from '../utils/zkProof/zkProof'

const RELATIVE_CIRCUIT_WASM_PATH = '/circuits/eddsasignaturesverifier.wasm'
const RELATIVE_ZKEY_PATH = '/circuits/eddsasignaturesverifier_0001.zkey'

const CIRCUIT_MAX_INPUTS = 15

interface Message {
  address: string
  nonce: string
  signatureThreshold: string
}

const INITIAL_MESSAGE: Message = {
  address: '0x9296bE4959E56b5DF2200DBfA30594504a7feD61',
  nonce: '1',
  signatureThreshold: Math.floor(CIRCUIT_MAX_INPUTS / 2).toString(),
}

const SignaturesVerifier: NextPage = () => {
  const [message, setMessage] = useState(INITIAL_MESSAGE)
  const [input, setInput] = useState<any[][] | null>(null)

  const handleMessageChange = (
    event: React.ChangeEvent<HTMLInputElement>,
    key: string
  ) => {
    const { value } = event.target
    setMessage((prevMessage) => ({
      ...prevMessage,
      [key]: value,
    }))
  }

  const onSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault()
    const messageHash = await signPoseidonMessage(message)
    console.log(messageHash)
    const input = await createInput(privateKeys, messageHash)
    console.log(input)
    await callSmartContract(input)
    return input
  }

  const signPoseidonMessage = async (message: Message) => {
    const poseidon = await buildPoseidon()
    const messageHash = poseidon(Object.values(message))
    return messageHash
  }

  const prepareSmartContractCall = async (input: any) => {
    const [a, b, c, Input] = await exportCallDataGroth16(
      input,
      RELATIVE_CIRCUIT_WASM_PATH,
      RELATIVE_ZKEY_PATH
    )
    setInput([a, b, c, Input])
    return [a, b, c, Input]
  }

  const callSmartContract = async (input: any) => {
    // for now this is fake, just a proof verifier in browser.
    // can be verified in remix
    const call = await prepareSmartContractCall(input)
    console.log(JSON.stringify(call))
    navigator.clipboard.writeText(JSON.stringify(call))
  }

  return (
    <div className="flex flex-col rounded-lg bg-slate-50 p-4">
      <form className="flex flex-col items-start  gap-4" onSubmit={onSubmit}>
        <div className="flex w-full flex-col items-center gap-6 lg:flex-row lg:justify-between">
          <label htmlFor="address">Enter an EVM-compatible address:</label>
          <input
            className="rounded-lg bg-blue-900 px-4 py-2 text-slate-50"
            type="text"
            name="address"
            id="address"
            required
            value={message.address}
            onChange={(event) => handleMessageChange(event, 'address')}
          />
        </div>
        <div className="flex w-full flex-col items-center gap-6 lg:flex-row lg:justify-between">
          <label htmlFor="nonce">Enter an unused nonce:</label>
          <input
            className="rounded-lg bg-blue-900 px-4 py-2 text-slate-50"
            type="text"
            name="nonce"
            id="nonce"
            disabled
            value={message.nonce}
            onChange={(event) => handleMessageChange(event, 'nonce')}
          />
        </div>
        <div className="flex w-full flex-col items-center gap-6 lg:flex-row lg:justify-between">
          <label htmlFor="signatureThreshold">
            Enter an signature threshold:
          </label>
          <input
            className="rounded-lg bg-blue-900 px-4 py-2 text-slate-50"
            type="text"
            name="signatureThreshold"
            id="signatureThreshold"
            disabled
            value={message.signatureThreshold}
            onChange={(event) =>
              handleMessageChange(event, 'signatureThreshold')
            }
          />
        </div>
        <button
          className="self-center rounded-lg bg-blue-900 px-4 py-2 text-slate-100"
          type="submit"
        >
          Sign
        </button>
      </form>
    </div>
  )
}
export default SignaturesVerifier
