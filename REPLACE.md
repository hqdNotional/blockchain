# Replace
Eg: [ `persistent` ->> `persistence` ]

* `$OLD_SERVICE` = `persistent`
* `$NEW_SERVICE` = `persistence`

### 1. Find containers and nodes
Find `containers` inside `service`:
```
docker service ps | grep $OLD_SERVICE
```

Find `nodes` that running `containers`:
* `$OLD_SERVICE_NAME` include ( `rpc`, `snapshot`, `lb`, `apigw` )
```
docker service ps $OLD_SERVICE_NAME
```
### 2. Run bash ( rpc & snapshot )
Login to [notional-admin-page](https://admin.notional.ventures)
* `configs`
  * replace `rpc` ( create new one with same configs and delete old one )
  * replace `snapshot` ( create new one with same configs and delete old one )

### 3. Update proxy
Ssh to `manager node` and find `service`:
```
docker service ps proxy_static
```
Ssh to that node:

Edit nginx config file, replace `old name` with `new name`:
```
pacman -Sy --noconfirm vim
vim /usr/share/nginx/html/index.html /etc/nginx/redirect_snapshots.conf
```

Reload `nginx` inside `container`
```
nginx -s reload
```

### 4. Update service ( snapshot, rpc, lb, apigw )
Ssh to `manager node` and find `service`:
```
docker service ls |grep $OLD_SERVICE
```

**Create new snapshot ( & remove old snapshot ) and rpc ( create new only )**:
```
docker service rm snapshot_$OLD_SERVICE
```

```
cd $HOME/cosmosia
git pull
cd $HOME/cosmosia/snapshot
sh docker_service_create.sh $NEW_SERVICE
cd $HOME/cosmosia/rpc
sh docker_service_create.sh $NEW_SERVICE
```

**Wait**:
`Wait` until it `synced` on [notional-admin-rpcs](https://admin.notional.ventures/rpcs)

It could take more than `30m` to change to `synced` state

If you want to view log:

Ssh to `manager node` and find `service`:
```
docker logs -n10 $NEW_RPC_CONTAINER
```

**Remove old rpc**:
```
docker service rm rpc_$OLD_SERVICE_*
```

**Loadbalancer**:

`$XXXX` is semver , Eg: `v23.0.0`
```
docker service rm lb_$OLD_SERVICE
cd $HOME/cosmosia/load_balancer
sh docker_service_create.sh $NEW_SERVICE_$XXXX
```

**Api Gateway**:
```
docker service rm napigw_$OLD_SERVICE
cd $HOME/cosmosia/notionalapi/gateway
sh docker_service_create.sh $NEW_SERVICE
```

### 5. Update cosmosia/docs/rpc.md
Go to github `pull` fork repo [cosmosia](https://github.com/notional-labs/cosmosia) ->> `Sync Fork`

```
git pull
```

```
vi ~/cosmosia/docs/rpc.md
```

Replace:
* `$OLD_NAME` ->> `$NEW_NAME`
Eg:

From
```
### 33. Persistent

| Protocol | Endpoint                                               |
|----------|:-------------------------------------------------------|
| RPC      | https://rpc-persistent-ia.cosmosia.notional.ventures/  |
| API      | https://api-persistent-ia.cosmosia.notional.ventures/  |
| GRPC     | https://grpc-persistent-ia.cosmosia.notional.ventures/ |

```
to 
```
### 33. Persistence

| Protocol | Endpoint                                               |
|----------|:-------------------------------------------------------|
| RPC      | https://rpc-persistence-ia.cosmosia.notional.ventures/  |
| API      | https://api-persistence-ia.cosmosia.notional.ventures/  |
| GRPC     | https://grpc-persistence-ia.cosmosia.notional.ventures/ |

```

Then `commit` ->> `push` ->> `contribute` ->> `pull request` ->> `merge`
