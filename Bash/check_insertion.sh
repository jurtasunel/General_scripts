#!/bin/bash
### This script aligns fastq files with bowtie2 and produces a text file with unmapped reads, a text file with depth information, ggplot of the depth and a csv file with low depth positions.
### This script requires an indexed reference genome and the Rscript plot_depth.R.

# Create a variable to store the reference path. Requires a previously created reference with bowtie2-build.
reference="/home/josemari/Desktop/Jose/fix_fastqs/Wendy_Brennan/OneDrive_1_19-12-2022/Insertions_check/episeq_cns"

# Get the name of the fastq files and the episeq consensus.
rawfastq_tag="episeq_as_ref"
Fw="N623_S3_L001_R1_001.fastq.gz"
Rv="N623_S3_L001_R2_001.fastq.gz"

#COMANDS
#Indexing
#bowtie2-build '$param.ref' sarscov
# Align the input file to the reference with bowtie2 and write out a txt documment with unnaligned reads.
echo Aligning ${Fw} ${Rv} with bowtie2...
bowtie2 -x ${reference} -1 ${Fw} -2 ${Rv} -S ${rawfastq_tag}.sam
# Convert the sam to bam file and remove sam file.
echo Converting sam to bam file...
samtools view -b ${rawfastq_tag}.sam > ${rawfastq_tag}.bam
rm ${rawfastq_tag}.sam
# Sort the sam file and remove unsorted bam.
echo Sorting bam file...
samtools sort ${rawfastq_tag}.bam -o ${rawfastq_tag}_srtd.bam
rm ${rawfastq_tag}.bam
# Index the sorted bam file.
echo Indexing bam file...
samtools index ${rawfastq_tag}_srtd.bam
# Get depth information to text file and remove bam files.
echo Getting depth from bam file...
samtools depth -a -H ${rawfastq_tag}_srtd.bam -o ${rawfastq_tag}_depth.txt


