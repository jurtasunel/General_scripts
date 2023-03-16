#!bin/bash

# This script aligns ONT reads to a refernce using minimap2 and constructs a consensus sequence. The scrips assumes that there is only one fastq.gz file per sample.

data_path="/home/josemari/Desktop/Jose/Projects/AAV2/Data/Irish_Samples"
reference="/home/josemari/Desktop/Jose/Reference_sequences/AAV2/NC_001401.2.fasta"

# Get all the file names on the data path.
files=(${data_path}/*) # files will store the full path of the directories.
# Create emtpy array to store only filenames without path extension.
file_names=() 
for i in "${!files[@]}"; do
    filename="$(basename "${files[i]}")" # Get only name without path.
    file_names+=("$filename") # Append the filenames array.
done
# Print the barcode names
echo -e "Input files: ${file_names[@]}\n"

# Loop through the input files
for i in ${file_names[@]}; do
# Align with minimap2
echo -e "Aligning ${i} to reference with minimap2...\n"
minimap2 -a ${reference} ${i} -N ${i} > ${i}.sam
# Process sam file.
echo -e "Converting sam to bam file...\n"
samtools view -b ${i}.sam > ${i}.bam
rm ${i}.sam
echo -e "Sorting bam file...\n"
samtools sort ${i}.bam -o ${i}_srtd.bam
rm ${i}.bam
# Index the sorted bam file.
echo -e "Indexing bam file...\n"
samtools index ${i}_srtd.bam
# Convert conensus fasq from bam file.
echo -e "Making fastq consensus sequence...\n"
samtools mpileup -uf ${reference} ${i}_srtd.bam | bcftools call -c | vcfutils.pl vcf2fq > ${i}_cns.fq
# Making consensus fasta from consensus fasq...
echo -e "Getting consensus fasta... Bases quality lower than 20 set to N...\n"
seqtk seq -aQ64 -q20 -n N ${i}_cns.fq > ${i}_cns.fasta
rm ${i}_cns.fq ${i}_srtd.bam.bai
# Get depth information to text file and remove bam files.
echo -e "Getting depth from bam file...\n"
samtools depth -a -H ${i}_srtd.bam -o ${i}_depth.txt
# Make directory to store results.
mkdir ${i}_results
mv ${i}_cns.fasta ${i}_depth.txt ${i}_srtd.bam ${i}_results 

done

