SG_ID=sg-018bba7f155ed1384
AMI=ami-0b4f379183e5706b9
INSTANCES=("mongo" "web" "catalogue" "redis" "user" "cart" "mysql" "shipping" "rabbitmq" "payment") # "redis" "user" "cart" "mysql" "shipping" "rabbitmq" "payment"
for i in ${INSTANCES[@]}
do
if [ $i == "mongo" ] || [ $i == "mysql" ] || [ $i == "rabbitmq" ]
then 
    INSTANCE_TYPE="t2.micro"
    else 
    INSTANCE_TYPE="t2.micro"
fi

# IPADDRESS=$(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query "Instances[0].PrivateIpAddress" --output text)

# echo "created $i instance: $IPADDRESS"



# Run the AWS CLI command and read the output into two variables
read PRIVATE_IP PUBLIC_IP <<< $(aws ec2 run-instances --image-id $AMI --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query "Instances[0].[PrivateIpAddress, PublicIpAddress]" --output text)

# Echo the private and public IP addresses
echo "Created $i instance:$PRIVATE_IP $PUBLIC_IP"

done