### This script gets a fasta file and metadata files from GSAID and defines a set of primers to compare against specific lineages to find mutations.
### It returns a list with the mutations of the lineages that land on the annealing sequence for the primers.
### The primers and sequences to select from the GSAID files can be manually changed.

### Libraries.
library(seqinr) # package for handling fasta files into R.
library(readODS) # package to read ods libreoffice files into R.
library(seqinr)

# Make function that returns the reverse complement sequence.
reversecomp <- function(nt_seq){
  # Make list to change nucleotide to its complement.
  nt_change <- list("A"="T", "a"="t", "T"="A", "t"="a", "G"="C", "g"="c", "C"="G", "c"="g", "-"="-", "N"="N", "n"="n")
  
  # Create vector to store complement.
  complement_seq <- c()
  # Separate the input seq into individual characters.
  nt_seq <- unlist(strsplit(nt_seq, ""))

  # Loop through the characters of the input seq starting from the last one.
  for (i in length(nt_seq):1){
    # Get the corresponding complement nucleotide.
    complement_nt <- nt_change[nt_seq[i]]
    # Concatenate the new nucleotide to the complement sequence.
    complement_seq <- paste0(complement_seq, complement_nt)
  }
  # Return the complement sequence.
  return(complement_seq)
}

# Set working dir to tests folder.
setwd("/home/gabriel/Desktop/Jose/Tests")

### Load data.
# Read in any GSAID fasta file and metadata file with a set of lineages containing a sequence of xbb and ba.2.75 lineage.
datapath = "/home/gabriel/Desktop/Jose/Projects/Lineage_changes/Data/"
fasta_path = paste0(datapath, list.files(datapath, ".fasta"))
fasta_file <- read.fasta(fasta_path, as.string = TRUE, forceDNAtolower = FALSE, set.attributes = FALSE)
metadata_path = paste0(datapath, list.files(datapath, "A.tsv"))
metadata_file <- read.table(metadata_path,  sep = "\t", header = TRUE, stringsAsFactors = FALSE)
# Load the reference fasta.
reference_file <- read.fasta("/home/gabriel/Desktop/Jose/Reference_sequences/Covid/MN908947.fasta", as.string = TRUE, forceDNAtolower = FALSE, set.attributes = FALSE)
# Change names of fasta IDs. 
for (i in 1:length(fasta_file)) {names(fasta_file)[i] <- unlist(strsplit(names(fasta_file)[i], "|", fixed = TRUE))[2]}

# Get the primers details. The reverse primers must be reverse complemented to be on 5`-3` direction on the reference forward strain.
F_13 <- c(3683, 3705, "SARS-CoV-2_13_LEFT", "AGCACGAAGTTCTACTTGCACC")
R_13 <- c(4067, 4093, "SARS-CoV-2_13_RIGHT", reversecomp("GATGTCAATGTCACTAACAAGAGTGG"))
F_41 <- c(12234, 12255, "SARS-CoV-2_41_LEFT", "ATTTGACCGTGATGCAGCCAT")
R_41 <- c(12618, 12643, "SARS-CoV-2_41_RIGHT", reversecomp("AAGAGGCCATGCTAAATTAGGTGAA"))
F_52 <- c(15535, 15557, "SARS-CoV-2_52_LEFT", "CTGTCACGGCCAATGTTAATGC")
R_52 <- c(15917, 15941, "SARS-CoV-2_52_RIGHT", reversecomp("GGATCTGGGTAAGGAAGGTACACA"))
F_72 <- c(21532, 21561, "SARS-CoV-2_72_LEFT", "GTGATGTTCTTGTTAACAACTAAACGAAC")
R_72 <- c(21904, 21933, "SARS-CoV-2_72_RIGHT", reversecomp("GTAGCGTTATTAACAATAAGTAGGGACTG"))
F_73 <- c(21865, 21889, "SARS-CoV-2_73_LEFT", "AGAGGCTGGATTTTTGGTACTACT")
R_73 <- c(22247, 22274,	"SARS-CoV-2_73_RIGHT", reversecomp("ACCTAGTGATGTTAATACCTATTGGCA"))
F_74 <- c(22091, 22113,	"SARS-CoV-2_74_LEFT", "TGGACCTTGAAGGAAAACAGGG")
R_74 <- c(22474, 22503,	"SARS-CoV-2_74_RIGHT", reversecomp("TGATAGATTCCTTTTTCTACAGTGAAGGA"))
F_75 <- c(22402, 22428,	"SARS-CoV-2_75_LEFT", "GAAAATGGAACCATTACAGATGCTGT")
R_75 <- c(22785, 22805,	"SARS-CoV-2_75_RIGHT", reversecomp("TTTGCCCTGGAGCGATTTGT"))
F_76 <- c(22648, 22677, "SARS-CoV-2_76_LEFT", "GCTGATTATTCTGTCCTATATAATTCCGC")
F_76alt <- c(22742, 22774, "SARS-CoV-2_76_LEFT_alt1", "ATGTCTATGCAGATTCATTTGTAATTAGAGGT")
R_76 <- c(23028, 23057,	"SARS-CoV-2_76_RIGHT", reversecomp("GTTGGAAACCATATGATTGTAAAGGAAAG"))
R_76alt <- c(23120, 23141, "SARS-CoV-2_76_RIGHT_alt1", reversecomp("GTCCACAAACAGTTGCTGGTG"))
F_77 <- c(22944, 22974,	"SARS-CoV-2_77_LEFT", "CAAACCTTTTGAGAGAGATATTTCAACTGA")
R_77 <- c(23327, 23351,	"SARS-CoV-2_77_RIGHT", reversecomp("CACTGACACCACCAAAAGAACATG"))
F_78 <- c(23219, 23246, "SARS-CoV-2_78_LEFT", "CTGAGTCTAACAAAAAGTTTCTGCCTT")
R_78 <- c(23611, 23635, "SARS-CoV-2_78_RIGHT", reversecomp("GGATTGACTAGCTACACTACGTGC"))
F_79 <- c(23553, 23575,	"SARS-CoV-2_79_LEFT", "ACCCATTGGTGCAGGTATATGC")
R_79 <- c(23927, 23955,	"SARS-CoV-2_79_RIGHT", reversecomp("CCAAAATCTTTAATTGGTGGTGTTTTGT"))
R_79alt <- c(23914, 23944, "SARS-CoV-2_79_RIGHT_alt1", reversecomp("AATTGGTGGTGTTTTGTAAATTTGTTTGAC"))
F_80 <- c(23853, 23876,	"SARS-CoV-2_80_LEFT", "CCGTGCTTTAACTGGAATAGCTG")
R_80 <- c(24233, 24258,	"SARS-CoV-2_80_RIGHT", reversecomp("GCAAATGGTATTTGTAATGCAGCAC"))

### Workflow.
# Make data frame with all the primers
primers_df <- data.frame(rbind(F_13,R_13,F_41,R_41,F_52,R_52,F_72,R_72,F_73,R_73,F_74,R_74,F_75,R_75,F_76,F_76alt,R_76,R_76alt,F_77,R_77,F_78,R_78, F_79, R_79, R_79alt, F_80, R_80), stringsAsFactors = FALSE)
colnames(primers_df) <- c("start", "end", "artic_V4.1_name", "seq")
# Change seq to lowcase to match lowcase fasta.
primers_df$seq <- tolower(primers_df$seq)

# Write fasta with one lineage of each and the reference.
write.fasta(sequences =  c(fasta_file$EPI_ISL_16428403, fasta_file$EPI_ISL_16428367, reference_file), names = c("XBB.1.5", "BE.9", "MN908947.3"), file.out = "ref_appended.fasta")

# Run mafft and read in the aligned fasta
system("mafft --auto --reorder ref_appended.fasta > mafft_aligned.fasta")
aligned_fasta <- read.fasta("mafft_aligned.fasta", as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)

# List to store the final primers and lineages with their mutations.
mut_primers <- list()
# Loop through the lineages on the fasta file.
for (i in 1:length(aligned_fasta)){
  # Loop through the primer sequences.
  for (j in 1:nrow(primers_df)){
    # If a primer sequence is not in the lineage sequence:
    if (grepl(primers_df$seq[j], aligned_fasta[i]) == FALSE){
      
      # Save the primer name and lineage name.
      primer_name <- primers_df$artic_V4.1_name[j]
      lin_name <- names(aligned_fasta[i])
      
      # Store the current primer, the start and end positions and unlist the sequences.
      current_primer <- primers_df[j,]
      start_pos <- as.integer(current_primer$start)
      end_pos <- as.integer(current_primer$end)
      unlisted_primer <- unlist(strsplit(current_primer$seq, ""))
      # Unlist the fasta sequence and get the positions that match the primer.
      unlisted_seq <- unlist(strsplit(aligned_fasta[[i]], ""))
      lineage_seq <- unlisted_seq[(start_pos+1):end_pos]
      
      # Print each iteration with its primer name and lineage, and the unlisted sequences compared.
      print(lin_name)
      print(primer_name)
      print(unlisted_primer)
      print(lineage_seq)
      
      # Make a vector to store the mutations of each lineage and primer pair.
      mutations <- c()
      # Loop through the length of the unlisted primer.
      for (k in 1:length(unlisted_primer)){
        # Find the positions that are different between the primer and the lineage sequence.
        if (unlisted_primer[k] != lineage_seq[k]){
          
          # Construct the mutation string.
          ref_nt <- toupper(unlisted_primer[k])
          snp_nt <- toupper(lineage_seq[k])
          changepos <- k + start_pos
          mutation <- paste0(changepos, ref_nt, ">", snp_nt)
          print(mutation)
          # Append the mutations vector with the current mutation.
          mutations <- c(mutations, mutation)

        }
      }
      # Append the list with the mutations of each lineage and primer pair.
      list_name <- paste0(lin_name, "_", primer_name)
      mut_primers[[list_name]] <- mutations
    }
  }
}
print(mut_primers)





