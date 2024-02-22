# ADD

### 2. Configure environment variable
Chain:
```
export CHAIN=
```

New version:
```
export VERSION=
```

### 3. Find new chain github
* Its own github
* cosmos/$NEW_CHAIN/chain.json
* Notional cosmosia/data/chain_registry.ini

Update `notional chain_registry.ini`
git_repo= $REAL_NEW_CHAIN_REPO_GITHUB_LINK ( cosmos/$NEW_CHAIN/chain.json )
version= $RECOMMENDED_VERSION ( cosmos/$NEW_CHAIN/chain.json )
daemon_name= $DAEMON_NAME( cosmos/$NEW_CHAIN/chain.json )
node_home= $NODE_HOME( cosmos/$NEW_CHAIN/chain.json )
start_flag= $seeds ( cosmos/$NEW_CHAIN/chain.json ) [ format: --p2p.$seed@$location,@@@ ]
