# Upgrade version

### 1. Find containers and nodes
Find `nodes` that run `service`:

Eg: `osmosis`, `osmosis-testnet`, `osmosis-archived`, `osmosis-pruned`
```
read -p "Enter service name [bitsong]:" service
docker service ps $(docker service ls | grep $service | grep -E "rpc_$service\\_" | awk '{print $2}')
docker service ps $(docker service ls | grep $service | grep -E "snapshot_$service " | awk '{print $2}')
```

### 3. Run bash ( rpc & snapshot )

**Rpc**:
```
read -p "Enter service name [bitsong]:" service
docker exec -it $(docker ps -a | grep $service | grep -E "rpc_$service\\_" | awk '{print $1}') /bin/bash
```

New version:
```
read -p "Enter new version [v2.0.0]:" newversion
killall crond
cat ~/env.sh
```

Upgrade use script:
```
rm -rf $HOME/upgrading.*
cd
wget https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/scripts/upgrading.sh
sh ./upgrading.sh $newversion

```
Wait till synced.

Check status:
```
curl localhost:26657/status | jq
```

Check logs
```
tail -f -n100 /var/log/chain.err.log
```

Edit `env.sh` to new version:
```
crond
pacman -Sy --noconfirm vim
vim $HOME/env.sh
```

**Snapshot**:
```
read -p "Enter service name [bitsong]:" service
docker exec -it $(docker ps -a | grep $service | grep -E "snapshot_$service\." | awk '{print $1}') /bin/bash
```

New version:
```
read -p "Enter new version [v2.0.0]:" newversion
killall crond
cat ~/env.sh
```

Upgrade use script:
```
rm -rf $HOME/upgrading.*
cd
wget https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/scripts/upgrading.sh
sh ./upgrading.sh $newversion

```
Wait till synced.

Check status:
```
curl localhost:26657/status | jq
```

Check logs
```
tail -f -n100 /var/log/chain.err.log
```

Turn on crond and edit `env.sh` to new version:
```
crond
pacman -Sy --noconfirm vim
vim $HOME/env.sh
```
### 4. Update registry

Go to github `pull` fork repo [cosmosia](https://github.com/notional-labs/cosmosia) ->> `Sync Fork`

```
git pull
```
Chain:
```
export CHAIN=
```
```
vi ~/cosmosia/data/$CHAIN.ini
```

Update:
* `version`

Then `commit` ->> `push` ->> `contribute` ->> `pull request` ->> `merge`
