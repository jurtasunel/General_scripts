#!/bin/bash

# On one terminal window, ssh to GridION.
ssh grid@$GRU
# Go to data folder. Plate name is the same as the one on the NVRL SARS COV 2 group.
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
# Copy colums to metadata file and index link the barcodes with the metadata by the NVRL codes.

# Metadata file names?


