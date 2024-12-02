#!/bin/bash

blue="\033[34m"
green="\033[32m"
orange="\033[38;5;208m"
white="\033[46m"
cyan="\033[36m"
red="\033[1;31m"
bold="\033[1m"
black="\033[30m"
hot_pink="\033[38;5;198m"
magenta="\033[35m"
yellow="\033[33m"
bright_yellow="\033[1;33m"
dim="\033[2m"
reset="\033[0m"

menu(){
	echo -e "\e[36;40;1;4mWelcome to $(whoami), what service can we provide for you?\e[0m"
	select choice in "$(echo -e $yellow"System Status"$reset)" "$(echo -e $hot_pink"Backup"$reset)" "$(echo -e $orange"Network"$reset)" "$(echo -e $cyan"User Management"$reset)" "$(echo -e $green"Services"$reset)" "$(echo -e $red"File Management"$reset)" Exit
        do
        case $choice in

	"$(echo -e $yellow"System Status"$reset)")
		System_Status
	;;
	"$(echo -e $hot_pink"Backup"$reset)")
		Backup
	;;
	"$(echo -e $orange"Network"$reset)")
		Network
	;;
	"$(echo -e $green"Services"$reset)")
		Services
	;;
	"$(echo -e $cyan"User Management"$reset)")
		User_Management
	;;
	"$(echo -e $red"File Management"$reset)")
		File_Management
	;;
	Exit)
		Exit
	;;
	*)
		echo -e "\e[34;4;1mInvalid option!\e[0m"
		menu
	;;
	esac
	done
}

System_Status(){ #COMPLETED DO NOT TOUCH ANYMORE!!!
		echo -e "\e[33;;1mWelcome to the System Status menu! What can we do for you?\e[0m"
		select SSWidget in "$(echo -e $bright_yellow"Memory Status"$reset)" "$(echo -e $bright_yellow"CPU Temperature"$reset)" "$(echo -e $bright_yellow"Active Processes"$reset)" 'Back To Main Menu'
		do
		case $SSWidget in

			"$(echo -e $bright_yellow"Memory Status"$reset)")
				echo -e "\e[1m=============================================\e[0m"
				free -h | awk 'NR==2 {print "Available Memory: "$7}' #to show real time available memory
				echo -e "\e[1m=============================================\e[0m"
				free -h | awk 'NR==2 {print "Used Memory: "$3}' #to show used memory in real time
				echo -e "\e[1m=============================================\e[0m"
				System_Status
				;;

			"$(echo -e $bright_yellow"CPU Temperature"$reset)")
				cpu_temp=$(vcgencmd measure_temp | cut -d'=' -f2 | cut -d"'" -f1)
				if (( $(echo -e "$cpu_temp > 70.0" | bc -l) )); then
					printf "\a"
					echo -e "\e[1;31;5mYOU'RE CPU TEMPERATURE IS ABOVE 70.0'C!!!\e[0m"
				else
					vcgencmd measure_temp | awk -F'=' '{print "CPU Temperature: "$2}' #check cpu tempearture and then is stored into variable to be used in an if statement
					echo -e "\e[1;32mCPU is at a stable temperature\e[0m"
				fi
				System_Status
				;;

			"$(echo -e $bright_yellow"Active Processes"$reset)")
				if [ -e /usr/bin/htop ]; then
					htop
				else
					read -p "$(echo -e $red$bold"Before you proceed, you need to 'install' the htop package on your $(uname -n) system. Is that ok? '[y/n]'"$reset) " answer
					if [[ "${answer,,}" == "y" ]]; then
						sudo apt install htop
						htop
					elif [[ "${answer,,}" == "n" ]]; then
						echo -e "\e[31;1mThis package needs to be installed in order for you to manage your processes!!!\e[0m"
					else
						echo -e "\e[31;4;1mInvalid option!\e[0m"
					fi
				fi
				System_Status
				;;

			'Back To Main Menu')
				echo -e "\e[33;1;2mHeading back to main menu...\e[0m"
				menu
				;;

			*)
				echo -e "\e[31;4;1mInvalid option!\e[0m"
				System_Status
				;;
		esac
		done
}



Backup(){
		echo "Welcome to the backup menu!"
		date_time=$(date)
#		read -p "Enter date and time: " $date_time
		read -p "Enter a file name: " file
		read -p "Enter a designated directory: " directory
		if [ ! -f $file ]; then
			echo "File doesn't exist!!!"
			Backup
		fi
		if [ ! -d $directory ]; then
			echo "Directory doesn't exist!!!"
			mkdir -p $directory #makes directory anyway
		else
			echo "$date_time" >> "$file"
			cp "$file" "$directory"
		fi
		cd "$directory"
		find $(pwd) -name "$file"
		echo "Last backup has been scheduled successfully on $date_time."
		menu
}



Network(){
		echo -e "\e[38;5;208;1mWelcome to the Network menu! What would you like to do?\e[0m"
		select NWidget in "$(echo -e $orange$dim"Network Card Information"$reset)" "$(echo -e $orange$dim"Network Card Manager"$reset)" "$(echo -e $orange$dim"Change IP"$reset)" "$(echo -e $orange$dim"Wifi Connections"$reset)" 'Back To Main Menu'
		do
		case $NWidget in

			"$(echo -e $orange$dim"Network Card Information"$reset)")
				echo "============================================="
				echo -e "$(echo -e $bold"Current Network Interface: "$reset)"
				route -n | awk 'NR==3 {print $8}'
				echo "============================================="
				echo -e "\033[1mIP Addresses:\033[0m" #bold
				route -n | awk 'NR==4 {print $1}' #showing ip of current network card you are connected to
				echo "============================================="
				echo -e "\033[1mDefault Gateway:\033[0m"
				route -n | awk 'NR==3 {print $2}' #showing default gateway of current network card you are connected to
				echo "============================================="
				Network
			;;

			"$(echo -e $orange$dim"Network Card Manager"$reset)")

				read -p "$(echo -e $red$bold"Would you like to disable or enable network cards on your system? "$reset) " config
                        		if [[ "${config,,}" == "enable" ]]; then #case insensitive, if statement 1 to check if you wan to enable a network card
                                		echo "Select the name of the interface(network type) you would like to modify dispalyed above"
                                		read -p "$(echo -e $bold$cyan"Interface: "$reset)" interface
                                		if [[ "${interface,,}" == "ethernet" ]] || [[ "${interface,,}" == "eth0" ]]; then #case insensitive, if statement 2 to check which interface you want to use
                                                	sudo ifconfig eth0 up
                        			elif [[ "${interface,,}" == "wifi" ]] || [[ "${interface,,}" == "internet" ]] || [[ "${interface,,}" == "wlan0" ]]; then #case insensitive
                                        		sudo ifconfig wlan0 up
                                		else
                                        		echo -e "\e[34;4;1mInvalid interface!\e[0m"
                        			fi #end of 2nd if statement
                        		elif [[ "${config,,}" == "disable" ]]; then #if you want to disable a network card
						echo "Select the name of the interface(network type) you would like to modify dispalyed above"
                                                read -p "$(echo -e $bold$cyan"Interface: "$reset)" interface
                                                if [[ "${interface,,}" == "ethernet" ]] || [[ "${interface,,}" == "eth0" ]]; then #case insensitive, if statement 3 to check which interface ou want to use
                                                	sudo ifconfig eth0 down
                                                elif [[ "${interface,,}" == "wifi" ]] || [[ "${interface,,}" == "$internet" ]] || [[ "${interface,,}" == "wlan0" ]]; then
                                                        sudo ifconfig wlan0 down
                                                else
                                                        echo -e "\e[34;4;1mInvalid interface!\e[0m"
                				fi #end of 3rd if statement

					else
						echo -e "\e[34;4;1mInvalid option!\e[0m"
					fi #end of 1st if statement
				Network
			;;

			"$(echo -e $orange$dim"Change IP"$reset)")
			read -p "$(echo -e $bold$cyan"Enter an IP address to set to a network card of your choice "$reset)" ip
					echo "Checking if that ip is available..."
				setIP(){
                                        sudo ip addr add "$ip"/24 dev "$netCard"
                                }
				isValidIP(){
                                        i=1
                                        while [ $i -le 255 ]
                                        do
                                                ping -c 1 -W 1 "$octet.$i" > /dev/null 2>&1
                                                if [ $? -eq 0 ]; then
                                                        echo "$octet.$i is available!"
                                                        $octet.$i
							setIP
                                                else
                                                        echo "$octet.$i isn't available!"
                                                fi
                                        i=$((i + 1))
                                        done
                                }
				isValidIP
				read -p "$(echo -e $bold$cyan"Enter the network card you like to set this IP to "$reset)" netCard
				if [[ "${netCard,,}" == "ethernet" ]] || [[ "${netCard,,}" == "eth0" ]]; then
					setIP
				elif [[ "${netCard,,}" == "wifi" ]] || [[ "${netCard,,}" == "internet" ]] || [[ "${netCard,,}" == "wlan0" ]]; then
					setIP
				else
					echo "Invalid IP or network card!"
				fi
				ifconfig | awk 'NR==2 {print "Ethernet IP Address: "$2} NR==18 {print "Internet IP Address: "$2}'
				Network
			;;

			"$(echo -e $orange$dim"Wifi Connections"$reset)")
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
						echo "This package needs to be installed in order for you to manage your processes!!!"
					else
						echo "Invalid option!"
					fi
				fi
				echo "Connected Network:"
				nmcli connection show --active
				read -p "$(echo -e $bold$cyan"Would you like to connect to a different network? [y/n] "$reset)" answer
				if [[ "${answer,,}" == "y" ]]; then
					read -p "$(echo -e $bold$cyan"Enter the name of the network you would like to connect to "$reset)" network_name
					nmcli device disconnect wlan0
					nmcli device disconnect eth0
					nmcli connection up "$network_name"
				elif [[ "${answer,,}" == "n" ]]; then
					echo "The network will remain unchanged"
				else
					echo "Invalid option!"
				fi
				Network
			;;

			'Back To Main Menu')
				echo "Heading back to main menu..."
				menu
			;;

			*)
				echo "Invalid option!"
			;;
		esac
		done
}



Services(){
	echo "Welcome to the User Management menu! What can we do for you?"
	select SWidget in 'Show Services' 'Service Management' 'Back To Main Menu'
	do
	case $SWidget in
	
	'Show Services')
	echo "List of current services that are on the system:"
    systemctl list-units --type=service --state=running
    Services
    ;;
    'Service Management')
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
            sudo systemcl stop "$service"
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
			echo "Invalid option!"
			fi
	Services
	;;

	'Back To Main Menu')
		echo "Heading back to main menu..."
        menu
		;;

		*)
		echo "Invalid option!"
			Services
		;;
	esac
done
}



User_Management(){
	echo "Welcome to the User Management menu! What can we do for you?"
	select UMWidget in 'Add User' 'Give Root Permission' 'Delete User' 'Connected Users' 'Disconnect Users' 'User Group List' 'Change User Group' 'Back To Main Menu'
    do
	case $UMWidget in

		'Add User')
                	read -p "Enter username of the new user " username
                        read -sp "Enter password for the $username " password
                        echo
                        sudo useradd -m "$username" #creates the new user 
                        echo  "$username":"$password" | sudo chpasswd #connects the username and the password together
                        echo "User $username has been added"
		;;

                'Give Root Permission')
                        read -p "Enter username of user you want to give root permission to " username
                        sudo usermod -a -G sudo "$username"
                        echo "User $username has been granted permission to the root"
                ;;

                'Delete User')
                        read -p "Enter username of User you want to delete " username
                        sudo deluser "$username"
                        echo "User $username has been succesfully deleted"
		;;

                'Connected Users')
                        echo "List of connected users:"
                        sudo who
                ;;

               'Disconnect Users')
                        read -p "Enter username of User you want to disconnect " username
                        user_id=$(gprep -u "$username")
                        if [ -n "$user_id" ]; then
                        sudo kill -9 "$user_id"
                        echo "user $username has been disconnected"
                        else
                        echo "There is no active users by the name of $username"
                        fi
                ;;

               'User Group List')
                        read -p "Enter username to view groups: " username
                        groups "$username"
                ;;

               'Change User Group')
                        read -p "Username to change user group: " username
                        read -p "Primary group to change into: " group
                        sudo usermod -g "$group" "$username"
                        echo "The primary group for $username is now $group"
        	;;

                'Back To Main Menu')
                       echo "Heading back to main menu..."
                       menu
                ;;

		*)
			echo "Invalid option!"
			User_Management
		;;
	esac
	done
}



File_Management(){
		echo "Welcome to the File Management menu! What can we do for you?"
		select FMWidget in 'Check User and File' 'Display 10 Largest Files' 'Display 10 Oldest Files' 'Send Email' 'Back To Main Menu'
        do
		case $FMWidget in

			'Check User and File')	
				read -p "Enter a username: " username
				grep "$username" /etc/passwd #Checks if the username exists
				if [ $? -eq 0 ]; then
					echo "User exists"
				else
					echo "User not found!!!"
					exit 1
				fi
				read -p "Enter a file name: " file
				if [ -f "$file" ]
				then
					find $(pwd) -name "$file" #Finds full path of a file
				else
					echo "$file does not exists!!!"
				fi
			;;

			'Display 10 Largest Files')	
				#Display the 10 largest files in user's home directory
				echo "Here are the 10 largest files of home directory- "
				du -a /home | sort -n -r | head -n 10

			;;

			'Display 10 Oldest Files')
				#Display the 10 oldest filesin user's home directory
				echo "Here are the 10 oldest files of home directory- "
				find /home/ -type f -printf '%T+ %p\n' | sort | head -n 10
			;;

			'Send Email')
				if [ ! -e /usr/bin/mutt ]; then
					echo "To use this service, you need the mutt package installed on your $(uname -n) system. Would you like proceed installing the package? [y/n] "  answer
                                        if [[ "${answer,,}" == "y" ]]; then
						sudo apt install mutt
					elif [[ "${answer,,}" == "n" ]]; then
						echo "This package needs to be installed in order for you to manage your processes!!!"
						File_Management
                                        else
                                                echo "Invalid option!"
						File_Management
					fi
				elif [ -e /usr/bin/mutt ];then
					read -p "Enter a email address: " email
					read -p "Enter a file name you want to send: " filename
					if [ ! -f $filename ]; then
						echo "'$filename' does not exist!"
						File_Management
					fi
					echo "Email from Linux" | mutt -s "Project email" -a "$filename" -- "$email"
        				if [ $? -eq 0 ]; then
                				echo "email has been sent successfully"
        				else
                				echo "error!!!"
        				fi
				fi
			File_Management
			;;

			'Back To Main Menu')
                echo "Heading back to main menu..."
                menu
            ;;

            *)
                echo "Invalid option!"
            ;;

        esac
        done
}



Exit(){
	echo "Goodbye!!!"
	exit 1
}
menu
