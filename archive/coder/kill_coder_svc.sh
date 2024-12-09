#!/bin/bash

# check if coder server is running
if ! pgrep -f 'coder server' &> /dev/null; then
    echo "Coder server is not running."
    exit 0
fi

# get the process ID of the coder server
coder_pid=$(pgrep -f coder server)
sudo kill $coder_pid

# get the process ID of the postgres server
postgres_pid=$(pgrep -f postgres)
sudo kill $postgres_pid

echo "Coder server and PostgreSQL server stopped."
