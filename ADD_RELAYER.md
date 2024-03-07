# Add relayer

### 1. Add config file

Go to github `pull` fork repo [cosmosia](https://github.com/notional-labs/cosmosia) ->> `Sync Fork`

`<relayerhub_name>_config.toml` to [folder](https://github.com/hqdNotional/cosmosia/tree/main/relaying)

Eg: `whitewhale_config.toml`

```
vim $HOME/cosmosia/relaying/<relayerhub_name>_config.toml
```

[sample_config](https://github.com/hqdNotional/cosmosia/blob/main/relaying/test_config.toml)

### 2. Update [relayerhubs_registry.ini](https://github.com/hqdNotional/cosmosia/blob/main/relaying/relayerhubs_registry.ini)

```
vim $HOME/cosmosia/relaying/relayerhubs_registry.ini
```

Add following:

```
[relayerhub_name]
hermes_version = "version"
```

Then `commit` ->> `push` ->> `contribute` ->> `pull request` ->> `merge`

### 3. SSH to manager node

Setup enviroment variable:

Eg: `whitewhale`

```
export RELAYERHUB_NAME=
```

```
export MNEMONIC=
```

### 4. Create config 

Get mnemonic:

* CLI:
  * Eg:
    * osmosis: `osmosisd keys add $KEYNAME --output json`
    * cosmos: `gaiad keys add $KEYNAME --output json`
    * ...
* Keplr: Just create new account

#### 1. Relayer

Direct:

```
docker create config cosmosia.relay.$RELAYERHUB_NAME.mnemonic.txt $MNEMONIC
```

From files:

```
docker create config cosmosia.relay.$RELAYERHUB_NAME.mnemonic.txt ./mnemonic.txt
```

#### 2. Relayer clear

Direct:

```
docker create config cosmosia.relay_clear.$RELAYERHUB_NAME.mnemonic.txt $MNEMONIC
```

From files:

```
docker create config cosmosia.relay_clear.$RELAYERHUB_NAME.mnemonic.txt ./mnemonic.txt
```

Or just create config at [config](https://admin.notional.ventures/configs)

### 5. Initialize relayer hubs

Pull new newest update:

```
cd $HOME/cosmosia/relaying
git reset --hard HEAD~1
git reset --hard HEAD~1
git reset --hard HEAD~1
git pull
```

Create relayer:

```
sh docker_service_create.sh $RELAYERHUB_NAME
```

Create relayer:

```
cd $HOME/cosmosia/relaying_clear
sh docker_service_create.sh $RELAYERHUB_NAME
```
