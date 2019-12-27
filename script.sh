#!/bin/bash
echo "hello world"
cd /var/lib/jenkins/workspace/github
varImage_name=`cat /var/lib/jenkins/workspace/github/test |grep -i tag|awk -F : '{print $2}'`
varIp_address=`cat /var/lib/jenkins/workspace/github/test |grep -i ip-address|awk -F : '{print $2}'`
echo $varImage_name
scp -pr /var/lib/jenkins/workspace/github/test ec2-user@54.161.192.128:~/
ssh ec2-user@$varIp_address "docker run `cat /var/lib/jenkins/workspace/github/test |grep -i tag|awk -F : '{print $2}'` &>/dev/null &"
