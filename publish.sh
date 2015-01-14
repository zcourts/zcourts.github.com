#!/bin/sh
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
NC='\033[0m' # No Color
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd ) # current directory
DIR_NAME=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) #'random' directory name
TMP_DIR=${1:-"/tmp/${DIR_NAME}"}
#get the last commit message to use for the docs commit
commit_message=$(git log -1 HEAD --pretty=format:%s)
echo "${green}Attempting to publish${NC}"

if git diff-index --quiet HEAD --; then
  echo "${green}Creating ${TMP_DIR}${NC}"
  mkdir ${TMP_DIR} && git clone git@github.com:zcourts/zcourts.github.com.git ${TMP_DIR}

  cd ${TMP_DIR}
  echo "${green}Checking out master branch${NC}"
  git checkout master
  echo "${green}Generating site into ${TMP_DIR}${NC}"
  jekyll build  --source ${DIR} --destination ${TMP_DIR}
  git add :/ && git commit -m "${commit_message}"
  git push origin master
  cd ${DIR} && rm -rf ${TMP_DIR}
else
  echo "${red}You must commit before publishing${NC}"
fi