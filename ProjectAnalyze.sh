#!/bin/bash

compare_status(){
	echo $(git status | sed -n 2p )
}

changes(){
	git diff > changes.log
	read -p "Changes saved. To view, enter y" Input2
	if [ "$Input2" = "y" ]
	then
		cat changes.log
	fi
}

todo(){
		grep -r --exclude=todo.log --exclude=ProjectAnalyze.sh "#TODO" . > "todo.log"
		read -p "To view todo.log, enter y" Input3
		if [ "$Input3" = "y" ]
		then 
			cat todo.log
		fi
}

echo "To check if local repo is up to date with remote repo, enter 1"
echo "To put all uncomiited changes in changes.log, enter 2"
echo "To put each line from every file of your project with the tag #TODO into a file todo.log, enter 3"
echo "To check all haskell files for syntax errors and put the results into error.log, enter 4"

read Input1

if [ "$Input1" = "1" ]
then
	compare_status
elif [ "$Input1" = "2" ]
then	
	changes
elif [ "$Input1" = "3" ]
then
	todo
fi
