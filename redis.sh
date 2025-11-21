#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
N="\e[0m"
set -euo pipefail
trap 'echo "There is an error in $LINENO, command is $BASH_COMMAND'" ERR

SUDO_ID=$(id -u)
CURRENT_DIR=$(pwd)

LOGS_FOLDER="/var/log/new-shell-script-practice"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOGS_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "script started exected at : $(date)"

if [ $SUDO_ID -ne 0 ] ; then
echo -e "$RED dont have access"
exit 1
fi
