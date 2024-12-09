#!/bin/bash

#  The script checks if the  logs/  directory exists and creates it if it doesn't. It then checks if the  coder  command is available and exits if it's not found. It also checks if the coder server is already running and exits if it is. 
#  If all checks pass, the script sets the environment variables and runs the coder server in the background. The output is redirected to  logs/coder.log . 
#  The script also prints the process ID of the coder server. 
#  Make the script executable: 
#  $ chmod +x bin/codersvc.sh
#
#  Run the script: 
#  $ bin/codersvc.sh

# check if logs/ directory exists
if [ ! -d logs ]; then
    mkdir logs
    touch logs/coder.log
fi

# check if coder command exists
if ! command -v coder &> /dev/null; then
    echo "Coder command not found. Please install Coder first."
    exit 1
fi

# check if coder server is already running
if pgrep -f coder-server &> /dev/null; then
    echo "Coder server is already running."
    exit 0
fi

# run coder server send output to logs/coder.log
export CODER_HTTP_ADDRESS="0.0.0.0:3001"
export CODER_ACCESS_URL="http://coder.ecs.lan"
export CODER_TLS_ENABLE="false"
export CODER_PROMETHEUS_ENABLE="true"

coder server >> logs/coder.log 2>&1 &

echo "Coder server is running at http://coder.ecs.lan"
echo "pid" $!
 

