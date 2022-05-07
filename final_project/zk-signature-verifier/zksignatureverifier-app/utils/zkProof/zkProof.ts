/**
 * Special thanks to @vplasencia at https://github.com/vplasencia for this helper bit of code.
 * This file is originally based on https://github.com/vplasencia/zkGames/blob/703be67f65a0764570debd4f5b383dc254e76e7d/zkgames-ui/zkproof/snarkjsZkproof.js
 */

const { groth16 } = require('snarkjs')

function unstringifyBigInts(o: any): any {
  if (typeof o == 'string' && /^[0-9]+$/.test(o)) {
    return BigInt(o)
  } else if (typeof o == 'string' && /^0x[0-9a-fA-F]+$/.test(o)) {
    return BigInt(o)
  } else if (Array.isArray(o)) {
    return o.map(unstringifyBigInts)
  } else if (typeof o == 'object') {
    if (o === null) return null
    const res = {}
    const keys = Object.keys(o)
    keys.forEach((k) => {
      //@ts-ignore
      res[k] = unstringifyBigInts(o[k])
    })
    return res
  } else {
    return o
  }
}

export async function exportCallDataGroth16(
  input: any,
  wasmPath: string,
  zkeyPath: string
) {
  const { proof, publicSignals } = await groth16.fullProve(
    input,
    wasmPath,
    zkeyPath
  )

  const editedPublicSignals = unstringifyBigInts(publicSignals)
  const editedProof = unstringifyBigInts(proof)
  const calldata = await groth16.exportSolidityCallData(
    editedProof,
    editedPublicSignals
  )

  const argv = calldata
    .replace(/["[\]\s]/g, '')
    .split(',')
    .map((x: any) => BigInt(x).toString())

  const a = [argv[0], argv[1]]
  const b = [
    [argv[2], argv[3]],
    [argv[4], argv[5]],
  ]
  const c = [argv[6], argv[7]]
  const Input = []

  for (let i = 8; i < argv.length; i++) {
    Input.push(argv[i])
  }

  return [a, b, c, Input]
}
