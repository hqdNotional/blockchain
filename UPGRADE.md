# Upgrade version

### 1. Find containers and nodes
Find `containers` inside `service`:
```
docker service ls | grep $SERVICE
```

Find `nodes` that running `containers`:
```
docker service ps $SERVICE_NAME
```

### 3. Run bash ( rpc & snapshot )

**Rpc**:
```
killall crond
```

New version:
```
export NEW_VERSION=
```

Check environment variable:
```
cat ~/env.sh
```
```
supervisorctl stop chain
cd
wget https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/scripts/upgrading.sh
sh ./upgrading.sh $NEW_VERSION

```
Wait till synced.

Start chain in another session

```
supervisorctl start chain
```

```
crond
```

Edit `env.sh` to new version:
```
pacman -Sy --noconfirm vim
vim $HOME/env.sh
```

**Snapshot**:
```
killall crond
```

New version:
```
export NEW_VERSION=
```
Check environment variable:
```
cat ~/env.sh
```

```
supervisorctl stop chain
cd
wget https://raw.githubusercontent.com/notional-labs/cosmosia/main/rpc/scripts/upgrading.sh
sh ./upgrading.sh $NEW_VERSION

```
Wait till synced.

Start chain in another session

```
supervisorctl start chain
```

```
crond
```

Edit `env.sh` to new version:
```
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
