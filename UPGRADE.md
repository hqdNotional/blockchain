# Upgrade version

### 1. Find containers and nodes
Find `containers` inside `service`:
```
docker service ps | grep $SERVICE
```

Find `nodes` that running `containers`:
```
docker service ps $SERVICE_NAME
```
### 2. Configure environment variable

New version:
```
export NEW_VERSION=
```

### 3. Run bash ( rpc & snapshot )

**Rpc**:

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
Start chain in another session

```
supervisorctl start chain
```

**Snapshot**:

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
Start chain in another session

```
supervisorctl start chain
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
