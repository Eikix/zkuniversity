const CIRCUIT_MAX_INPUTS = 15
const { buildEddsa, buildBabyjub } = require('circomlibjs')
export async function computeWitness(privateKeys) {
  const inputJson = {
    signatureThreshold: Math.floor(CIRCUIT_MAX_INPUTS / 2).toString(),
    Ax: new Array(CIRCUIT_MAX_INPUTS),
    Ay: new Array(CIRCUIT_MAX_INPUTS),
    S: new Array(CIRCUIT_MAX_INPUTS),
    R8x: new Array(CIRCUIT_MAX_INPUTS),
    R8y: new Array(CIRCUIT_MAX_INPUTS),
    message: undefined,
    isEnabled: new Array(CIRCUIT_MAX_INPUTS),
  }
  const eddsa = await buildEddsa()
  const babyJub = await buildBabyjub()
  const { F } = babyJub

  const msg = F.e(1234)
  // Adding the message to the input.json file (inputJson object)
  inputJson.message = F.toObject(msg).toString()

  for (let i = 0; i < CIRCUIT_MAX_INPUTS; i++) {
    const pubKey = eddsa.prv2pub(privateKeys[i])
    // Adding the public key to the input object
    inputJson.Ax[i] = F.toObject(pubKey[0]).toString()
    inputJson.Ay[i] = F.toObject(pubKey[1]).toString()
    const signature = eddsa.signPoseidon(prvKey, msg)
    inputJson.S[i] = signature.S.toString()
    inputJson.R8x[i] = F.toObject(signature.R8[0]).toString()
    inputJson.R8y[i] = F.toObject(signature.R8[1]).toString()
    inputJson.isEnabled[i] = 1
    if (!eddsa.verifyPoseidon(msg, signature, pubKey)) {
      throw new Error(
        "Signature can't be verified by circomlibjs PoseidonVerify"
      )
    }
  }
}
