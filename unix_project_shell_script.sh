#!/bin/bash

read -p "Welcome to $(whoami), what service can we provide for you? "
	select choice in 'System Status' Backup Network 'User Management' Services 'File Management' Exit
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
		read -p "Enter date and time: " date
		read -p "Enter a file name: " file
		read -p "Enter a designated directory: " directory
		read -p "Enter an address to backup this file: " address
		if [ ! -f $file ]; then
 			echo "File doesn't exist!!!"
 		exit 1
		fi
		if [ ! -d $directory ]; then
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
		read -p "Welcome to the Network menu! What would you like to do?"
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

Services)
;;

'User Management')
;;

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
