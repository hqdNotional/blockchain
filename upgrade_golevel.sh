#!/bin/bash

# get new version as argument
new_version = $1

# check if env.sh exists
if [ -f $HOME/env.sh ]
then
  sh $HOME/env.sh
else
  echo "No env.sh found"
  exit
fi

# check if provide new version
if [ -z $new_version ]
then
  echo "Missing arguments"
  echo "Usage: ./upgrade_golevel.sh new_version"
  echo "Eg: ./upgrade_golevel.sh v2.0.0"
  exit
fi

# get repository name
repo_name=$(basename $git_repo |cut -d. -f1)

# change directory to repository name
cd $repo_name

# fetch latest commits
git reset --hard
git fetch --all --tag

# checkout to new version
git checkout $new_version

# stop chain
supervisorctl stop chain

# build new binary
make install

# start chain
supervisorctl start chain
