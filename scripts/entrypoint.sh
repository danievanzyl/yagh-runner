#!/bin/bash

REPO=$REPO
REG_TOKEN=$REG_TOKEN
NAME=$NAME
RUNNER_HOME=/home/docker/actions-runner
cd ${RUNNER_HOME} || exit
./config.sh --url https://github.com/${REPO} --token ${REG_TOKEN} --name ${NAME}

cleanup() {
  echo "Removing runner..."
  cd ${RUNNER_HOME} || exit
  ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh &
wait $!
