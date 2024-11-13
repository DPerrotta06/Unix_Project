#!/bin/bash

read -p "Welcome to $(whoami), what service can we provide for you? "
	select choice in 'System Status' Backup Network 'User Management' 'File Management' Exit
	do
	case $choice in

	'System Status')
		read -p "Welcome to the System Status menu! What can we do for you? "
		select SSWidget in 'Memory Status' 'CPU Temperature' 'Active Processes' 'Back To Main Menu'
		do
		case $SSWidget in

			'Memory Status')
				free -h | awk 'NR==2 {print "Available Memory: "$7}' #to show real time available memory
				echo "============================================="
				free -h | awk 'NR==2 {print "Used Memory: "$3}' #to show used memory in real time
				echo "============================================="
				;;

			'CPU Temperature')
				if (( $(echo "$(vcgencmd measure_temp) -gt 70.0 C" | bc -l) )); then
					echo -e /"a"
					echo "YOU'RE CPU TEMPERATURE IS ABOVE 70.0'C!!!"
				else
					vcgencmd measure_temp | awk -F'=' '{print "CPU Temperature: "$2}' #check cpu tempearture and then is stored into variable to be used in an if statement
					echo "CPU is at a stable temperature"
				fi
				;;

			'Active Processes')
				htop
				;;

			'Back To Main Menu')
				break;
				;;

			*)
				echo "Invalid option!"
				;;

	esac
done
;;

Backup)
read -p "Enter date and time: " date
read -p "Enter a file name: " file
read -p "Enter a designated directory: " directory
read -p "Enter an address to backup this file: " address

if [ ! -f $file ]
then
 echo "File doesn't exist!!!"
 exit 1
fi

if [ ! -d $directory ]
then
 echo "Directory doesn't exist!!!"
 mkdir -p  $directory
else
  echo "$date" >> "$file"
  cp "$file" "$directory"
fi

cd "$directory"
pwd

echo "Last backup has been scheduled successfully on $date."
;;
Network)
;;
'User Management')
add_user()
 {
	read -p "Enter username of new User" username
	read -sp "Enter password for the $username" password
	echo
	sudo useradd -m "$username" #creates the new user 
	echo  "$username":"$password" | sudo chpasswd #connects the username and the password together
	echo "User $username has been added"
 }

 give_root_permission()
 {
	read -p "Enter username of user you want to give root permission to" username
	sudo usermod -a -G sudo "$username"
	echo "User $username has been granted permission to the root"
 }

 deleting_user()
 {
	read -p "Enter username of User you want to delete" username
	sudo deluser "$username"
	echo "User $username has been succesfully deleted"
 }

 show_connected_users()
 {
	echo "List of connected users:"
	sudo who
 }

 disconnect_user()
 {
	read -p "Enter username of User you want to disconnect" username
	sudo 
 }

 list_user_groups()
 {
 }

 change_user_group()
 {
	
 }



'File Management')
;;

Exit)
echo "Goodbye!!!"
break
;;

*)
echo "Invalid option!"
;;

esac

done
