#! /usr/bin/env bash

kill -s SIGKILL $(cat services/labmkt_pid.txt)