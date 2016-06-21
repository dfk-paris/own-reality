#!/bin/bash -e

export HOST="app@192.168.30.213"
export PORT="22"
export DEPLOY_TO="/var/storage/host/own_reality"
export COMMIT="master"
export KEEP=5

function gateway {
  export HOST="app@127.0.0.1"
  export PORT="8022"
}

$1
