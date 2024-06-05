#!/bin/bash

black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
orange='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
gray='\033[0;37m'
gray2='\033[1;30m'
red2='\033[1;31m'
green2='\033[1;32m'
yellow='\033[1;33m'
blue2='\033[1;34m'
purple2='\033[1;35m'
cyan2='\033[1;36m'
white='\033[1;37m'
nc='\033[0m' # No Color

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

# check if provide new version
if [ -z $new_version ]
then
  echo "Missing arguments"
  echo "Usage: ./upgrade_golevel.sh new_version"
  echo "Eg: ./upgrade_golevel.sh v2.0.0"
  exit
fi

build_binary () {
  
# get function args
new_version="$1"

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
sleep 5

# build new binary
make install
sleep 5

# start chain
supervisorctl start chain
sleep 5

}

##################
# 1. stop chain & delete /var/log/hain.err.log
echo -e "${green}step 1:${nc} ${yellow}clean old logs${nc}"
supervisorctl stop chain
sleep 5;

echo "" > /var/log/chain.err.log

##################
# 2. build and run new binary
echo -e "${green}step 2:${nc} ${yellow}build & run old binary [${nc} ${red}$version${nc} ${yellow}]${nc}"
build_binary $version

##################
# 3. check for UPGRADE appear in logs
echo -e "${green}step 3:${nc} ${yellow}wait until see UPGRADE from logs${nc}"
# wait until see UPGRADE
tail -f /var/log/chain.err.log |sed '/UPGRADE\(.*\)NEEDED/ q'
wait
sleep 5;

##################
# 4. build and run new binary
echo -e "${green}step 4:${nc} ${yellow}build & run new binary [${nc} ${blue}$new_version${nc} ${yellow}]${nc}"
build_binary $new_version

##################
# 5. check for synch
echo -e "${green}step 5:${nc} ${yellow}synchronization checking${nc}"

catching_up="true"
while [[ "$catching_up" != "false" ]]; do
  sleep 60;
  catching_up=$(curl --silent --max-time 3 "http://localhost:26657/status" |jq -r .result.sync_info.catching_up)
  echo "catching_up=$catching_up"
done

##############
echo -e "${cyan}synched${nc}"
