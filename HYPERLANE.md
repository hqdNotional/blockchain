# HYPERLANE

### 1. Hyperlane CLI
#### 1. Installation
Npm:
```
npm install -g @hyperlane-xyz/cli
```

Npx:
```
npx @hyperlane-xyz/cli
```

Yarn dlx:
```
yarn dlx @hyperlane-xyz/cli
```

Build from source:
```
git clone https://github.com/hyperlane-xyz/hyperlane-monorepo.git
cd hyperlane-monorepo
yarn install && yarn build
cd typescript/cli
yarn hyperlane
```

#### 2. Deploy warp
##### 1. Configuration
* Which `token`, on which `chain`, is this Warp Route being `created for`?
* **Optional**: Hyperlane connection details including `contract addresses` for the `mailbox`, `interchain gas`, and `interchain security modules`.
* **Optional**: The token standard - fungible tokens using `ERC20` or NFTs using `ERC721`. `Defaults to ERC20`.

##### 2. Create warp
```
hyperlane config create warp
```

##### 3. Base
* `chainName`: Set this equal to the chain on `which` your token exists
* type:
  * Set this to TokenType.collateral to create a basic Warp Route for an ERC20/ERC721 token.
  * Set this to TokenType.collateralVault to create a yield-bearing Warp Route for an ERC20 token that deposits into an ERC4626 vault.
  * Set this to TokenType.native to create a Warp Route for a native token (e.g. ether)
* address:
  * If using TokenType.collateral, the address of the ERC20/ERC721 contract for which to create a route
  * If using TokenType.collateralVault, the address of the ERC4626 vault to deposit collateral into
* isNft: If using TokenType.collateral for an ERC721 contract, set to true.

##### 4. List chain
```
hyperlane chains list
```

##### 5. Create chain configuration
```
hyperlane config create chain
```

##### 6. deploy
```
hyperlane deploy warp
```

##### 7. testing
```
hyperlane send transfer
```

#### 3. Getting start
##### 1. Terminology
* The "`local chain`" is your `new chain` that you want to `deploy Hyperlane onto`.
* A "`remote chain`" is a chain with an `existing Hyperlane deployment` that you want your `local chain` to `send & receive` messages `to & from`.

##### 2. Overview
* **Set up keys** that you will use to `deploy contracts` and `run validators` and `relayer`.
* **Deploy contracts** to the `local chain` and to `every remote chain` with which the `local chain` will be `able` to `send and receive messages`
* **Run validators and relayer** using `Kurtosis/AWS`. Validators provide the `signatures needed` for the `Interchain Security Modules` you deployed in step 2. The `relayer` will deliver messages `between chains` you deployed contracts
* **Send a test message** to confirm that your `relayer` is `able` to `deliver messages` to and from each pair of chains
* **Deploy a warp route** to send `token value`, `not just messages`, across chains
