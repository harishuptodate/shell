
# !/bin/bash
ID=$(id -u)
TIMSTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$timestamp.log"

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
}



cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copying mongo repo"

dnf install mongodb-org -y &>> $LOGFILE
VALIDATE $? "installing mongodb"

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "enabling mongod"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/g'  etc/mongod.conf &>> $LOGFILE
VALIDATE $? "changing localhost to remote, mongod config"

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "restarting mongod"