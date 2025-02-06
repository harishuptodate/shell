SG_ID=sg-018bba7f155ed1384
AMI=ami-0b4f379183e5706b9


aws ec2 run-instances --image-id $AMI --instance-type t2.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=web}]" 