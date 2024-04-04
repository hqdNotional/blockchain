#!/bin/bash

git reset --hard
git fetch --all --tags
git checkout $VERSION
go mod edit -replace github.com/tendermint/tm-db=github.com/notional-labs/tm-db@pebble
go mod edit -replace github.com/cometbft/cometbft-db=github.com/notional-labs/cometbft-db@pebble
go work use

