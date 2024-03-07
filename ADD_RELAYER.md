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
Direct:
```
docker create config cosmosia.relay.$RELAYERHUB_NAME.mnemonic.txt $MNEMONIC
```
From files:
```
docker create config cosmosia.relay.$RELAYERHUB_NAME.mnemonic.txt ./mnemonic.txt
```

### 5. Initialize relayer hubs
Pull new newest update:
```
cd $HOME/cosmosia/relayer
git reset --hard HEAD~1
git reset --hard HEAD~1
git reset --hard HEAD~1
git pull
```
Create relayerhubs:
```
sh docker_service_create.sh $RELAYERHUB_NAME
```
