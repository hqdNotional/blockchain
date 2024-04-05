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

###### 1. Set up keys
* **Contract Deployer**: Funded on `all the chains` on which we need to `deploy contracts`.
* **Validator Accounts**: A `small amount` so validators can `announce the location` of `their signatures` onchain with a one-time transaction
* **Relayer Accounts**: The relayer must have a `balance on all chains` it's `relaying between`.

###### 2. Validator

Note: Your `deployer key` must be a `hexadecimal key`, while `validator` and `relayer` keys can be `hexadecimal` or `AWS KMS`.

Next, determine `what custom chain` configs you will need for your local and remote chains. Any chains that are `already included` in the `Hyperlane SDK` won't need a `chain config` (but can `optionally` have one if you want to `override` default settings). Run the following to see the default SDK chains:
```
hyperlane chains list
```

You can `press space` to `select your chains`. For `any chains` that need `custom configs`, you can define them `manually` using `JSON or YAML`, or create them with the following `command`:
```
hyperlane config create chain
```

You can `press space` to `select your chains`. For `any chains` that need `custom configs`, you can define them `manually` using `JSON or YAML`, or create them with the following `command`:
```
hyperlane config create chain
```

To create a multisig ISM configs, you can define it `manually` using `JSON or YAML`, or create it with the following `command`:
```
hyperlane config create ism
```

We're now ready to use the `deploy core` command to deploy the `Hyperlane contracts`. To pay for transactions, the command will need the contract deployer key from step 1, which can be provided via the `HYP_KEY` env variable or as a command `argument`.
```
hyperlane deploy core \
    --targets chain1,chain2,... \ # all the chains you want to bridge between
    --chains $CHAIN_CONFIG_FILE \  # path to chains.yaml config e.g. ./configs/chains.yaml
    --ism $MULTISIG_CONFIG_FILE \ # path to ism.yaml config e.g. ./configs/ism.yaml
    --artifacts $PREDEPLOYED_ARTIFACT_FILE \ # (optional) in case you want to reuse contracts you've already predeployed
    --out $OUT_DIR \ # (optional) deployment contract artifacts
    --key $YOUR_DEPLOYER_PRIVATE_KEY
```

Deployment contract `artifacts` will be `written` to to the `artifacts/ folder` by default. The deployer will create `two timestamped files`, `agent-config-{timestamp}.json` and `core-deployment-{timestamp}.json` The core-deployment file contains the `addresses of core contracts`, organized by chain. The agent-config file contains the `data needed` to run Hyperlane agents for the `next step`.

###### 3. Validator
Running a Validator `requires` the following:
* **An RPC node**: Validators make simple view calls to read merkle roots from the Mailbox contract on the chain they are validating for.
* **A secure signing key**: 
  * Validators use this key to sign the Mailbox's latest merkle root. Securing this key is important. If it is compromised, attackers can attempt to falsify messages, causing the Validator to be slashed.
  * The Hyperlane Validator agent currently supports signing with AWS KMS keys that are accessed via API keys/secrets as well as hexadecimal plaintext keys for testing. See more under agent keys
* **Publicly readable storage**: Validators write their `signatures` off-chain to `publicly accessible`, `highly available`, storage, so that they can be aggregated by the Relayer.
* **A machine to run on**: Validators can compile the `Rust binary` themselves or run a `Docker image` provided by `Abacus Works`. The binary can be run using your `favorite cloud service`. You can even run `multiple instances` of them in `different regions` for `high availability`, as Hyperlane has no notion of "`double signing`".

Configuration:
* `--db`: Path for `writing persistent data` to `disk`
* `--originChainName`: Name of the chain `being validated`. For example: `ethereum`
* `--chains.[originChainName].customRpcUrls`: Override the `default RPC URLs` used by the Validator for your origin chain.
* `--reorgPeriod`: Number of `block confirmations` the Validator needs to wait for before signing the Mailbox merkle root.

Local setup:
* `--validator.key`: Your Validator's `private key`, which is used to sign merkle roots.
* `--chains.${localChainName}.signer.key`: Your Validator's `private key`, which will be used to `submit a transaction` on chain that publicly announce your Validator's `checkpoint syncer`.
* `--checkpointSyncer.type`: Set to `localStorage`.
* `--checkpointSyncer.path`: The path to your `local directory` where Validator signatures will be written. This should be the value of `$MY_VALIDATOR_SIGNATURES_DIRECTORY` from the `local setup`. For example: `--checkpointSyncer.path='/tmp/hyperlane-validator-signatures-ethereum`.

AWS setup:
* `--validator.region`: The region of your `AWS KMS key`. For example: `us-east-1`
* `--validator.type`: aws
* `--validator.id`: The `alias` of your `Validator's AWS KMS key`, prefixed with `alias/`. For example: `alias/hyperlane-validator-signer-${originChainName}`.
* `--chains.${originChainName}.signer.type`: Set to the `aws` literal.
* `--chains.${originChainName}.signer.id`: The `alias` of your `Validator's AWS KMS key`, prefixed with `alias/`. For example: `alias/hyperlane-validator-signer-${originChainName}`
* `--checkpointSyncer.type`: Set to s3.
* `--checkpointSyncer.bucket`: The AWS S3 `bucket name`.
* `--checkpointSyncer.region`: The region of your AWS `S3 bucket`. For example: `us-east-1`.

Docker: 
```
docker run \
  -it \
  -e AWS_ACCESS_KEY_ID=ABCDEFGHIJKLMNOP \
  -e AWS_SECRET_ACCESS_KEY=xX-haha-nice-try-Xx \
  --mount ... \
  gcr.io/abacus-labs-dev/hyperlane-agent:3adc0e9-20240319-152359 \
  ./validator \
  --db /hyperlane_db \
  --originChainName <your_chain_name> \
  --reorgPeriod 1 \
  --validator.region us-east-1 \
  --checkpointSyncer.region us-east-1 \
  --validator.type aws \
  --chains.<your_chain_name>.signer.type aws \
  --validator.id alias/hyperlane-validator-signer-<your_chain_name> \
  --chains.<your_chain_name>.signer.id alias/hyperlane-validator-signer-<your_chain_name> \
  --checkpointSyncer.type s3 \
  --checkpointSyncer.bucket hyperlane-validator-signatures-<your_chain_name> \
```
