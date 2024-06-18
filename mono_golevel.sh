#!/bin/bash

VERSION=$1

supervisorctl stop chain
git reset --hard
git fetch --all --tags
git checkout $VERSION
make install
supervisorctl start chain
