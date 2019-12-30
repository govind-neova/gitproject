#!/bin/bash

varId2=`git log |grep commit |head -2|tail -1|awk -F " " '{print $2}'`
varId1=`git log |grep commit |head -1|awk -F " " '{print $2}'`
echo $varId2
echo $varId1
varOutput=echo"`git diff $varId2 $varId1 test`"

if [ echo"`git diff $varId2 $varId1 test`" ]
then
	echo "hiiiiiiiii"
fi
