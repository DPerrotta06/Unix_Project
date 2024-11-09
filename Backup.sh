#!/bin/bash

read -p "Enter date and time: " date
read -p "Enter a file name: " file
read -p "Enter a designated directory: " directory
read -p "Enter a address to backup this file: " address

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

echo "Last backup has been done on $date successfully."
