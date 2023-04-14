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
#head -n 4923 metadata.tsv | tail -n 7 | lees

# Check some lines and paste them on a file
#head -n 4923 metadata.tsv | tail -n 7 > error.txt
# Open the file
#gedit error.txt

# Paste it on libre office and look for bugs.



