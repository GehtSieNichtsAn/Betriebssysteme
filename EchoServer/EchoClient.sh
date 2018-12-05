#!/bin/bash
adresse=$1  #10.0.2.15
port=$2
text=$3

#menu
echo "======   Lab: Shell Programming (BS)   ======"
echo 
echo "    r      Register"
echo "    l      Login"
echo "    q      Quit"
echo
echo -n "your choice: "
read choice

case "$choice" in
	r) echo "----- R E G I S T E R -----"
	   echo -n "login: "
	   read loginname
	   echo -n "password: "
	   read -s password
	   echo "$loginname" "$password" > login.txt
	   echo "   ";;

	l) echo "Login";;
	q) echo "Quit";;
	*) echo "Invalid Command!";;
esac


#send to server
#echo -n $text | nc -c $adresse $port
cat login.txt | nc -c $adresse $port
echo $adresse, $port, $text	

#receive from server
request="$(nc -l -p 2022)"
echo Received String from Server: $request