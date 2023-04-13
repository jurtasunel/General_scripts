#!/bin/bash

# On one terminal window, ssh to GridION.
ssh grid@$GRU
# Go to data folder. Plate name is the same as the one on the NVRL SARS COV 2 group.
# *** go to root with: cd / (NOT TO HOME, which is cd ~)
cd /data/{run_date}/{plate_name}
# In plate name there is a folder with long name, then several folders including fastq_pass.
cd */fasq_pass
# Check if there is data on any of the barcode folders.
ls */*
# If there is data, run the script on a different terminal window.

# Go to NVRL folder.
cd NVRL
# Check the script arguments.
my.getNVRL.run.sh -h
# Call the script.
my.getNVRL.run.sh {date_ddmmyy_format} {plate_name_as_in_} {machine_GRU/DRU} {hours_to_run} 
# Example.
my.getNVRL.run.sh 120423 040423_SEQ_RUN1_COSQ GRU 35

# Wait for the script to finish collecting the data. In the meantime, get the metadata redy.
# On winpath, plate map is on Q:\PSHOUTPUT\{plate_name}.txt --> Double check map with the plate picture.
# Copy file to INSEQUENCES folder and:
# 	change name to NVRL.{plate_name}.plate.txt
# 	replace all spaces with underscores
# Copy colums to metadata file
# Index link the barcodes with the metadata by the NVRL codes, which is the second column of the plate.txt map file.

# If there are empty rows with NVRL code, autocomplete rows with the formula.
# check that there are no NA or missed values etc. 

# save AS CSV with name NVRL.{one/two/trww}plate_date.metadata.csv}
# MAKE SURE IS SAVED AS CSV
# save it on INSEQUENCES, where the plate map file also is. 

# Check disk space.
df -h
# mounted on "/" --> that is root
# on GRU/DRU, check the folder "/data" has always space 

# Check how much space takes one specific folder.
du -h {folder_name}

# shows all memory, but also does pagination
cat /proc/meminfo # ram is the first row, "MemTotal"


