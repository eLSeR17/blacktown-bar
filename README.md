# Blacktown Bar

*This has been updated to work with Goerli over Rinkeby*

<div id="top"></div>

- [Blacktown Bar](#blacktown-bar)
  - [About](#about)
    - [How to DAO](#how-to-dao)
    - [No Code Tools](#no-code-tools)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
    - [Installation](#installation)
  - [Usage](#usage)
    - [On-Chain Governance Example](#on-chain-governance-example)
    - [Off-Chain governance Example](#off-chain-governance-example)
  - [Roadmap](#roadmap)
  - [Contributing](#contributing)
  - [License](#license)
  - [Contact](#contact)
  - [Acknowledgments](#acknowledgments)

[You can also see the python/brownie version of this here.](https://github.com/brownie-mix/dao-mix)

<!-- ABOUT THE PROJECT -->
## About

### Blacktown Bar

This repo represents a decentralized bar as a DAO in which all the transactions (buy drinks, play games, etc.) are registered in the blockchain. The bar uses its own ERC20 token to manage all the operations. As a DAO, proposals will be allowed.

| Feature    | On-Chain Governance | Hybrid Governance             |
| ---------- | ------------------- | ----------------------------- |
| Gas Costs  | More Expensive      | Cheaper                       |
| Components | Just the blockchain | An oracle or trusted multisig |

<!-- GETTING STARTED -->
# Getting Started 

Work with this repo in the browser (optional)<br/>

It's recommended that you've gone through the [hardhat getting started documentation](https://hardhat.org/getting-started/) before proceeding here. 

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [Nodejs](https://nodejs.org/en/)
  - You'll know you've installed nodejs right if you can run:
    - `node --version`and get an ouput like: `vx.x.x`
- [Yarn](https://classic.yarnpkg.com/lang/en/docs/install/) instead of `npm`
  - You'll know you've installed yarn right if you can run:
    - `yarn --version` And get an output like: `x.x.x`
    - You might need to install it with npm

### Installation

1. Clone this repo:
```
git clone https://github.com/eLSeR17/blacktown-bar
cd blacktown-bar
```
2. Install dependencies
```sh
yarn
```

or 

```
npm i 
```

3. Run the test suite (which also has all the functionality)

```
yarn hardhat test
```
or
```
npx hardhat test
```

If you want to deploy to a testnet:
4. Add a `.env` file with the same contents of `.env.example`, but replaced with your variables.
![WARNING](https://via.placeholder.com/15/f03c15/000000?text=+) **WARNING** ![WARNING](https://via.placeholder.com/15/f03c15/000000?text=+)
> DO NOT PUSH YOUR PRIVATE_KEY TO GITHUB


<!-- USAGE EXAMPLES -->
## Usage
### On-Chain Governance Example

Here is the rundown of what the test suite does. 

1. We will deploy the ERC20 token "BlacktownToken" which we will use to control the bar.
2. We will deploy a Timelock contract that we will use to give a buffer between executing proposals.
   1. Note: **The timelock is the contract that will handle all the money, ownerships, etc**
3. We will deploy our Governence contract 
   1. Note: **The Governance contract is in charge of proposals and such, but the Timelock executes!**
4. We will deploy the bar's main contract, which will be owned by our governance process! (aka, our timelock contract).
5. We will propose a price to be changed in our bar contract.
6. We will then vote on that proposal.
7. We will then queue the proposal to be executed.
8. Then, we will execute it!


Additionally, you can do it all manually on your own local network like so:

1. Setup local blockchain 
```
yarn hardhat node
```

2. Propose a new value to be added to our Box contract

In a second terminal (leave your blockchain running)
```
yarn hardhat run scripts/propose.ts --network localhost
```

3. Vote on that proposal

```
yarn hardhat run scripts/vote.ts --network localhost
```

4. Queue & Execute proposal!

```
yarn hardhat run scripts/queue-and-execute.ts --network localhost
```


You can also use the [Openzeppelin contract wizard](https://wizard.openzeppelin.com/#governor) to get other contracts to work with variations of this governance contract. 

### Off-Chain governance Example

> This sectoin is still being developed. 

Deploy your ERC20 and [make proposals in snapshot](https://docs.snapshot.org/proposals/create). 

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [] Add Upgradeability examples with the UUPS proxy pattern
- [] Add Chainlink Oracle Integration with Snapsafe example

See the [open issues](https://github.com/PatrickAlphaC/dao-template/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Hardhat - [@HardhatHQ](https://twitter.com/HardhatHQ)
Sergio López - [@sergiolopez1771](https://twitter.com/sergiolopez1771)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [Openzeppelin Governance Walkthrough](https://docs.openzeppelin.com/contracts/4.x/governance)
* [Openzeppelin Governance Github](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/governance)
* [Vitalik on DAOs](https://blog.ethereum.org/2014/05/06/daos-dacs-das-and-more-an-incomplete-terminology-guide/)
* [Vitalik on On-Chain Governance](https://vitalik.ca/general/2021/08/16/voting3.html)
* [Vitalik on Governance in General](https://vitalik.ca/general/2017/12/17/voting.html)

<p align="right">(<a href="#top">back to top</a>)</p>


You can check out the [openzeppelin javascript tests](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/e6f26b46fc8015f1b9b09bb85297464069302125/test/governance/extensions/GovernorTimelockControl.test) for a full suite of an example of what is possible. 
