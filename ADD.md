# ADD

### 1. Configure environment variable
Chain:
```
export CHAIN=
```

New version:
```
export VERSION=
```

### 2. Find new chain github
* Its own github
* cosmos/$NEW_CHAIN/chain.json
* Notional cosmosia/data/chain_registry.ini

Update `notional chain_registry.ini`
* git_repo= $REAL_NEW_CHAIN_REPO_GITHUB_LINK ( cosmos/$NEW_CHAIN/chain.json )
* version= $RECOMMENDED_VERSION ( cosmos/$NEW_CHAIN/chain.json )
* daemon_name= $DAEMON_NAME( cosmos/$NEW_CHAIN/chain.json )
* node_home= $NODE_HOME( cosmos/$NEW_CHAIN/chain.json )
* start_flag= $seeds ( cosmos/$NEW_CHAIN/chain.json ) [ format: --p2p.$seed@$location,@@@ ]

### 3. Create snapshot
ssh to `server` that will runs `new chain` Eg: `cosmosia6` on `chain_registry.ini`
```
cd /mnt/data/snapshots
```

Eg: mars
```
mkdir $CHAIN
cd $CHAIN
```

Get `chain.json`, `genesis.json`:
* `genesis.json` from cosmos/$NEW_CHAIN/chain.json
* `chain.json` from `http://cosmosia26.notional.ventures:11111/cosmoshub/chain.json`

Download:
```
wget $GENESIS
wget http://cosmosia26.notional.ventures:11111/cosmoshub/chain.json
```

Edit:
* CHAINJSON:
  * SERVER [ from `chain_registry.ini` ]
  * CHAIN [ NEW NAME ( new folder name ) ]
  * DATA_SIZE = 0
  * VERSION  = 0

Create fake snapshot:
```
 touch data_20230202_172234.tar.gz
```

### 4. Upgrade proxy static
Find it on `manager node`:
```
docker service ls | grep static
docker service proxy_static
```

ssh to `node` that running `proxy_static`
```
docker exec -it 
```

Edit nginx files:
```
vim /usr/share/nginx/html/index.html /etc/nginx/redirect_snapshots.conf
```

reload nginx:
```
nginx -reload
```

### 5. Create new services ( snapshot, rpc, lb, apigw )
ssh to `manager node`:
```
cd $HOME/cosmosia/snapshot
git pull
sh docker_service_create_snapshot.sh $CHAIN
```

ssh to `node` that run `new chain`:
```
docker exec -it 
```
```
killall crond
cd $HOME/$CHAIN
rm -rf data/
```

Goto [mainnet-snapshot](https://www.polkachu.com/tendermint_snapshots) to download new snapshot:

Pull `peppledb`
```
git pull https://github.com/notional-labs/level2pebble $HOME/level2pepple
cd $HOME/level2pepple
make install
```

Download `peppeldb`:
```
cd
wget https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/scripts/level2pebble_data.sh
sh level2pebble_data.sh $HOME/.$CHAIN/data
```

Start chain:
```
supervisorctl start chain
```

Curl to check:
```
curl localhost:26657/status | jq

```

Stop chain:
```
supervisorctl stop chain
```

```
cd
sh snapshot_cronjob.sh
```

Crond:
```
ps -aux
crond
exit
```

ssh to `manager node`:

rpc:
```
cd $HOME/cosmosia/rpc
git pull
sh docker_service_create.sh $CHAIN
```

load_balancer:
```
cd $HOME/cosmosia/load_balancer
sh docker_service_create.sh $CHAIN rpc_$CHAIN_$NUMBER
```

:
proxy_public
```
cd $HOME/cosmosia/proxy_public
sh docker_service_create.sh 
```

proxy_internal:
```
cd $HOME/cosmosia/proxy_internall
sh docker_service_create.sh 
```
### 6. Update rpc docs
`cosmosia/docs/rpc.md`
Add new one:

