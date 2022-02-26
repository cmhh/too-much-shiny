#! /usr/bin/env bash

kill -s SIGKILL $(cat services/rand_pid.txt)