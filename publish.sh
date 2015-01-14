#!/bin/sh
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
NC='\033[0m' # No Color
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # current directory
#DIR_NAME=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) #'random' directory name
#TMP_DIR=${1:-"/tmp/${DIR_NAME}"}
#get the last commit message to use for the docs commit
commit_message=$(git log -1 HEAD --pretty=format:%s)
echo "${green}Attempting to publish${NC}"

if git diff-index --quiet HEAD --; then
  echo "${green}Building site${NC}"
  jekyll build
  cd _site
  echo "${green}Initializing site dir as git repo${NC}"
  git init
  git remote add origin git@github.com:zcourts/zcourts.github.com.git
  echo "${green}Commiting new site changes${NC}"
  git add --all && git add :/ && git commit -m "${commit_message}"
  echo "${red}uploading/overwriting old site${NC}"
  git push -f origin master # -f, history doesn't matter for this branch
  echo "${green}Done...${NC}"
else
  echo "${red}You must commit before publishing${NC}"
fi