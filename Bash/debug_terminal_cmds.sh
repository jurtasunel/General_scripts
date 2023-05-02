#!/bin/bash

# Check if a specific character is on a file.
#cat {file_name} | grep \{character}
#cat metadata.tsv | grep \%
#cat metadata.tsv | grep £

# Check only some lines on terminal startin from the first one.
# head - n {number_of_lines} {file_name}
# Check only some lines on terminal startin from the last one.
# tail - n {number_of_lines} {file_name}

# Check only few few lines anywehere on the file.
#head -n 4923 metadata.tsv | tail -n 7
# Do it on full terminal screen (exit pressing q).
#head -n 4923 metadata.tsv | tail -n 7 | less

# Check some lines and paste them on a file
#head -n 4923 metadata.tsv | tail -n 7 > error.txt
# Open the file
#gedit error.txt

# Count lines of file.
#wc -l {file_name}
# Count how many lines have a specific string.
#cat {file_name} | grep "{string}" | wc -l
# Print all lines with a substring on it on terminal
#cat {file_name} | grep "{string}"

# Replace all occurences on a file.
#sed -i 's/{string_to_replace}/{replacement}/g' {file_name}


# > overwrittes, >> appends and | pipes it to annother function.

# Paste it on libre office and look for bugs.


# To kill process from terminal.
#top # shows top processes and memory
#k {terminal ID} # kills specific process.
#9 # execute the kill order.

# Additionally, to check that all process has terminated, run the following.
#ps ax | grep "rstudio"


### Recover data from disk trash.
# Display disk usage "human" readable.
#df -h
# Display "all" files, also hidden ones, with numeric data.
#ls -nah
# Display disk space.
#du -h .Trash-1000/files/Old_Dell
# Copy recursive from one location to another.
#cp -r .Trash-1000/files/Old_Dell ~/Desktop/Old_Dell_recovered
# Secure copy from another computer. Requires computer name and IP. "./" will copy it with the origin name.
#scp -r gabriel@137.43.96.123:/home/gabriel/Desktop/Old_Dell_recovered ./
# To get IP:
#ifconfig
# the IP is the number after the "inet" under "eno1"	
