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


dnf install nginx -y &>> $LOGFILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>> $LOGFILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>> $LOGFILE
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "removing old content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
VALIDATE $? "downloading web content"

cd /usr/share/nginx/html  &>> $LOGFILE
VALIDATE $? "changing directory"

unzip /tmp/web.zip &>> $LOGFILE
VALIDATE $? "unzipping web content"

cp /home/centos/shell/nginx.config /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
VALIDATE $? "copying nginx config"

systemctl restart nginx &>> $LOGFILE
VALIDATE $? "restarting nginx"