# Replace

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
Chain:
```
export CHAIN=
```

New version:
```
export NEW_VERSION=
```

### 3. Run bash ( rpc & snapshot )
Login to [notional-admin-page](https://admin.notional.ventures)
* configs
  * replace rpc ( create new one with same configs and delete old one )
  * replace snapshot ( create new one with same configs and delete old one )

### 4. Update proxy
Ssh to `cosmosia1` and find `service`:
```
docker service ps proxy_static
```

Ssh to that node:
Replace the `old name` with `new name`:
```
pacman -Sy --noconfirm vim
vim /usr/share/nginx/html/index.html /etc/nginx/redirect_snapshots.conf
```

Reload `nginx` inside `container`
```
nginx -s reload
```

### 5. Update service ( snapshot, rpc, lb, apigw )
Ssh to `cosmosia1` and find `service`:
```
docker service ls |grep $OLD_SERVICE
```

Snapshot and rpc:
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

`Wait` until it `synced` on [notional-admin-rpcs](https://admin.notional.ventures/rpcs)

It could take more than `30m` to change to `green` state


If you want to view log:

Ssh to `cosmosia1` and find `service`:
```
docker logs -n10 $NEW_RPC_CONTAINER
```

```
docker service rm rpc_$OLD_SERVICE
```

Loadbalancer:

`$XXXX` is version, Eg: v23.0.0
```
docker service rm lb_$OLD_SERVICE
cd $HOME/cosmosia/load_balancer
sh docker_service_create.sh $NEW_SERVICE_$XXXX
```

Api Gateway:
```
docker service rm napigw_$OLD_SERVICE
cd $HOME/cosmosia/notionalapi/gateway
sh docker_service_create.sh $NEW_SERVICE_$XXXX
```

### 6. Update cosmosia/docs/rpc.md
Pull fork:

Replace `old` with `new`

Then `commit` > `push` > `pull` > `merge`
