#!/bin/bash

new_version = $1

if [ -f $HOME/env.sh ]
then
  sh $HOME/env.sh
else
  echo "No env.sh found"
  exit
fi

if [ -z $new_version ]
then
  echo "Missing arguments"
  echo "Usage: ./upgrade_golevel.sh new_version"
  echo "Eg: ./upgrade_golevel.sh v2.0.0"
  exit
fi

cd $node_repo

git reset --hard
git fetch --all --tag

git checkout $new_version

supervisorctl stop chain

make install

supervisorctl start chain
