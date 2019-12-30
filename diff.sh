#!/bin/bash

varId2=`git log |grep commit |head -2|tail -1|awk -F " " '{print $2}'`
varId1=`git log |grep commit |head -1|awk -F " " '{print $2}'`
echo $varId2
echo $varId1
echo"`git diff $varId2 $varId1 test`"

if [ -z echo"`git diff $varId2 $varId1 test`" ]
then
	echo "hiiiiiiiii"
else
	echo "biiiiiiiiiiii"
fi
