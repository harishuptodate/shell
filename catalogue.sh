# !/bin/bash
ID=$(id -u)
TIMSTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMSTAMP.log"

if [ $ID -ne 0 ]
then
    echo "You should be a root user to execute this script"
    exit 1
    else
    echo "You are a root user"
fi
    echo "script started executing at $TIMSTAMP" &>> $LOGFILE
VALIDATE(){
    if [ $1 -ne 0 ]
    then
    echo -e "$2 ... FAILURE"  # -e means to enable the interpretation of backslash escapes, for example \n is a newline
    exit 1
    else
    echo "$2 ... SUCCESS"
    fi
}


#install nodejs
dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "disabling nodejs"

dnf module enable nodejs:18 -y &>> $LOGFILE

VALIDATE $? "enabling nodejs"

dnf install nodejs -y &>> $LOGFILE

VALIDATE $? "installing nodejs"

id "roboshop" &>/dev/null || useradd roboshop && echo "User 'roboshop' created successfully." &>> $LOGFILE

VALIDATE $? "creating user"

mkdir -p /app &>> $LOGFILE

VALIDATE $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE

VALIDATE $? "downloading catalogue"

cd /app &>> $LOGFILE

VALIDATE $? "moving to app directory"

unzip /tmp/catalogue.zip &>> $LOGFILE

VALIDATE $? "unzipping catalogue"

npm install &>> $LOGFILE

VALIDATE $? "installing dependencies"

cp /home/centos/shell/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE

VALIDATE $? "copying catalogue service"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "daemon-reload"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "enabling catalogue"

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "starting catalogue"

cp /home/centos/shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copying mongo repo"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "installing mongodb shell"

mongo --host 172.31.28.14 </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "loading catalogue data"

