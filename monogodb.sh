#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
N="\e[0m"

SUDO_ID=$(id -u)


LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOGS_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "script started exected at : $(date)"

if [ $SUDO_ID -ne 0 ] ; then
echo -e "$RED dont have access"
exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then 
        echo -e "$RED error:  $2 is failure"
        exit 1

    else 
        echo -e "$GREEN  $2 is success"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding repo file"

dnf install mongodb-org -y&>>$LOGS_FILE
VALIDATE $? "Installing mongoDB"

systemctl enable mongod &>>$LOGS_FILE
VALIDATE $? "Enable MOngoDB"

systemctl start mongod &>>$LOGS_FILE
VALIDATE $? "start mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections"

systemctl restart mongod
VALIDATE $? "restarted mongodb"

