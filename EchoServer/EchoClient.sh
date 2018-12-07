#!/bin/bash

send() {
	echo -n $1 | nc -c 10.0.2.15 2020
}

receive() {
	received="$(nc -l -p 2022)"
}

encrypt() {
	hashedPW=`shasum -a 256 ./HashedPW | cut -d ' ' -f1` #mit Variable ersetzen
	echo $hashedPW > ./HashedPW
}

loginAtServer() {
	send l	
	echo "----- L O G I N -----"
	echo -n "login: "
	read loginname
	echo -n "password: "
	read -s loginpassword
	echo " "
	echo -n "file name: "
	read filePath
	#Check Login
	send $loginname
	receive
	if [ "$received" = "0" ]; then
		echo "Invalid Username!"
		exit -1
	fi	
	#Check Password
	receive
	tmpC=$received
	read N < ./N
	N=$((N - tmpC))
	echo $loginpassword > ./tmpHashedPW
	while [ $N -ne 0 ];
	do
		hashedPW=`shasum -a 256 ./tmpHashedPW | cut -d ' ' -f1`
		echo $hashedPW > ./tmpHashedPW
		N=$((N - 1))
	done
	send $hashedPW
	receive
	if [ "$received" = "0" ]; then
		echo "Wrong Password!"
		exit -1
	fi
	echo "Successful Login!"
	#Check File
	echo " "
	send $filePath
	receive	
	echo "----- Requested File -----"
	echo $received
}

registerAtServer() {
	send r
	echo "----- R E G I S T E R -----"
	echo -n "login: "
	read registername
	send $registername
	echo -n "password: "
	read -s registerpassword
	echo $registerpassword > ./HashedPW
	for i in {0..9}; do
		encrypt
	done 
	send $hashedPW
	send 10
	echo 10 > ./N
	echo " "
	receive
	echo $received
}

while true;
#menu
echo " "
echo "======   Lab: Shell Programming (BS)   ======"
echo 
echo "    r      Register"
echo "    l      Login"
echo "    q      Quit"
echo
echo -n "your choice: "
read choice

do
	case "$choice" in
		r) registerAtServer	  
		   ;;
		l) loginAtServer
    	   ;;
		q) echo "Quit"
		   exit 0
		   ;;
		*) echo "Invalid Command!"
		   ;;
	esac	
done
