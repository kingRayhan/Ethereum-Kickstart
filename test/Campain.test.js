const Web3 = require("web3");
const ganache = require("ganache-cli");
// const provider = new Web3.providers.HttpProvider("http://localhost:7545");
const provider = ganache.provider();
const web3 = new Web3(provider);
const compiler = require("simple-solc");
const { expect, it } = require("@jest/globals");

beforeEach(async () => {
  const accounts = await web3.eth.getAccounts();
  ownerId = accounts[0];
  players = accounts.slice(1);

  const { bytecode, abi } = await compiler(
    "Campain",
    "./contracts/Campain.sol"
  );

  contract = await new web3.eth.Contract(abi)
    .deploy({
      data: bytecode,
      arguments: [999999999],
    })
    .send({ from: ownerId, gas: "1000000" });
});

describe("Campain", () => {
  it("Should deploy Campain contact", async () => {
    expect(contract.options.address).toBeDefined();
  });
});
