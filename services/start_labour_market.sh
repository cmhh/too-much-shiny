#! /usr/bin/env bash

nohup R -e "plumber::pr(file = 'services/labour_market.R') |> plumber::pr_run(port = 3001)" > services/rand.log 2>&1 &
LABMKT_PID=$!
echo $LABMKT_PID > services/labmkt_pid.txt
printf "\nlabour_market service running on port 3001.  To stop it:\n  kill -s SIGKILL ${LABMKT_PID}\n\n"