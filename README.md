# Foundry Fund Me tutorial

This is a section of the Cyfrin Solidity Course, reimagined from beggining to end by Luka Novakovic

*[⭐️ Updraft | Foundry Fund Me](https://updraft.cyfrin.io/courses/foundry/foundry-fund-me/fund-me-project-setup)*


## Requirements
-[git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z`


# Usage

## Deploy

```
forge script script/DeployFundMe.s.sol
```

## Quickstart

```
git clone https://github.com/novakovicluka97/foundry-fund-me
cd foundry-fund-me-f23
forge build
```

## Testing


```
forge test
```

or 

```
// Only run test functions matching the specified regex pattern.

"forge test -m testFunctionName" is deprecated. Please use 

forge test --match-test testFunctionName
```

or

```
forge test --fork-url $SEPOLIA_RPC_URL
```
