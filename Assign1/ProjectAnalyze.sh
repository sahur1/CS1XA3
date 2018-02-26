#!/bin/bash

who_am_i(){
	echo "The time is: $(date)"
	echo -e "You are: $(whoami)\nIf not, you're a cheeky little bugger"
	echo "You're in: $(pwd)"
}

compare_status(){
	git fetch origin &> /dev/null
	echo $(git status | sed -n 2p )
	if [ "$(git status | sed -n 2p )" != "Your branch is up-to-date with 'origin/master'." ]
	then
		read -p "Would you like to update(Y/N): " Input
		if [ "$Input" == "y" ]
		then
			git pull
		fi
	fi
}


changes(){
	git diff > changes.log
	read -p "Changes saved. To view, enter y" Input2
	if [ "$Input2" == "y" ]
	then
		cat changes.log
	fi
}

todo(){
	grep -r --exclude={todo.log,ProjectAnalyze.sh} "#TODO" . > "todo.log"
	read -p "To view todo.log, enter y" Input3
	if [ "$Input3" == "y" ]
	then 
		cat todo.log
	fi
}

haskell_errors(){
	find . -name "*.hs" -type f -exec ghc -fno-code {} \; 2> error.log
	read -p "To view error.log, enter y" Input4
	if [ "$Input4" == "y" ]
	then
		cat error.log
	fi
}

diffs(){
	echo $(git diff origin/master master)
}

permissions(){
	for i in 0 1 2
	do
		if [ $i -eq 0 ]
		then
			echo "Permissions for owner"
		elif [ $i -eq 1 ]
		then
			echo "Permissions for group user"
		else
			echo "Permissions for eveyone"
		fi
   	for j in 0 1 2
		do
			if [ $j -eq 0 ]
			then	
				read -p "Readable?(Y/N)" Input7
				if [ "$Input7" = "y" ]
				then
					s=4
				else
					s=0
				fi
			elif [ $j -eq 1 ]
			then	
				read -p "Writable?(Y/N)" Input8
				if [ "$Input8" = "y" ]
				then
					w=2
				else
					w=0
				fi
			else	
				read -p "Executable?(Y/N)" Input9
				if [ "$Input9" = "y" ]
				then
					x=1
				else
					x=0
				fi
			fi
			if [ $i -eq 0 ]
			then
				a=$((s + w + x))
			elif [ $i -eq 1 ]
			then
				b=$((s + w + x))
			else
				c=$((s + w + x))
			fi
		done
	done

	read -p "Enter name of file: " Input10
	find . -name "$Input10" -type f -exec chmod $a$b$c {} \;
	read -p "Permissions updated. Would you like to see them?(Y/N)" Input11
	if [ "$Input11" = "y" ]
	then
		echo $(ls -l $Input10)
	fi
}

while

	echo "To check if local repo is up to date with remote repo, enter 1"
	echo "To put all uncomitted changes in changes.log, enter 2"
	echo "To put each line from every file of your project with the tag #TODO into a file todo.log, enter 3"
	echo "To check all haskell files for syntax errors and put the results into error.log, enter 4"
	echo "To see the differences between local and remote repo, enter 5"
	echo "In case you forgot find out who you are, where you are and what time it is by entering 6"
	echo "To find any file and modify its permissions, enter 7"
	
	read Input1

	if [ "$Input1" == "1" ]
	then
		compare_status
	elif [ "$Input1" == "2" ]
	then	
		changes
	elif [ "$Input1" == "3" ]
	then
		todo
	elif [ "$Input1" == "4" ]
	then
		haskell_errors
	elif [ "$Input1" == "5" ]
	then
		diffs
	elif [ "$Input1" == "6" ]
	then
		who_am_i
	elif [ "$Input1" == "7" ]
	then
		permissions
	fi
	read -p "Would you like to continue (Y/N): " Input
	[ "$Input" = "y" ]
do
	:
done
