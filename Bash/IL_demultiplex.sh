#!/bin/bash

# Set the output directory for the demultiplexed data
output_dir=./demultiplexed_data

# Set the adapter and index sequences
adapter1=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
adapter2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
index1=CAAGCAGAAGACGGCATACGAGATCGGTCTCGC
index2=CTGTCTCTTATACACATCTGACGCTGCCGACGA

# Loop through the input directories
for input_dir in "$@"
do
  # Set the names of the forward and reverse reads files
  forward_reads=$input_dir/forward_reads.fastq.gz
  reverse_reads=$input_dir/reverse_reads.fastq.gz

  # Demultiplex the data using the Illumina bcl2fastq tool
  bcl2fastq --input-dir $input_dir --output-dir $output_dir \
    --adapter-sequence $adapter1 --adapter-sequence $adapter2 \
    --index-sequence $index1 --index-sequence $index2 \
    --input-file $forward_reads --input-file $reverse_reads
done




