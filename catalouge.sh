#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
N="\e[0m"

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

VALIDATE(){
    if [ $1 -ne 0 ]; then 
        echo -e "$RED error:  $2 is failure"
        exit 1

    else 
        echo -e "$GREEN  $2 is success"
    fi
}

dnf module disable nodejs -y &>>LOGS_FILE
VALIDATE $? "Disabling NodeJs"

dnf module enable nodejs:20 -y &>>LOGS_FILE
VALIDATE $? "Enable nodejs"

dnf install nodejs -y &>>LOGS_FILE
VALIDATE $? "Installing Nodejs"

id roboshop &>>LOGS_FILE
if [ $? -ne 0 ]; then
   useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>LOGS_FILE
   VALIDATE $? "creating user"
else
   echo "user already existed...skipping"
fi


mkdir -p /app 
VALIDATE $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>LOGS_FILE
VALIDATE $? "downloading catalogue app"

cd /app 
VALIDATE $? "changing to app directory"

rm -rf /app/*
VALIDATE $? "removing existing code"

unzip /tmp/catalogue.zip
VALIDATE $? "unzip catalogue"

npm install  &>>LOGS_FILE
VALIDATE $? "Install dependencies"

cp $CURRENT_DIR/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "copy catalogue service"

systemctl daemon-reload
systemctl enable catalogue  &>>LOGS_FILE
VALIDATE $? "enable catalogue"

systemctl start catalogue
VALIDATE $? "Start catalogue"

cp $CURRENT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copy mongo repo"

dnf install mongodb-mongosh -y &>>LOGS_FILE
VALIDATE $? "isntall mongo Db client"

mongosh --host 172.31.19.248 </app/db/master-data.js
VALIDATE $? "load catalouge products"

systemctl restart catalogue
VALIDATE $? "restart catalouge"