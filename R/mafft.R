### This script takes the path of a reference and a fasta file and aligns them using mafft.
### The output is a {tag}_mafft_aligned.fasta. The {tag} needs to be defined.

### Libraries
library(seqinr)

### Variables:
reference_path = "/home/josemari/Desktop/Jose/Reference_sequences/AAV2/NC_001401.2.fasta"
reference <- read.fasta(reference_path, as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)
# Read in fasta to align.
fasta_path = "/home/josemari/Desktop/Jose/Reference_sequences/AAV2/AAV2_GenBank.fasta"
fasta_file = read.fasta(fasta_path, as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)
# Get tag of input file.
input_tag = "AAV2"
# Get the mafft terminal command.
mafft_command = paste0("mafft --auto --reorder ", input_tag, "_fasta_to_align.fasta > ", input_tag, "_mafft_aligned.fasta")

### Workflow:
# Make an empty list to store the sequences.
sequences <- list()
# Add the reference as first element, and append it with all the sequences on the fasta file.
sequences[[names(reference)]] <- reference$NC_001401.2
for (i in 1:length(fasta_file)){sequences[[names(fasta_file)[i]]] <- fasta_file[[names(fasta_file)[i]]]}
# Get the names of the referenc eand the fasta file on a vector.
seqnames <- c(names(reference), names(fasta_file))
# Write out the fasta file to align.
fasta_to_align <- write.fasta(sequences = sequences, names = seqnames, file.out = paste0(input_tag, "_fasta_to_align.fasta"))

# Run mafft.
system(mafft_command)



  
write.fasta(sequences = list(reference[[names(reference)]], x[["EPI_ISL_16615442"]], x[["EPI_ISL_16474040"]], x[["EPI_ISL_16579329"]]), names = c("MN908947", "EPI_ISL_16615442", "EPI_ISL_16474040", "EPI_ISL_16579329"), file.out = "xbb_1_5.fasta")

  
  