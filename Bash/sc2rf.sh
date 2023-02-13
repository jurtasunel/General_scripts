#!/bin/bash

### Documentation: https://github.com/lenaschimmel/sc2rf

# Download all files of the github repository.
#gwet https://github.com/lenaschimmel/sc2rf/archive/refs/heads/main.zip

# Usage: the input file has to be a mafft alignment fasta with the potential recombinant fasta sequence aligned to the reference sequence.
#python3 sc2rf.py <input_file>


### Samtools mpileup/vcf Documentation: https://samtools.sourceforge.net/mpileup.shtml
### More bcftools docs: https://samtools.github.io/bcftools/howtos/variant-calling.html

reference="/home/josemari/Desktop/Jose/Reference_sequences/MN908947.fasta"
file_location="/home/josemari/Desktop/Jose/Recombinants_analysis/Karen_Johnston_12012023/bam_files"

#bcftools mpileup -f ${reference} alignments.bam | bcftools call -mv -Ob -o calls.bcf

for file in ${file_location}/*; do

  echo "Calling variants for ${file##*/}"
  bcftools mpileup -f ${reference} ${file##*/} | bcftools call -mv -Ov -o ${file##*/}.vcf
  
done


