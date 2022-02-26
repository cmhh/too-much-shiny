#! /usr/bin/env bash

nohup R -e "plumber::pr(file = 'services/rand.R') |> plumber::pr_run(port = 3002)" > services/rand.log 2>&1 &
RAND_PID=$!
echo $RAND_PID > services/rand_pid.txt
printf "\nrand sevice running on port 3002.  To stop it:\nkill -s SIGKILL ${RAND_PID}\n\n"