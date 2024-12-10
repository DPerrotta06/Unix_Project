#!/bin/bash

 #LIST OF COLOR VARIABLE THAT CAN BE USED WITH READ -P, ECHO, SELECT
blue="\033[34m"
green="\033[32m"
orange="\033[1;38;5;208m"
white="\033[46m"
cyan="\033[36m"
red="\033[1;31m"
bold="\033[1m"
black="\033[30m"
hot_pink="\033[38;5;198m"
magenta="\033[35m"
bright_yellow="\033[1;33m"
dim="\033[2m"
underline="\033[4m"
reset="\033[0m"

menu(){
	echo -e "\e[36;40;1;4mWelcome $(whoami), what service can we provide for you?\e[0m"
	select choice in "$(echo -e $bright_yellow"System Status"$reset)" "$(echo -e $hot_pink"Backup"$reset)" "$(echo -e $orange"Network"$reset)" "$(echo -e $cyan"User Management"$reset)" "$(echo -e $green"Services"$reset)" "$(echo -e $red"File Management"$reset)" "$(echo -e $blue$bold$underline"Exit"$reset)"
        do
        case $choice in

	"$(echo -e $bright_yellow"System Status"$reset)")
		sleep 1
		System_Status #function is called is this case is selected
	;;
	"$(echo -e $bold$hot_pink"Backup"$reset)")
		sleep 1
		Backup #function is called is this case is selected
	;;
	"$(echo -e $orange"Network"$reset)")
		leep 1
		Network #function is called is this case is selected
	;;
	"$(echo -e $bold$green"Services"$reset)")
		sleep 1
		Services #function is called is this case is selected
	;;
	"$(echo -e $cyan"User Management"$reset)")
		sleep 1
		User_Management #function is called is this case is selected
	;;
	"$(echo -e $red"File Management"$reset)")
		sleep 1
		File_Management #function is called is this case is selected
	;;
	"$(echo -e $blue$bold$underline"Exit"$reset)")
		Exit #function is called is this case is selected
	;;
	*)
		echo -e "\e[1;31;4;1mInvalid option!\e[0m"
		menu #function calls itself if the user puts a choice that is not displayed
	;;
	esac
	done
}

System_Status(){ #COMPLETED DO NOT TOUCH ANYMORE!!!
		echo -e "\e[1;33;1mWelcome to the System Status menu! What can we do for you?\e[0m"
		select SSWidget in "$(echo -e $bright_yellow"Memory Status"$reset)" "$(echo -e $bright_yellow"CPU Temperature"$reset)" "$(echo -e $bright_yellow"Active Processes"$reset)" "$(echo -e $blue$bold$underline"Back To Main Menu"$reset)"
		do
		case $SSWidget in

			"$(echo -e $bright_yellow"Memory Status"$reset)")
				echo -e "\e[1m=============================================\e[0m"
				free -h | awk 'NR==2 {print "Available Memory: "$7}' #to show real time available memory with awk command to filter out important parts
				echo -e "\e[1m=============================================\e[0m"
				free -h | awk 'NR==2 {print "Used Memory: "$3}' #to show used memory in real time with awk command to filter out important parts"$(echo -e $blue$bold$underline"Back To Main Menu"$reset)"
				echo -e "\e[1m=============================================\e[0m"
				sleep 2
				System_Status
				;;

			"$(echo -e $bright_yellow"CPU Temperature"$reset)")
				cpu_temp=$(vcgencmd measure_temp | cut -d'=' -f2 | cut -d"'" -f1) #command is stored in variable and used cut to remove irrelevant characters
				if (( $(echo -e "$cpu_temp > 70.0" | bc -l) )); then
					printf "\a" #plays default noise provided by the terminal
					echo -e "\e[1;31;5mYOU'RE CPU TEMPERATURE IS ABOVE 70.0'C!!!\e[0m"
				else
					vcgencmd measure_temp | awk -F'=' '{print "CPU Temperature: "$2}' #check cpu tempearture and then is stored into variable to be used in an if statement
					echo -e "\e[1;32mCPU is at a stable temperature\e[0m"
				fi
				sleep 2
				System_Status #reprints system status menu
				;;

			"$(echo -e $bright_yellow"Active Processes"$reset)")
				if [ -e /usr/bin/htop ]; then #checks if package is already installed
					echo -e "\e[1;33mBefore you enter, press 'K' to enter KILL mode and use the ARROW KEYS to select the process; once seleted press 'ENTER' to kill the process. You can EXIT KILL MODE by pressing 'ESC'. To QUIT press 'ESC' or 'Q'\e[0m"
					sleep 9
					htop #htop to view real time processes
				else
					read -p "$(echo -e $red$bold"Before you proceed, you need to 'install' the htop package on your $(uname -n) system. Is that ok? '[y/n]'"$reset) " answer
					if [[ "${answer,,}" == "y" ]]; then #case insensitive
						sudo apt install htop #installs htop and runs it immediately after
						htop
					elif [[ "${answer,,}" == "n" ]]; then #case insensitive
						echo -e "\e[31;1mThis package needs to be installed in order for you to manage your processes!!!\e[0m"
					else
						echo -e "\e[1;31;4;1mInvalid option!\e[0m" #displays if the user puts an answer other than yes or no
					fi
				fi
				System_Status #reprints system status menu
				;;

			"$(echo -e $blue$bold$underline"Back To Main Menu"$reset)")
				echo -e "\e[33;1;2mHeading back to main menu...\e[0m"
				sleep 2
				menu #"gets out" of function and prints the main menu
				;;

			*)
				echo -e "\e[1;31;4;1mInvalid option!\e[0m"
				System_Status #function calls itself if the user puts a choice that is not displayed
				;;
			esac
		done
}



Backup(){ #COMPLETED DO NOT TOUCH ANYMORE!!!
	echo -e "\e[38;5;198;1mWelcome to the backup menu!\e[0m"
		date_time=$(date)
		#read -p "Enter date and time: " $date_time
		read -p "$(echo -e $hot_pink"Enter a file name: "$reset) " file
		read -p "$(echo -e $hot_pink"Enter a designated directory: "$reset) " directory
		if [ ! -f $file ]; then
			echo "File doesn't exist!!! Creating new File '$file'."
			touch "$file"
		fi
		if [ ! -d $directory ]; then
			echo "Directory doesn't exist!!! Creating new directory '$directory'."
			mkdir -p "$directory" #makes directory anyway
		fi
			echo "$date_time" >> "$file"
			cp "$file" "$directory"
		cd "$directory"
		find $(pwd) -name "$file"
		echo "Last backup has been scheduled successfully on $date_time."
		sleep 2
		echo -e "\e[1;31;4;1mInvalid option!\e[0m"
		sleep 2
		menu
}



Network(){
		echo -e "\e[38;5;208;1mWelcome to the Network menu! What would you like to do?\e[0m" #COMPLETED DO NOT TOUCH ANYMORE!!!
		select NWidget in "$(echo -e $orange"Network Card Information"$reset)" "$(echo -e $orange"Network Card Manager"$reset)" "$(echo -e $orange"Change IP"$reset)" "$(echo -e $orange"Wifi Connections"$reset)" "$(echo -e $blue$bold$underline"Back To Main Menu"$reset)"
		do
		case $NWidget in

			"$(echo -e $orange"Network Card Information"$reset)")
				echo "============================================="
				echo -e "\e[1mCurrent Network Interface:\e[0m"
				route -n | awk 'NR==3 {print $8}' #shows current network card you are connected
				echo "============================================="
				echo -e "\033[1mIP Addresses:\033[0m"
				if [ $(route -n | awk 'NR==3 {print $8}') == "wlan0" ]; then #gets the network card you are currently connected to and if it equals to wlan...
				ifconfig | awk 'NR==18 {print $2}' #...print ip address
				elif [ $(route -n | awk 'NR==3 {print $8}') == "eth0" ]; then #gets the network card you are currently connected to and if it equals ethernet...
				ifconfig | awk 'NR==2 {print $2}' #...print ip address
				fi
				echo "============================================="
				echo -e "\033[1mDefault Gateway:\033[0m"
				route -n | awk 'NR==3 {print $2}' #showing default gateway of current network
				echo "============================================="
				sleep 2
				Network #reprints network menu
			;;

			"$(echo -e $orange"Network Card Manager"$reset)")
				read -p "$(echo -e $red$bold"Would you like to disable or enable network cards on your system? "$reset) " config #prompts user to enable or disbale network cards 
                        		if [[ "${config,,}" == "enable" ]]; then #case insensitive, if statement 1 to check if you wan to enable a network card
                                		echo "Select the name of the interface(network type) you would like to modify dispalyed above"
                                		read -p "$(echo -e $bold$cyan"Interface: "$reset)" interface
                                		if [[ "${interface,,}" == "ethernet" ]] || [[ "${interface,,}" == "eth0" ]]; then #case insensitive, if statement 2 to check which interface you want to use
                                                	sudo ifconfig eth0 up #enable ethernet
                        			elif [[ "${interface,,}" == "wifi" ]] || [[ "${interface,,}" == "internet" ]] || [[ "${interface,,}" == "wlan0" ]]; then #case insensitive
                                        		sudo ifconfig wlan0 up #enable internet
                                		else
                                        		echo -e "\e[34;4;1mInvalid interface!\e[0m"
                        			fi #end of 2nd if statement
                        		elif [[ "${config,,}" == "disable" ]]; then #if you want to disable a network card
						echo "Select the name of the interface(network type) you would like to modify dispalyed above"
                                                read -p "$(echo -e $bold$cyan"Interface: "$reset)" interface
                                                if [[ "${interface,,}" == "ethernet" ]] || [[ "${interface,,}" == "eth0" ]]; then #case insensitive, if statement 3 to check which interface ou want to use
                                                	sudo ifconfig eth0 down #disables ethernet
                                                elif [[ "${interface,,}" == "wifi" ]] || [[ "${interface,,}" == "$internet" ]] || [[ "${interface,,}" == "wlan0" ]]; then
                                                        sudo ifconfig wlan0 down #disables ethernet
                                                else
                                                        echo -e "\e[34;4;1mInvalid interface!\e[0m"
                				fi #end of 3rd if statement

					else
						echo -e "\e[1;31;4;1mInvalid option!\e[0m"
					fi #end of 1st if statement
					sleep 2
				Network
			;;

			"$(echo -e $orange"Change IP"$reset)")
			read -p "$(echo -e $bold$cyan"Enter an IP address to set to a network card of your choice "$reset)" ip
				read -p "$(echo -e $bold$cyan"Enter the network card you like to set this IP to "$reset)" netCard
					setIP(){
                                        	if [ $(route -n | awk 'NR==3 {print $8}') == "wlan0" ]; then
                                                	current=ifconfig | awk 'NR==18 {print $2}'
                                        	elif [ $(route -n | awk 'NR==3 {print $8}') == "eth0" ]; then
                                                	current=ifconfig | awk 'NR==2 {print $2}'
                                        	fi
                                        	sudo ifconfig $netCard $current $ip
                                        	ifconfig
                                	}
				if [[ "${netCard,,}" == "ethernet" ]] || [[ "${netCard,,}" == "eth0" ]]; then
					setIP
					ifconfig | awk 'NR==2 {print "$(echo -e $bold"Ethernet IP: "$reset)"$2}'
				elif [[ "${netCard,,}" == "wifi" ]] || [[ "${netCard,,}" == "internet" ]] || [[ "${netCard,,}" == "wlan0" ]]; then
					setIP
					ifconfig | awk 'NR==18 {print "$(echo -e $bold"Wifi IP: "$reset)"$2}'
				else
					echo "$(echo -e $red$bold$underline"Invalid IP or network card!"$reset)"
				fi
				sleep 2
				Network
			;;

			"$(echo -e $orange"Wifi Connections"$reset)")
				if [ -e /usr/bin/nmcli ]; then
					nmcli dev wifi
				elif [ ! -e /usr/bin/nmcli ]; then
					read -p "$(echo -e $bold$red"To use this service, you need the network manager package installed on your $(uname -n) system. Would you like proceed installing the package? [y/n] "$reset)" answer
					if [[ "${answer,,}" == "y" ]]; then
						sudo apt install network-manager #installing package
						sudo systemctl start NetworkManager #starting up service
						sudo systemctl enable NetworkManager #enabling it
						nmcli dev wifi #showing nearby networks
					elif [[ "${answer,,}" == "n" ]]; then
						echo "$(echo -e $red"This package needs to be installed in order for you to manage your processes!!!"$reset)"
					else
						echo "$(echo -e $red$bold$underline"Invalid option!"$reset)"
					fi
				echo "============================================="
				fi
				echo "$(echo -e $orange"Connected Network:"$reset)"
				sleep 2
				nmcli connection show --active
				sleep 1
				read -p "$(echo -e $bold$cyan"Would you like to connect to a different network? [y/n] "$reset)" answer
				if [[ "${answer,,}" == "y" ]]; then
					read -p "$(echo -e $bold$cyan"Enter the name of the network you would like to connect to "$reset)" network_name
					nmcli device disconnect wlan0
					nmcli device disconnect eth0
					nmcli connection up "$network_name"
					sleep 2
				elif [[ "${answer,,}" == "n" ]]; then
					echo "The network will remain unchanged"
					sleep 2
				else
					echo "$(echo -e $red$bold$underline"Invalid option! "$reset)"
				fi
				Network
			;;

			"$(echo -e $blue$bold$underline"Back To Main Menu"$reset)")
				echo -e "\e[33;1;2mHeading back to main menu...\e[0m"
				sleep 2
				menu
			;;

			*)
				echo -e "\e[1;31;4;1mInvalid option!\e[0m"
				Network
			;;
		esac
	done
}



Services(){
	echo -e "\e[32;1mWelcome to the User Management menu! What can we do for you?\e[0m"
	select SWidget in "$(echo -e $green$bold"Show Services"$reset)" "$(echo -e $green$bold"Service Management"$reset)" "$(echo -e $blue$bold$underline"Back To Main Menu"$reset)"
	do
	case $SWidget in

	"$(echo -e $green$bold"Show Services"$reset)")
		echo "List of current services that are on the system:"
		systemctl list-units --type=service | awk '{print $1}' | nl
		sleep 2
		Services
	;;
 
	"$(echo -e $green$bold"Service Management"$reset)")
		start_services(){
			read -p "Enter name of the service that you want to start: " service
			sudo systemctl start "$service"
			if [ $? -eq 0 ]; then
				echo "Service $service started successfully"
			else
				echo "Failed to start the service $service "
			fi
		}
		stop_services(){
			read -p "Enter the name of the service that you want to stop: " service
			sudo systemctl stop "$service"
			if [ $? -eq 0]; then
				echo "service $service stopped"
			else
				echo "The attempt to stop the service failed, pleae try again"
			fi
		}
		read -p "Do you want to start or stop a service? " choice
		if [[ "${choice,,}" == "start" ]]; then
			start_services
		elif [[ "${choice,,}" == "stop" ]]; then
			stop_services
		else 
			echo -e "\e[1;31;4;1mInvalid option!\e[0m"
		fi
		sleep 2
	Services
	;;

	"$(echo -e $blue$bold$underline"Back To Main Menu"$reset)")
		echo -e "\e[33;1;2mHeading back to main menu...\e[0m"
		sleep 2
		menu
	;;

	*)
		echo -e "\e[1;31;4;1mInvalid option!\e[0m"
		Services
	;;
	esac
done
}



User_Management(){
	echo -e "\e[36;1mWelcome to the User Management menu! What can we do for you?\e[0m"
	select UMWidget in "$(echo -e $cyan$bold"Add User"$reset)" "$(echo -e $cyan$bold"Manage Root Permission"$reset)" "$(echo -e $cyan$bold"Delete User"$reset)" "$(echo -e $cyan$bold"Connected Users"$reset)" "$(echo -e $cyan$bold"Disconnect Users"$reset)" "$(echo -e $cyan$bold"User Group List"$reset)" "$(echo -e $cyan$bold"Change User Group"$reset)" "$(echo -e $blue$bold$underline"Back To Main Menu"$reset)"
	do
	case $UMWidget in

		"$(echo -e $cyan$bold"Add User"$reset)") #add user
                	read -p "Enter username of the new user " username
                        read -sp "Enter password for the $username " password
                        sudo useradd -m "$username" #creates the new user
                        echo  "$username":"$password" | sudo chpasswd #connects the username and the password together
                        echo "User $username has been added"
			sleep 2
			User_Management
		;;

                "$(echo -e $cyan$bold"Manage Root Permission"$reset)") #root permission
			read -p "Would you like to grant or revoke root permission? " permission
			if [[ "${permission,,}" == "grant" ]]; then
				read -p "Enter the username of user you want to give root permission to " username
				if id "$username" &>/dev/null; then
					sudo usermod -aG sudo "$username"
					echo "User $username has been granted permission to the root"
				fi
			elif [[ "${permission,,}" == "revoke" ]]; then
			read -p "Enter the username of the user you want to revoke root pemission from " username
				if id "$username" &>/dev/null; then
					sudo deluser "$username" sudo
					echo "User $username has been revoked permission to the root"
				fi
			else
				echo -e "\e[1;31;4;1mInvalid option!\e[0m"
			fi
			sleep 2
			User_Management
                ;;

                "$(echo -e $cyan$bold"Delete User"$reset)") #delete user
                        read -p "Enter username of User you want to delete " username
                        sudo deluser "$username"
                        echo "User $username has been succesfully deleted"
			sleep 2
			User_Management
		;;

                "$(echo -e $cyan$bold"Connected Users"$reset)") #connect user
                        echo "List of connected users:"
                        sudo who
			User_Management
                ;;

               "$(echo -e $cyan$bold"Disconnect Users"$reset)") #disconnect user
                        read -p "Enter username of User you want to disconnect " username
                        user_id=$(gprep -u "$username")
                        if [ -n "$user_id" ]; then
                        sudo kill -9 "$user_id"
                        echo "user $username has been disconnected"
			User_Management
                        else
                        echo "There is no active users by the name of $username"
                        fi
			sleep 2
			User_Management
                ;;

               "$(echo -e $cyan$bold"User Group List"$reset)") #groups user is part of
                        read -p "Enter username to view groups: " username
                        groups "$username"
			sleep 2
			User_Management
                ;;

               "$(echo -e $cyan$bold"Change User Group"$reset)") #change the user's group
                        read -p "Username to change user group: " username
                        read -p "Primary group to change into: " group
                        sudo usermod -g "$group" "$username"
                        echo "The primary group for $username is now $group"
			sleep 2
			User_Management
        	;;

                "$(echo -e $blue$bold$underline"Back To Main Menu"$reset)") #reprint main menu
                       echo -e "\e[33;1;2mHeading back to main menu...\e[0m"
		       sleep 2
                       menu
                ;;

		*)
			echo -e "\e[1;31;4;1mInvalid option!\e[0m"
			User_Management #reprints user management options
		;;
	esac
done
}



File_Management(){
	echo -e "\e[1;31;1mWelcome to the File Management menu! What can we do for you?\e[0m"
		select FMWidget in "$(echo -e $red$bold"Check User and File"$reset)" "$(echo -e $red$bold"Display 10 Largest Files"$reset)" "$(echo -e $red$bold"Display 10 Oldest Files"$reset)" "$(echo -e $red$bold"Send Email"$reset)" "$(echo -e $blue$bold$underline"Back To Main Menu"$reset)"
		do
		case $FMWidget in

			"$(echo -e $red$bold"Check User and File"$reset)")
				read -p "Enter a username: " username
				grep "$username" /etc/passwd #Checks if the username exists
				if [ $? -eq 0 ]; then
					"$(echo -e $green$bold"User exists" $reset)"
				else
					"$(echo -e $red$bold$underline"User not found!!! "$reset)"
					File_Management
				fi
				read -p "Enter a file name: " file
				if [ -f "$file" ]
				then
					find $(pwd) -name "$file" #Finds full path of a file
				else
					"$(echo -e $red$bold$underline"$file does not exists!!! "$reset)"
				fi
				sleep 2
				File_Management
			;;

			"$(echo -e $red$bold"Display 10 Largest Files"$reset)")
				#Display the 10 largest files in user's home directory
				echo "Here are the 10 largest files of home directory- "
				sudo find /home/ -type f -exec du {} + | sort -n -r | head -n 10 #find to search into home directory, type -f command to files only, execute du command to show disk usage or disk space used by files {} + and return file path, sort numerically in reverse order and displays 10 largest files
				sleep 2
				File_Management
			;;

			"$(echo -e $red$bold"Display 10 Oldest Files"$reset)")
				#Display the 10 oldest filesin user's home directory
				echo "Here are the 10 oldest files of home directory- "
				sudo find /home/ -type f -printf '%T+ %p\n' | sort | head -n 10  #find to search into home directory, type -f command to files only, print to date and time format with \n new line, sort from oldest to newest and head -n 10 displays 10 oldest files.
				sleep 2
				File_Management
			;;

			"$(echo -e $red$bold"Send Email"$reset)")
				if [ ! -e /usr/bin/mutt ]; then
					"$(echo -e $bright_yellow$bold$underline"To use this service, you need the mutt package installed on your $(uname -n) system. Would you like proceed installing the package? [y/n] "$reset)"  answer
                                        if [[ "${answer,,}" == "y" ]]; then
						sudo apt install mutt
					elif [[ "${answer,,}" == "n" ]]; then
						"$(echo -e $red$bold$underline"This package needs to be installed in order for you to manage your processes!!!" $reset)"
						File_Management
                                        else
                                                "$(echo -e $red$bold$underline"Invalid option!" $reset)"
						File_Management
					fi
				elif [ -e /usr/bin/mutt ];then
					read -p "Enter a email address: " email
					read -p "Enter a file name you want to send: " filename
					if [ ! -f "$filename" ]; then
						"$(echo -e $red$bold$underline"'$filename' does not exist!" $reset)"
						File_Management
					else
						echo "Email from Linux" | mutt -s "Project email" -a "$filename" -- "$email"
					fi
        				if [ $? -eq 0 ]; then
                				echo "$(echo -e $green$bold"Email has been sent successfully "$reset)"
        				else
                				echo "Error!!!"
        				fi
				fi
				sleep 2
			File_Management
			;;

			"$(echo -e $blue$bold$underline"Back To Main Menu"$reset)")
				echo -e "\e[33;1;2mHeading back to main menu...\e[0m"
				sleep 2
				menu
			;;

			*)
				echo -e "\e[1;31;4;1mInvalid option!\e[0m"
				File_Management
			;;
		esac
        done
}



Exit(){
	echo -e  "\e[32;40;1mGoodbye!!!\e[0m"
	exit 1
}
menu
