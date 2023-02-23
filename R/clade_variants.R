### This script reads in a msa fasta and produces a report with the variants between different clades.
### The reference is expected to be the first sequence of the fasta file.
### The different clades must be manually defined.
### Ideally, phylotree_from_msa.R or another visualization should be run on the msa prior to this script to define the clades.

# Libraries:
library(seqinr)
library(dplyr)
library(ape)

# Get path to alignment fasta.
fasta_path = "/home/josemari/Desktop/Jose/Projects/AAV2/AAV2_mafft_aligned.fasta"
# Read in the fasta with seqinr.
aligned_fasta <- read.fasta(fasta_path, as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)
# Read in the fasta with ape.
ape_fasta = read.dna(fasta_path, format = "fasta", as.matrix = TRUE, as.character = TRUE)

# Unlist the sequences.
unlisted_seqs <- list()
for (i in 1:length(aligned_fasta)){
  i.name <- names(aligned_fasta)[i]
  i.seq <- aligned_fasta[[i]]
  unlisted_seqs[i.name] <- strsplit(i.seq, "")
}
# Save the reference.
reference <- unlisted_seqs[1]
ref_lenght <- length(reference[[names(reference)]])

# Separate the samples of different clades.
clade1 <- list("OP019744.1" = unlisted_seqs[["OP019744.1"]],
               "OP019745.1" = unlisted_seqs[["OP019745.1"]],
               "OP019749.1" = unlisted_seqs[["OP019749.1"]])
clade2 <- list("OP019746.1" = unlisted_seqs[["OP019746.1"]],
               "OP019742.1" = unlisted_seqs[["OP019742.1"]],
               "OP019743.1" = unlisted_seqs[["OP019743.1"]],
               "OP019747.1" = unlisted_seqs[["OP019747.1"]])
clade3 <- list("OP019741.1" = unlisted_seqs[["OP019741.1"]],
               "OP019748.1" = unlisted_seqs[["OP019748.1"]])
clades <- list("clade1" = clade1,
               "clade2" = clade2,
               "clade3" = clade3)

# Make a consensus sequence for each clade.
# Loop through the clade names.
for (i in 1:length(clades)){
  # Save the current clade on a temporal variable.
  i.clade <- clades[[i]]
  # Make an empty vector to store the consensus of each clade.
  i.clade.cons <- c()
  
  # Loop through the nucleotide positions.
  for (j in 1:ref_lenght){
    # Make an empty vector to store the different nucleotides for each position.
    j.nt <- c()
    
    # Loop through the names of the current clade.
    for (k in names(i.clade)){
      # Get the nucleotide of each sequence and append it to the j.nt vector.
      k.nt <- i.clade[[k]][j]
      j.nt <- c(j.nt, k.nt)
    }
    # Get the most frequent string of the nucleotide vector.
    freq_table <- table(j.nt)
    most_freq_nt <- names(freq_table)[freq_table == max(freq_table)]
    # Remove "-" and "n" if they are one of the most common variants.
    if ("-" %in% most_freq_nt){
      index_to_remove <- grep("-", most_freq_nt)
      most_freq_nt <- most_freq_nt[-index_to_remove]
    } 
    if ("n" %in% most_freq_nt){
      index_to_remove <- grep("n", most_freq_nt)
      most_freq_nt <- most_freq_nt[-index_to_remove]
    }
    # Add an "n" if there are no frequent nucleotides.
    if (length(most_freq_nt) == 0){
      most_freq_nt <- "n"
    }
    # Paste all elements of equal frequencies to the same string.
    if (length(most_freq_nt) != 1){
      most_freq_nt <- paste(most_freq_nt, collapse = "/")
      }

    # Append the consensus vector with the most frequent nucleotide.
    i.clade.cons <- c(i.clade.cons, most_freq_nt)
  }
  
  clades[[names(clades)[i]]]$cons <- i.clade.cons
}

# Make a list to store the variants for each clade.
variants <- setNames(vector(mode = "list", length = length(names(clades))), names(clades))
# Loop through the reference positions.
for (i in 1:ref_lenght){
  
  # Loop through the clades.
  for (j in 1:length(clades)){
    # Get the current clade and nucleotide of the consensus sequence.
    j.clade <- names(clades)[j]
    j.cons.nt <- clades[[j]]$cons[i]
    
    # If the current position is different between the clade consensus and the reference, and is not an n:
    if (j.cons.nt != reference[[names(reference)]][i] && j.cons.nt != "n"){
      # Construct the mutation string and append it to the variants list.
      ref_nt <- reference[[names(reference)]][i]
      var_str <- paste0(i, ref_nt, ">", j.cons.nt)
      variants[[j.clade]] <- c(variants[[j.clade]], var_str)
    }
  }
}

# Make a vector to store the variants repeated between clades.
rep_var <- c()
# Pairwise loop through the clades.
for (i in 1:(length(variants) - 1)){
  for (j in (i+1):length(variants)){
    # Append the repeated variants vector with the intersects of the clades.
    rep_var <- c(rep_var,intersect(variants[[i]], variants[[j]]))
  }
}
# Remove duplicates of rep variants.
rep_var <- unique(rep_var)

# Make a vector for the unique variants.
unique_vars <- variants
# Loop through the clades in variants.
for (i in 1:length(unique_vars)){
  # Get the indices of the repeated variants and remove it.
  index_to_remove <- which(unique_vars[[i]] %in% rep_var)
  unique_vars[[i]] <- unique_vars[[i]][-index_to_remove]
}
unique_vars
# Mannually check positions in unique_vars
# Get column position.
#ape_fasta[,1223]
# Get genetic distance/identity
# Typical model is T93, 
#dist.dna(as.DNAbin(ape_fasta), model = "raw")
# One column per nucleotide, so ncol to get genome length.
#ncol(ape_fasta)
# Total length multiplied by genetic distance between seq and reference gives the number of expected mutations.






