#!/bin/bash


compare_status(){
	echo $(git status | sed -n 2p )
}



if [ "$1" = "compare_status" ]
then
	compare_status
else
	echo "Not available yet"
fi





