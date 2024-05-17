# Upgrade version

### 1. Find containers and nodes
Install and start new tmux session:
```
pacman -Sy --noconfirm tmux
tmux new -s upgrade
tmux attach -t upgrade
```

Find `nodes` that run `service`:

Eg: `osmosis`, `osmosis-testnet`, `osmosis-archived`, `osmosis-pruned`
```
read -p "Enter service name [bitsong]:" service
docker service ps $(docker service ls | grep $service | grep -E "rpc_$service\\_" | awk '{print $2}')
docker service ps $(docker service ls | grep $service | grep -E "snapshot_$service " | awk '{print $2}')
docker service ps $(docker service ls | grep $service | grep -E $service"-archive-sub" | awk '{print $2}')
```
___
### 2. Upgrade RPC
**Rpc**:
```
read -p "Enter service name [bitsong]:" service
docker exec -it $(docker ps -a | grep $service | grep -E "rpc_$service\\_" | awk '{print $1}') /bin/bash
```

Install and start new tmux session:
```
pacman -Sy --noconfirm tmux
tmux new -s upgrade
tmux attach -t upgrade
```

New version:
```
read -p "Enter new version [v2.0.0]:" newversion
killall crond
cat ~/env.sh
```

Upgrade use script:
```
curl -Ls -o- https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/scripts/update_config.sh | bash -s -- 1
curl -Ls -o- https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/scripts/upgrading.sh | bash -s -- $newversion
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

___
### 3. Upgrade Snapshot
**Snapshot**:
```
read -p "Enter service name [bitsong]:" service
docker exec -it $(docker ps -a | grep $service | grep -E "snapshot_$service\." | awk '{print $1}') /bin/bash
```

Install and start new tmux session:
```
pacman -Sy --noconfirm tmux
tmux new -s upgrade
tmux attach -t upgrade
```

New version:
```
read -p "Enter new version [v2.0.0]:" newversion
killall crond
cat ~/env.sh
```

Upgrade use script:
```
curl -Ls -o- https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/scripts/update_config.sh | bash -s -- 2
curl -Ls -o- https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/scripts/upgrading.sh | bash -s -- $newversion
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
___
### 4. Archive sub
**Archive sub**:
```
read -p "Enter service name [bitsong]:" service
docker exec -it $(docker ps -a | grep $service | grep -E $service"-archive-sub" | awk '{print $1}') /bin/bash
```

Install and start new tmux session:
```
pacman -Sy --noconfirm tmux
tmux new -s upgrade
tmux attach -t upgrade
```

Backup data:
```
cd
sh $HOME/env.sh
cp -R $node_home /root/backup
```

watch copy progress:
```
watch -n 1 du -sh $HOME/backup
```

```
read -p "Enter new version [v2.0.0]:" newversion
killall crond
cat ~/env.sh
```

Upgrade use script:
```
curl -Ls -o- https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/scripts/update_config.sh | bash -s -- 1
curl -Ls -o- https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/scripts/upgrading.sh | bash -s -- $newversion
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

Remove backup data:
```
rm -rf $HOME/backup
```

### 5. Update Registry

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
