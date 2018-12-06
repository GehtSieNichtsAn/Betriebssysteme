#!/bin/bash
adresse=$1  #10.0.2.15
port=$2
text=$3

send() {
	echo -n $1 | nc -c $adresse $port
}

encrypt() {
	pwd="$(echo -n $password | shasum -a 256)" #>> login.txt
	echo $pwd
}

LoginRegister() {
	echo -n "login: "
	read loginname
	send $loginname
	echo "$loginname" >> login.txt
	echo -n "password: "
	read -s password
	echo " "
	encpwd=$(encrypt)
	send $encpwd
}

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
	   LoginRegister
	   #echo -n "login: "
	   #read loginname
	   #echo -n "password: "
	   #read -s password
	   #encrypt
	   #echo "$loginname" "$password" > login.txt
	   #echo "   "
	   ;;

	l) echo "Login"
	   echo -n 		


;;
	q) echo "Quit";;
	*) echo "Invalid Command!";;
esac


#send to server
#echo -n $text | nc -c $adresse $port
#cat login.txt | nc -c $adresse $port
#cat login.txt
nc -c $adresse $port < login.txt
echo $adresse, $port, $text	

#receive from server
request="$(nc -l -p 2022)"
echo Received String from Server: $request
