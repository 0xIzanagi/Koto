## Bond Depository

### Contract Address

**Address:** 0x0e58bD5557C4e0a0Abf0e8d4df24177Ae714452D

### Functionality

The Bond Depository has a serveral function features that help regulate and promote the monetary policy set out on-chain for Koto Protocol. Its primary responsibility is to ensure that the bonds are being made available at the right times and in the right amounts. As more data becomes available these policies will be fine tuned in order to help maximize the usage of the tokens set aside for bonding. 

It also has secondary functionality of capturing or creating ample arbitrage opportunities. For example as tokens are bought and sold on the open market a percentage of the transactions flow to the depository. This is not any different from a typical tax token, with the exception of the fact that the tokens are then used for the betterment of the protocol not the direct inflation of developer wallets. These inflows of tokens can be used for a variety of purposes depending on particular market states.

- If the market price is greater than the bond price, these inflows can be sold on the open market and use the received eth to purchase bonds. Increasing both the backing and tokens reserves to use for later. 
- If the bond price is this usually calls for no action but can still be used in order to create a fly wheel effect, discussed in other sections of the documentation, where bonds are purchased resulting in Koto tokens being sent to the depository, where they can be redeemed or sold for eth, and this process can continue for quite some time depending on the gap between the bond and market / redeem price.
- If the redeem price is greater than the bond or market price, tokens can be bought and redeemed. Taking the eth gained to continue the process until ultimately the prices are equal again and the arbitrage opportunity is closed. 

But given the chaotic nature of early stage protocols the expectation is that these opportunities will be frequently present and even have the potential to persist for a good bit of time. 

Lastly the depository could also be used to help increase Koto Liquidity on decentralized exchanges. This would involve both the usage of the Koto and depository contract, and is expected to be an extremely rare occurance, if ever, but nonetheless it is still a potential functionality. 

### Code

The code for this contract can be found inside of this repository at `src/BondDepository.sol`