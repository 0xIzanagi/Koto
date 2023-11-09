## Koto

## Introduction

Koto is a ERC20 contract with a built in bond mechanism similar to the original style Ohm bonds, without the inflation. It is intended to create a scenario in which there is a rising floor, without a capped ceiling on potential growth. Bonds and redemption of reserves also offer a way or users to buy and sell with no slippage and no taxes. 

---
### Tokenomics

**Total:** 10 million tokens <br>
**Team:** 2 million tokens <br>
**Bonds:** 1 million tokens <br>
**Initial Liquidity:** 7 million tokens <br>
**Taxes:** 5 / 5 (buy / sell)

---
### Koto Token Contract

**Address:** Available Upon Launch

**Functionality:** The core functionality resides in this custom built ERC20 token contract. 

- This contract handles selling and pricing bonds and redeemptions. All taxes collected get resold as bonds or burned. The decision of which to do it done automatically through the contract, dependent on which increases the reservers per token more. I.e if selling all of the bonds, which start at the current market price, does not increase the reserves more than burning them, then the tokens get burned and the process will continue on like this indefinitely with this decision being calculated at the beginning of each epoch (epochs are set at 1 day). However if selling is more valuable then they are sold and the reserves are kept in the contract and can be redeemed at any point in time by anyone in exchange for Koto tokens. The tokens are then burned forever. 
- While reserves primarily go up there is a case in which they can go down. The only instance for this is if additional liquidity is added to the pool. This matches Koto tokens held within the contract with ETH held in the contract and adds them to the liquidity pool. This is at the discretion of the team, but will not be done without consultation of the community prior. 

**Once liquidity is added it can not be removed.**