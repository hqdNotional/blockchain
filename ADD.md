# ADD
Eg: [ `mars` ]

* `$CHAIN` = `mars`

### 1. Update chain on notional-labs/cosmosia/data
Go to github `pull` fork repo [cosmosia](https://github.com/notional-labs/cosmosia) ->> `Sync Fork`
```
git pull
```
**Open on browser**
* `Its own github`. Eg: [mars](https://github.com/mars-protocol/hub)
* `cosmos/chain-registry/$CHAIN/chain.json`. Eg: [cosmos-mars](https://github.com/cosmos/chain-registry/blob/master/mars/chain.json)
* `Notional` cosmosia/data/chain_registry.ini Eg: [chain-registry](https://github.com/notional-labs/cosmosia/blob/main/data/chain_registry.ini)
```
export CHAIN=
```
**Add new config link**
```
vi ~/cosmosia/data/chain_registry.ini
```
content:
```
[$CHAIN]
config = "https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/$CHAIN.ini"
```

**Add new config file**
```
vi ~/cosmosia/data/$CHAIN.ini
```
* `git_repo` = `$REAL_NEW_CHAIN_REPO_GITHUB_LINK` ( **cosmos/$NEW_CHAIN/chain.json** )
* `version` = `$RECOMMENDED_VERSION` ( **cosmos/$NEW_CHAIN/chain.json** )
* `daemon_name` = `$DAEMON_NAME`( **cosmos/$NEW_CHAIN/chain.json** )
* `node_home` = `$NODE_HOME`( **cosmos/$NEW_CHAIN/chain.json** )
* `start_flag` = `$seeds` ( **cosmos/$NEW_CHAIN/chain.json** ) [ *format: --p2p.seeds=$seed@$location,@@* ]
* `snapshot_prune` = `cosmos-pruner`
* `network` = `cosmos-pruner`
* `db_backend` = `pebbledb` or `goleveldb`
* `build_script` = `link` [BuildScript](https://github.com/notional-labs/cosmosia/tree/main/data/custom_build_scripts)

`@@` mean `repeat`

Then `commit` ->> `push` ->> `contribute` ->> `pull request` ->> `merge`

### 3. Create snapshot
**SSH**

ssh to `server` that will runs `new chain` Eg: `cosmosia6` on `chain_registry.ini`

**Create folder**:
```
export CHAIN=
```
```
cd /mnt/data/snapshots
mkdir $CHAIN
cd $CHAIN
```

Get `chain.json`, `genesis.json`:
* `genesis.json` from [cosmos/$NEW_CHAIN/chain.json](https://github.com/cosmos/chain-registr://github.com/cosmos/chain-registry)
* `chain.json` from [http://cosmosia26.notional.ventures:11111/cosmoshub/chain.json](http://cosmosia26.notional.ventures:11111/cosmoshub/chain.json)

**Download files**:
```
export GENESISJSON=
```
```
wget $GENESISJSON
wget http://cosmosia26.notional.ventures:11111/cosmoshub/chain.json
```

**Edit file chain.json**

* `CHAINJSON`:
  * `SERVER` [ from `chain_registry.ini` ]
  * `CHAIN` [ NEW NAME ( `new folder name` ) ]
  * `DATA_SIZE` = 0
  * `VERSION`  = 0

**Create fake snapshot**:

```
 touch data_20230202_172234.tar.gz
```

### 4. Upgrade proxy static

Install and start new tmux session:
```
pacman -Sy --noconfirm tmux
tmux new -s upgrade
tmux attach -t upgrade
```

Find it on `manager node`:

```
docker service ls | grep static
docker service ps proxy_static
```

**SSH**

ssh to `node` that running `proxy_static`
```
docker exec -it $(docker ps -a | grep $service | grep -E "proxy_static\\_" | awk '{print $1}') /bin/bash
```

**Edit nginx files**:
```
pacman -Sy --noconfirm vim
vim /usr/share/nginx/html/index.html /etc/nginx/redirect_snapshots.conf
```

**Reload nginx**:
```
nginx -s reload
```

### 5. Create new services ( snapshot, rpc, lb, apigw )
**SSH**

ssh to `manager node`:
```
export CHAIN=
```
```
cd $HOME/cosmosia/snapshot
git pull
sh docker_service_create_snapshot.sh $CHAIN
```

**SSH**

ssh to `node` that run `new chain`:
```
export CHAIN=
```
```
docker exec -it 
```
```
killall crond
cd $HOME/$CHAIN
rm -rf data/
```

Goto [mainnet-snapshot](https://www.polkachu.com/tendermint_snapshots) to download new snapshot:

**Peppledb**

Pull `peppledb`
```
git clone https://github.com/notional-labs/level2pebble $HOME/level2pepple
cd $HOME/level2pepple
make install
```

Download `peppeldb` script:
```
cd
wget https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/scripts/level2pebble_data.sh
sh level2pebble_data.sh $HOME/.$CHAIN/data
```

**Start Chain**
```
supervisorctl start chain
```

Curl to check:
```
curl localhost:26657/status | jq
```

**Stop Chain**
```
supervisorctl stop chain
```

```
cd
sh snapshot_cronjob.sh
```

**Crond**
```
ps -aux
crond
exit
```

**SSH**

ssh to `manager node`:
```
export $CHAIN=
```

```
export $NUMBER=
```

**RPC**
```
cd $HOME/cosmosia/rpc
git pull
sh docker_service_create.sh $CHAIN
```

**Load_Balancer**
```
cd $HOME/cosmosia/load_balancer
sh docker_service_create.sh $CHAIN rpc_$CHAIN_$NUMBER
```

**Proxy_public**
```
cd $HOME/cosmosia/proxy_public
sh docker_service_create.sh
```

**Proxy_internal**
```
cd $HOME/cosmosia/proxy_internal
sh docker_service_create.sh
```

### 6. Add new at cosmosia/docs/rpc.md
Go to github `pull` fork repo [cosmosia](https://github.com/notional-labs/cosmosia) ->> `Sync Fork`
```
git pull
```

```
vi ~/cosmosia/docs/rpc.md
```

Add:
* `$NEW_NAME`

Eg:
```
### 56. Mars

| Protocol | Endpoint                                          |
|----------|:--------------------------------------------------|
| RPC      | https://rpc-mars-ia.cosmosia.notional.ventures/   |
| API      | https://api-mars-ia.cosmosia.notional.ventures/   |
| GRPC     | https://grpc-mars-ia.cosmosia.notional.ventures/  |
```

Then `commit` ->> `push` ->> `contribute` ->> `pull request` ->> `merge`
