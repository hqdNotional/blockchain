# ADD

```
export CHAIN=
```

```
cd
rm -rf cosmosia
git clone https://github.com/notional-labs/cosmosia
cd cosmosia
cat << EOF | sudo tee -a data/chain_registry.ini
[$CHAIN]
config = "https://raw.githubusercontent.com/notional-labs/cosmosia/main/data/$CHAIN.ini"
EOF
```

```
cat << EOF | sudo tee -a data/$CHAIN.ini
git_repo = "https://github.com/nolus-protocol/nolus-core"
version = "v0.5.3"
daemon_name = "nolusd"
node_home = "$HOME/.nolus"
minimum_gas_prices = "0unls"
start_flags = "--p2p.seeds=20e1000e88125698264454a884812746c2eb4807@seeds.lavenderfive.com:11956,ebc272824924ea1a27ea3183dd0b9ba713494f83@nolus-mainnet-seed.autostake.com:27016,8542cd7e6bf9d260fef543bc49e59be5a3fa9074@seed.publicnode.com:26656,400f3d9e30b69e78a7fb891f60d76fa3c73f0ecc@nolus.rpc.kjnodes.com:14359,cefe4a5394dc57f318547258c511a9a96aaeaa7b@seed-nolus.ibs.team:16665"
snapshot_prune = "cosmos-pruner"
network = "net5"
db_backend = "pebbledb"
EOF
```

```
vi data/$CHAIN.ini
```

Then `commit` ->> `push` ->> `contribute` ->> `pull request` ->> `merge`

### 3. Create snapshot
**SSH**

ssh to `server` that will runs `new chain` Eg: `cosmosia6` on `chain_registry.ini`

**Create folder**:
```
pacman -Syyu --noconfirm tmux
pacman -Sy --noconfirm tmux
tmux new -s upgrade
tmux attach -t upgrade
```

```
pacman -Sy --noconfirm sudo
```

```
export CHAIN=
```

Get `chain.json`, `genesis.json`:
* `genesis.json` from [cosmos/$NEW_CHAIN/chain.json](https://github.com/cosmos/chain-registr://github.com/cosmos/chain-registry)
* `chain.json` from [http://cosmosia26.notional.ventures:11111/cosmoshub/chain.json](http://cosmosia26.notional.ventures:11111/cosmoshub/chain.json)

**Edit file chain.json**

```
cd /mnt/data/snapshots
mkdir -p $CHAIN
cd $CHAIN

cat << EOF | sudo tee -a /mnt/data/snapshots/$CHAIN/chain.json
{
    "snapshot_url": "http://95.217.193.117:11111/$CHAIN/data_20230202_172234.tar.gz,
    "file_size": 0,
    "date_version": 0
}
EOF

touch data_20230202_172234.tar.gz
```

### 4. Upgrade proxy static

Install and start new tmux session:
```
pacman -Sy --noconfirm tmux
tmux new -s add
tmux attach -t add
```

Find it on `manager node`:

```
docker service ls | grep static
docker service ps proxy_static
```

**SSH**

ssh to `node` that running `proxy_static`
```
docker exec -it $(docker ps -a | grep proxy_static | awk '{print $1}') /bin/bash
```

**Edit nginx files**:
```
pacman -Sy --noconfirm tmux
tmux new -s add
tmux attach -t add
pacman -Sy --noconfirm vim
vim /usr/share/nginx/html/index.html /etc/nginx/redirect_snapshots.conf
```

**Reload nginx**:
```
nginx -s reload
```

### 5. Create new services ( snapshot, rpc, lb, apigw )
**CONFIG**
go to config page and add:
RPC:
```
cosmosia.rpc.$CHAIN
```
```
node_1 = "cosmosia3"
```

SNAPSHOT:
```
cosmosia.snapshot.$CHAIN
```
```
snapshot_node = "cosmosia33"
snapshot_storage_node = "cosmosia22"
```

**TMUX**
```
pacman -Sy --noconfirm tmux
tmux new -s add
tmux attach -t add
```

ssh to `manager node`:
```
export CHAIN=
```
```
cd $HOME/cosmosia/snapshot
git pull
sh docker_service_create.sh $CHAIN
```

Remove snapshot if there is wrong config:
```
docker service rm snapshot_$CHAIN
```

**SSH**

ssh to `node` that run `new snapshot`:
```
read -p "Enter service name [bitsong]:" service
docker exec -it $(docker ps -a | grep $service | grep -E "snapshot_$service\." | awk '{print $1}') /bin/bash
```

```
pacman -Syyu --noconfirm tmux
pacman -Sy --noconfirm tmux
tmux new -s upgrade
tmux attach -t upgrade
```

```
export CHAIN=
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

Convert `data` script:
```
supervisorctl stop chain
sh $HOME/env.sh
curl -Ls -o- https://raw.githubusercontent.com/notional-labs/cosmosia/main/snapshot/scripts/level2pebble_data.sh | bash -s -- $node_home/data
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
crond
```

**SSH**

ssh to `manager node`:
```
export CHAIN=
```

```
export NUMBER=
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

**Api_gateway**
```
cd $HOME/cosmosia/notionalapi/gateway
sh docker_service_create.sh $CHAIN
```

**Proxy_public**
```
cd $HOME/cosmosia/proxy/public
sh docker_service_create.sh
```

**Proxy_internal**
```
cd $HOME/cosmosia/proxy/internal
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
