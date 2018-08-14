#!/bin/bash

DEFAULT_THEIA_RUNTIME_PATH="/home/theia/"
THEIA_RUNTIME_PATH=${THEIA_RUNTIME_PATH:-${DEFAULT_THEIA_RUNTIME_PATH}}
DEFAULT_THEIA_DIR="/opt/app-root/src"
THEIA_DIR=${THEIA_DIR:-${DEFAULT_THEIA_DIR}}
DEFAULT_THEIA_YARN_OPT="--hostname 0.0.0.0 --log-level=debug --port=3000 --no-cluster --no-app-auto-install"
THEIA_YARN_OPT=${THEIA_YARN_OPT:-${DEFAULT_THEIA_YARN_OPT}}
DEFAULT_THEIA_YARN_CMD="yarn theia start ${THEIA_DIR} ${THEIA_YARN_OPT}"
THEIA_YARN_CMD=${THEIA_YARN_CMD:-${DEFAULT_THEIA_YARN_CMD}}
DEFAULT_GIT_REPO_URL=${OPENSHIFT_BUILD_SOURCE}
GIT_REPO_URL=${GIT_REPO_URL:-${DEFAULT_GIT_REPO_URL}}
DEFAULT_GIT_NAME=""
GIT_USERNAME=${GIT_USERNAME:-${DEFAULT_GIT_USERNAME}}
DEFAULT_GIT_EMAIL=""
GIT_EMAIL=${GIT_EMAIL:-${DEFAULT_GIT_EMAIL}}
DEFAULT_GIT_USERNAME=""
GIT_USERNAME=${GIT_USERNAME:-${DEFAULT_GIT_USERNAME}}
DEFAULT_GIT_PASSWORD=""
GIT_PASSWORD=${GIT_PASSWORD:-${DEFAULT_GIT_PASSWORD}}
DEFAULT_GIT_TOKEN=""
GIT_TOKEN=${GIT_TOKEN:-${DEFAULT_GIT_TOKEN}}

cd ${THEIA_DIR}
if [ ! -z "$GIT_USERNAME" ] ; then
  git config --global user.name $GIT_USERNAME
fi
if [ ! -z "$GIT_EMAIL" ] ; then
  git config --global user.email $GIT_EMAIL
fi
if [ ! -z "$GIT_PASSWORD" ] ; then
  git config --global user.password $GIT_PASSWORD
  if [ ! -z "$GIT_USERNAME" ] ; then
    export GIT_REPO_URL=$(echo ${GIT_REPO_URL} | sed -e "s#https://#https://$GIT_USERNAME:$GIT_PASSWORD@#g")
    git config --global credential.helper store
    git config --global remote.origin.url ${GIT_REPO_URL}
  fi
fi
if [ ! -z "$GIT_TOKEN" ] ; then
  git config --global user.token $GIT_TOKEN
  if [ ! -z "$GIT_USERNAME" ] ; then
    export GIT_REPO_URL=$(echo ${GIT_REPO_URL} | sed -e "s#https://#https://$GIT_USERNAME:$GIT_TOKEN@#g")
    git config --global credential.helper store
    git config --global remote.origin.url ${GIT_REPO_URL}
  fi
fi



cd ${THEIA_RUNTIME_PATH}
${THEIA_YARN_CMD}
