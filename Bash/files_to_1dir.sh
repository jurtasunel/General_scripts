#!/bin/bash

# specify the source directory
src_dir="/home/josemari/Desktop/Jose/Projects/Illumina_taxonomy/Data/FASTQ_FOLDER"

# specify the target directory
dst_dir="${src_dir}/Test"

# create the target directory if it doesn't exist
if [ ! -d $dst_dir ]; then
  mkdir $dst_dir
fi

# loop through all subdirectories in the source directory
for dir in $(find $src_dir -type d); do

  # skip the target directory
  if [ $dir == $dst_dir ]; then
    continue
  fi

  # loop through all files in the current subdirectory
  for file in $(find $dir -type f); do
    # copy the file to the target directory
    cp $file $dst_dir
  done
done

# print confirmation message
echo "All files have been copied to $dst_dir"

