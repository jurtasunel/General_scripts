### This script reads in an fmt6 output from blastn 

library(R.utils) # Required to decompress .gz files by microseq readFastq.
library(microseq) # Read in fastq files.
library(seqinr)

### Read inputs:
# Allow argument usage.
args = commandArgs(trailingOnly = TRUE)
# Print required input file if typed help.
if (args[1] == "-h" || args[1] == "help"){
  print("Syntax: Rscript.R paired_end_merged.fastq")
  q()
  N
}

input_file = args[1] # consensus_genomes.fasta.

# Read fastq
fastq <- readFastq(input_file)

# Write fasta
writeFasta(fastq, out.file = "pefq_merged.fasta")

# Get read length and wirth requried for later metamix.
pefq_details <- data.frame(cbind(header = fastq$Header, read.lengths = nchar(fastq$Sequence), read.weights = 1))
# Rename to math output of blast.
for (i in 1:nrow(pefq_details)){pefq_details$header[i] <- unlist(strsplit(pefq_details$header[i], " "))[1]}
write.csv(pefq_details, "pefq_details.csv", row.names = FALSE)

#fastq_test <- readFastq("/home/josemari/Desktop/Jose/Projects/MetaMIX/Scripts/out.extendedFrags.fastq")



