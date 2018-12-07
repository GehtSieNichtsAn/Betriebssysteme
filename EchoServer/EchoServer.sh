#!/bin/bash

receive() {	
	received="$(nc -l -p 2020)"
	#if grep -q $request out.txt; then
    #	echo found
	#else
    #	echo not found
	#fi
	
	#echo -e "$request" >> out.txt
	#cat out.txt
}

send() {
	echo -n $1 | nc -c 10.0.2.15 2022
}

loginClient() {
	echo "Login..."
	#Check Login
	receive
	read loginname < ./User
	if [ "$loginname" = "$received" ]; then
		echo "User exists"
		send 1
	else
		echo "User doesnt exists"
		send 0
	fi
	#Check Password
	read C < ./C
	send $C
	receive
	echo $received > ./tmpHashedPW
	read hashedPW < ./HashedPW
	tmphashedPW=`shasum -a 256 ./tmpHashedPW | cut -d ' ' -f1`
	if [ "$hashedPW" = "$tmphashedPW" ]; then
		echo "Password correct"
		send 1
	else
		echo "Password incorrect"
		send 0	
	fi
	#Check File
	receive
	send "$(cat "$received")"
}

registerClient() {
	echo "Registration..."
	receive
	echo $received > ./User
	receive
	echo $received > ./HashedPW
	receive
	echo $received > ./N
	echo 1 > ./C
	send "Successful Registration!"
}

while true;
do
	receive	
	case $received in
		r) registerClient
		;;
		l) loginClient
		;;
	esac
done
