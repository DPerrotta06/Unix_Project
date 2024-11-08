#!/bin/bash

read -p "Welcome to $(whoami)'s raspberry pi, what service can we provide for you?"
	select choice in 'System Status' Backup Network 'User Management' 'File Management' Exit
	do
	case $choice in

'System Status')
;;

Backup)
;;

Network)
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
;;

esac

done


