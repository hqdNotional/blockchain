#!/bin/bash

VERSION=$1

# get new version as argument
new_version="$1"

# check if env.sh exists
if [ -f $HOME/env.sh ]
then
  source $HOME/env.sh
else
  echo "No env.sh found"
  exit
fi

# get repository name
repo_name=$(basename $git_repo |cut -d. -f1)

# change directory to repository name
cd $repo_name

supervisorctl stop chain
git reset --hard
git fetch --all --tags
git checkout $VERSION

# check if custom build script exists
if [[ -z $build_script ]]; then
  # build new binary
  make install
  sleep 5
else
  # build new binary with custom build script
  p_version=${build_version}
  source <(curl -Ls -o- "$build_script")
fi

supervisorctl start chain
