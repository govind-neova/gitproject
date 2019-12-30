#!/bin/bash
echo "hello world"
varImage_name=`cat test |grep -i tag|awk -F : '{print $2}'`
varIp_address=`cat test |grep -i ip-address|awk -F : '{print $2}'`
echo $varImage_name
echo $varIp_address
#scp -pr test ec2-user@54.161.192.128:~/
#ssh ec2-user@$varIp_address "docker run `cat test |grep -i tag|awk -F : '{print $2}'` &>/dev/null &"
#ssh ec2-user@$varIp_address "docker run `cat test |grep -i tag|awk -F : '{print $2}'` &>/dev/null &"
