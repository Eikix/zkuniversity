const { buildEddsa } = require("circomlibjs");
const { BigNumber } = require("ethers");
const { arrayify } = require("ethers").utils;
const fs = require("fs");
const crypto = require("crypto");
const CIRCUIT_MAX_INPUTS = 15;

async function createInput() {
  const inputJson = {
    signatureThreshold: Math.floor(CIRCUIT_MAX_INPUTS / 2).toString(),
    Ax: new Array(CIRCUIT_MAX_INPUTS),
    Ay: new Array(CIRCUIT_MAX_INPUTS),
    S: new Array(CIRCUIT_MAX_INPUTS),
    R8x: new Array(CIRCUIT_MAX_INPUTS),
    R8y: new Array(CIRCUIT_MAX_INPUTS),
    message: undefined,
    isEnabled: new Array(CIRCUIT_MAX_INPUTS),
  };
  try {
    const eddsa = await buildEddsa();

    const msg =
      "56645627244818247611747275857905819486225339157975649303747177225593271309321";
    // Adding the message to the input.json file (inputJson object)
    inputJson.message = msg;

    for (let i = 0; i < CIRCUIT_MAX_INPUTS; i++) {
      const prvKey = crypto.randomBytes(32);
      const pubKey = eddsa.prv2pub(prvKey);

      // Adding the public key to the input object
      inputJson.Ax[i] = BigNumber.from(pubKey[0]).toString();
      inputJson.Ay[i] = BigNumber.from(pubKey[1]).toString();
      const message = arrayify(BigNumber.from(msg));
      const signature = eddsa.signPoseidon(prvKey, message);
      inputJson.S[i] = signature.S.toString();
      inputJson.R8x[i] = BigNumber.from(signature.R8[0]).toString();
      inputJson.R8y[i] = BigNumber.from(signature.R8[1]).toString();
      inputJson.isEnabled[i] = "1";
    }

    Object.values(inputJson).forEach((value) => {
      if (Array.isArray(value) && value.length < CIRCUIT_MAX_INPUTS) {
        throw new Error(
          "Your array elements inside the input don't have the correct length"
        );
      }
    });
    fs.writeFileSync("input.json", JSON.stringify(inputJson, null, 2));
    fs.writeFileSync("helpers/input.json", JSON.stringify(inputJson, null, 2));
  } catch (e) {
    console.error(e);
  }
}

function main() {
  try {
    createInput();
  } catch (err) {
    console.error(err);
  }
}

main();
