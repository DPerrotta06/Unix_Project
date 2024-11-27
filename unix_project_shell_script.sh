#!/bin/bash

echo "Welcome to $(whoami), what service can we provide for you? "
	
select choice in 'System Status' Backup Network 'User Management' Services 'File Management' Exit
do
case $choice in

	'System Status')
		echo "Welcome to the System Status menu! What can we do for you? "
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
				cpu_temp=$(vcgencmd measure_temp | cut -d'=' -f2 | cut -d"'" -f1)
				if (( $(echo "$cpu_temp > 70.0" | bc -l) )); then
					printf "\a"
					echo "YOU'RE CPU TEMPERATURE IS ABOVE 70.0'C!!!"
				else
					vcgencmd measure_temp | awk -F'=' '{print "CPU Temperature: "$2}' #check cpu tempearture and then is stored into variable to be used in an if statement
					echo "CPU is at a stable temperature"
				fi
			;;

			'Active Processes')
				if [ -e /usr/bin/htop ]; then
					htop
				else
					read -p "Before you proceed, you need to install the htop package on your $(uname -n) system. Is that ok? [y/n]" answer
					if [[ "${answer,,}" == "y" ]]; then
						sudo apt install htop
						htop
					elif [[ "${answer}" == "n" ]]; then
						echo "This package needs to be installed in order for you to manage your processes!!!"
					else
						echo "Invalid option!"
					fi
				fi
			;;

			'Back To Main Menu')
				echo "Heading back to main menu..."
				break;
			;;

			*)
				echo "Invalid option!"
			;;

		esac
		
		done
	;;

	Backup)
		echo "Welcome to the Backup menu! What can we do for you? "
        select BuWidget in 'Backup file' 'Back To Main Menu'
        do

        case $BuWidget in

			'Backup file')		
				read -p "Enter date and time: " date
				read -p "Enter a file name: " file
				read -p "Enter a designated directory: " directory
		
				if [ ! -f $file ]; then
 					echo "File doesn't exist!!!"
 					touch "$file"
				fi
		
				if [ ! -d $directory ]; then
 					echo "Directory doesn't exist!!!"
 					mkdir -p  $directory
				else
  					echo "$date" >> "$file"
 		 			cp "$file" "$directory"
				fi
		
				cd "$directory" #Look fo the file in the directory
				find $(pwd) -name "$file" #Look for the full path of the file
				echo "Last backup has been scheduled successfully on $date."
			;;

			'Back To Main Menu')
                echo "Heading back to main menu..."
                break;
                ;;

            *)
				echo "Invalid option!"
            ;;

        esac

        done
	;;


	Network)
		echo "Welcome to the Network menu! What would you like to do?"
		select NWidget in 'Network Card Information' 'Network Card Manager' 'Change IP' 'Wifi Connections' 'Back To Main Menu'
		do
		
		case $NWidget in

			'Network Card Information')
				ifconfig
				echo "============================================="
				echo -e "\033[1mIP Addresses:\033[0m" #bold
				route -n | awk 'NR==4 {print $1}' #showing ip of current network card you are connected to
				echo "============================================="
				echo -e "\033[1mDefault Gateway:\033[0m"
				route -n | awk 'NR==3 {print $2}' #showing default gateway of current network card you are connected to
				echo "============================================="
			;;

			'Network Card Manager')
				read -p "Would you like to disable or enable network cards on your system?" config
                        		if [[ "${config,,}" == "enable" ]]; then #case insensitive, if statement 1 to check if you wan to enable a network card
                                		echo "Select the name of the interface(network type) you would like to modify dispalyed above"
                                		read -p "Interface: " interface
                                		if [[ "${interface,,}" == "Ethernet" ]] || [ "$interface" == "eth0" ]; then #case insensitive, if statement 2 to check which interface ou want to use
                                                	sudo ifconfig eth0 up
                       				elif [[ "${interface,,}" == "$Local Loopback" ]] || [ "$interface" == "lo" ]; then
                                        		sudo ifconfig lo up
                        			elif [[ "${interface,,}" == "$Wifi" ]] || [[ "${interface}" == "$Internet" ]] || [ "$interface" == "wlan0" ]; then #case insensitive
                                        		sudo ifconfig wlan0 up
                                		else
                                        		echo "Invalid interface!"
                        			fi #end of 2nd if statement
                        		elif [[ "${config,,}" == "$disable" ]]; then #if you want to disable a network card
						echo "Select the name of the interface(network type) you would like to modify dispalyed above"
                                                read -p "Interface: " interface
                                                if [[ "${interface,,}" == "$Ethernet" ]] || [ "$interface" == "eth0" ]; then #case insensitive, if statement 3 to check which interface ou want to use
                                                	sudo ifconfig eth0 down
                                                elif [[ "${interface,,}" == "$Local Loopback" ]] || [ "$interface" == "lo" ]; then
                                                        sudo ifconfig lo down
                                                elif [[ "${interface,,}" == "$Wifi" ]] || [[ "${interface}" == "$Internet" ]] || [ "$interface" == "wlan0" ]; then
                                                        sudo ifconfig wlan0 down
                                                else
                                                        echo "Invalid interface!"
                				fi #end of 3rd if statement

					else
						echo "Invalid option!"
					fi #end of 1st if statement
			;;

			'Change IP')
				read -p "Enter an IP address to set to a network card of your choice" ip
				read -p "Enter the network card you like to set this IP to" netCard
				setIP(){
					sudo ip addr add "$ip"/24 dev "$netCard"
				}
				if [[ "${netCard,,}" == "$Ethernet" ]] || [ "$netCard" == "eth0" ]; then
					$(setIP "$ip" "$netCard")
						ifconfig | awk 'NR==2 {print "Ethernet IP Address: "$2}'
				elif [[ "${netCard,,}" == "Local loopback" ]] || [ "$netCard" == "lo" ]; then
                        		$(setIP "$ip" "$netCard")
						ifconfig | awk 'NR==8 {print "Local Loopback IP Address: "$2}'
				elif [[ "${netCard,,}" == "Wifi" ]] || [[ "${netCard,,}" == "Internet" ]] || [ "$netCard" == "wlan0" ]; then
					$(setIP "$ip" "$netCard")
						ifconfig | awk 'NR==18 {print "Wifi IP Address: "$2}'
				else
					echo "Invalid IP or network card!"
				fi
			;;

			'Wifi Connections')
				if [ -e /usr/bin/nmcli ]; then
					nmcli dev wifi
				else
					read -p "To use this service, you need the network manager package installed on your $(uname -n) system. Would you like proceed installing the package? [y/n]" answer
					if [[ "${answer,,}" == "y" ]]; then
						sudo apt install network-manager #installing package
						sudo systemctl start NetworkManager #starting up service
						sudo systemctl enable NetworkManager #enabling it
						nmcli dev wifi #showing nearby networks
					elif [[ "${answer}" == "n" ]]; then
						echo "This package needs to be installed in order for you to manage your processes!!!"
					else
						echo "Invalid option!"
					fi
				fi
				echo "Connected Network:"
				nmcli connection show --active
				read -p "Would you like to connect to a different network? [y/n]" answer
				if [[ "${answer,,}" == "y" ]]; then
					read -p "Enter the name of the network you would like to connect to" network_name
					nmcli device disconnect wlan0
					nmcli connection up "$network_name"
				elif [[ "${answer}" == "n" ]]; then
					echo "The network will remain unchanged"
				else
					echo "Invalid option!"
				fi
			;;

			'Back To Main Menu')
				echo "Heading back to main menu..."
				break
			;;

			*)
				echo "Invalid option!"
			;;

		esac

		done
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
                        user_id=$(gprep -u "$username")
                        if [ -n "$user_id"]; then
                        sudo kill -9 "$user_id"
                        echo "user $username has been disconnected"
                        else
                        echo "There is no active $username"
                        fi
                }
                list_user_groups()
                {
                        read -p "Enter username to view groups: " username
                        groups "$username"
                }
                change_user_group()
                {
                        read -p "Username to change user group: " username
                        read -p "Primary group to change into: " group
                        sudo usermod -g "$group" "$username"
                        echo "The primary group for $username is now $group"
                }
        ;;



	 Services)
                show_services()
                {
                        echo "List of current servuces that are on the system:"
                        systemctl list-units --type=service --state=running
                }

                start_services()
                {
                        read -p "Enter name of the service that you want to start: " service
                        sudo systemctl start "$service"
                        if [ $? -eq 0 ]; then
                        echo "Service $service started successfully"
                        else
                        echo "Failed to start the service $service "
                        fi
                }

                stop_services()
                {
                        read -p "Enter the name of the service that you want to stop: " service
                        sudo systemcl stop "$service"
                        if [ $? -eq 0]; then
                        echo "service $service stopped"
                        else
                        echo "The attempt to stop the service failed, pleae try again"
                        fi
                }

        ;;

	
	'File Management')
		echo "Welcome to the File Management menu! What can we do for you? "
		select FMWidget in 'Check user and file' 'Display 10 largest files' 'Display 10 oldest files' 'Send email' 'Back To Main Menu'
        do
        	
		case $FMWidget in
	
			'Check user and file')	
				read -p "Enter a username: " username

				grep "$username" /etc/passwd #Checks if the username exists

				if [ $? -eq 0 ]
				then
					echo "User exists."
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

			'Display 10 largest files')	
				#Display the 10 largest files in user's home directory
				echo "Here are the 10 largest files of home directory- "
				du -a /home | sort -n -r | head -n 10

			;;

			'Display 10 oldest files')
				#Display the 10 oldest filesin user's home directory
				echo "Here are the 10 oldest files of home directory- "
				find /home/ -type f -printf '%T+ %p\n' | sort | head -n 10
			;;

			'Send email')
				read -p "Enter a email address: " email
				read -p "Enter a file name you want to send: " filename

				echo "Email from Linux" | mail -s "Project email" -A "$filename" "$email"
	
				if [ $? -eq 0 ]; then
	 				echo "email has been sent successfully"
				else
					echo "error!!!"
				fi
			;;

			'Back To Main Menu')
                echo "Heading back to main menu..."
                break
            ;;

            *)
                echo "Invalid option!"
            ;;

        esac

        done
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
