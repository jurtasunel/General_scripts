#!/bin/bash

# Specify the directory to list files.
data_path="/home/josemari/Desktop/Jose/Projects/Illumina_taxonomy/Data"
Rscripts_path="/home/josemari/Desktop/Jose/General_scripts/R"
query_ID="TESTING"

export BLASTDB=/home/josemari/Desktop/Jose/Reference_sequences/Reference_virus_DB/ref_viruses_rep_genomes
# Prefix of the database
blastN_db="ref_viruses_rep_genomes"

data_path="/home/josemari/Desktop/Jose/Tests/taxonomy_test"
# strings to remove
Fr_suffix="_R1_001.fastq.gz"
Rv_suffix="_R2_001.fastq.gz"

# create an associative array to store the extracted strings
declare -A files_hash

# loop through the files in the directory
for file in "$data_path"/*; do
  # remove the string if it exists in the file name
  if [[ $file == *"$F_suffix"* ]]; then
    filename="${file/$Fr_suffix/}"
    files_hash["$(basename "${filename}")"]=1
  elif [[ $file == *"$Rv_suffix"* ]]; then
    filename="${file/$Rv_suffix/}"
    files_hash["$(basename "${filename}")"]=1

  fi
done

# create an array to store the unique extracted strings
files=("${!files_hash[@]}")
echo -e "Fastq tags: ${files[@]}\n"

# loop through the array of unique extracted strings
for i in "${files[@]}"; do
  echo -e "Merging ${i}${Fr_suffix} ${i}${Rv_suffix} with flash...\n"
  flash ${data_path}/${i}${Fr_suffix} ${data_path}/${i}${Rv_suffix}
  
  echo -e "Calling merge_fastq.R for ${i} to produce ${i}.fasta...\n"
  Rscript ${Rscripts_path}/merge_fastq.R `pwd`/out.extendedFrags.fastq
  
  echo -e "Blasting ${i} with blastn...\n"
  blastn -db ${blastN_db} -query pefq_merged.fasta -outfmt "6 qaccver saccver pident length mismatch gapopen qstart qend sstart send evalue bitscore slen" -max_target_seqs 10 -out blastn_output.tab
  
  echo -e "Calling taxonomy_analysis.R...\n"
  Rscript taxonomy_analysis.R `pwd`/blastn_output.tab
  
done
