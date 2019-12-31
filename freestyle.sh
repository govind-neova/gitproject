#!/bin/bash

varId2=`git log |grep commit |head -2|tail -1|awk -F " " '{print $2}'`
varId1=`git log |grep commit |head -1|awk -F " " '{print $2}'`
echo $varId2
echo $varId1
#echo"`git diff $varId2 $varId1 test`"

#varOutput=`git diff $varId2 $varId1 test |head -2|awk -F " " '{print $4}'`
varOutput="$(git diff b24a7ab224e665b 49ffc3f62c209 test |grep -o test|uniq)"
echo $varOutput

if [ $varOutput==" " ]
then
	echo "Thre is no change in the test file."
	exit 1
else
	varImage_name=`cat /var/lib/jenkins/workspace/github/test |grep -i tag|awk -F : '{print $2}'`
	varIp_address=`cat /var/lib/jenkins/workspace/github/test |grep -i ip-address|awk -F : '{print $2}'`
	scp -pr /var/lib/jenkins/workspace/github/test ec2-user@54.161.192.128:~/
	ssh ec2-user@$varIp_address "docker run `cat /var/lib/jenkins/workspace/github/test |grep -i tag|awk -F : '{print $2}'` &>/dev/null &"
fi
