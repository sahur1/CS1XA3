# Assignment 1

### Required Features
###### 1. compare_status:
Checks whether local repo is up to date with remote repo. Allows the user to update if they wish.

###### 2. changes:
Stores all uncommited changes in changes.log.

###### 3. todo:
Searches all files for lines containing #TODO and puts them in todo.log.

###### 4. haskell_errors:
Searches for all haskell files in the project and compiles them to test for errors which are then stored in error.log. If a haskell file doesn't have a main function, it adds a main function temporarily.

### Additional Features
###### 1. diffs:
Displays the differences between local repo and remote repo.

###### 2. who_am_i:
In case you forget who forget who you are, where you are and what time it is, this feature reminds you.

###### 3. permissions:
Allows you to find any file and modify its permissions.

###### 4. encrypt:
Allows you to encrypt a file and lets you decrypt it if you wish. It uses 256-bit AES encryption with Cipher Block Chaining (CBC).

Note: 
- This function will only work if you have *OpenSSL* installed.
- Information on encryption and decryption was found here: https://www.madboa.com/geek/openssl/#encrypt-simple

### General Features
- A rudimentary menu simplifies usage.
- Allows user to view changes wherever called for.

### Usage
- File must be at the root of your repo.
- Enter `./ProjectAnalyze.sh` to run and follow the menu according to what actions you want to perform.
