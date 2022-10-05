#!/bin/bash

#Create an array with the files tags.
tags=("R1" "R2" "R3" "R4" "R5" "R6" "R7" "R8" "R9" "R10" "R11" "R12")

#Create variables to store the forward and reverse reads suffixes.
Fsuffix="_1.fq.gz"
Rsuffix="_2.fq.gz"

#FASTQC
Loop through the tags.
for tag in "${tags[@]}";
do
	#Print the current iteration tag.
	echo "Creating fastqc report, curren iteration is "$tag
	#Run fastqc on each forward and reverse reads file.
	fastqc "$tag$Fsuffix" "$tag$Rsuffix"
done

#CUTADAPT
#Loop through the tags.
for tag in "${tags[@]}";
do
	#Print current iteration tag.
	echo "Triming, curren iteration is "$tag
	#Run cutadapt.
	cutadapt --cut 16 -U 16 --quality-cutoff 25,25 --minimum-length 75 -o "$tag"_trimmed_1.fastq -p "$tag"_trimmed_2.fastq "$tag$Fsuffix" "$tag$Rsuffix"
done

#Create a variable to store$t the reference path. Requires a previously created reference with bowtie2-build.
reference="/home/josemari/phoPR_analysis/Mbovis_reference_genome/Bovis"

#Loop through the tags.
for tag in "${tags[@]}";
do
	#Print the current iteration tag.
	echo "Aligning, current iteration is "$tag
	
	#Create and print Forward and Reverse files names.
	Ffile="$tag"_trimmed_1.fastq
	Rfile="$tag"_trimmed_2.fastq
	echo "Fr file: "$Ffile
	echo "Rv file: "$Rfile

	#COMANDS
	#Align the files to the reference with bowtie2 for the current iteration.
	bowtie2 -x "$reference" -1 "$Ffile" -2 "$Rfile" -S "$tag".sam
	#Convert the sam file produced into a bam file using samtools view.
	samtools view -b "$tag".sam > "$tag".bam
	#Create variable for the sort command.
	sort="sort"
	#Sort the sam file using samtools sort.
	samtools $sort "$tag".bam -o "$tag"srtd.bam
	#Index the sorted bam file with samtools index
	samtools index "$tag"srtd.bam
done	
