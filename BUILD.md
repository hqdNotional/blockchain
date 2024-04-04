# BUILD

## Normalbuild
```
git reset --hard
git fetch --all --tag
git checkout
rm -rf $HOME/build.sh
wget https://raw.githubusercontent.com/hqdNotional/blockchain/main/build.sh
sh $HOME/build.sh
```

## Monobuild
```
rm -rf $HOME/monobuild.sh
wget https://raw.githubusercontent.com/hqdNotional/blockchain/main/monobuild.sh
sh $HOME/monobuild.sh $version
```

