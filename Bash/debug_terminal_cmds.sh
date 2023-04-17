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



