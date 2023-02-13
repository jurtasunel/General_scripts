library(seqinr)

# Read in the FASTA file and create a DNAbin object
alignment_path <- "/home/josemari/Desktop/Jose/fix_fastqs/Wendy_Brennan/OneDrive_1_19-12-2022/N623_S3_L001_results/mafft_aligned.fasta"
aligned_fasta <- read.fasta(alignment_path, as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)
# Change names of second a third seqs, the first one is the reference.
names(aligned_fasta)[2] <- "samtools_cns"
names(aligned_fasta)[3] <- "episeq_cns"

# Extract the seqs from the alignment file.
ref_seq <- unlist(strsplit(aligned_fasta[[1]], ""))
samtools_cns <- unlist(strsplit(aligned_fasta[[2]], ""))
episeq_cns <- unlist(strsplit(aligned_fasta[[3]], ""))

# Make a vector to store the different positions.
nt_changepos <- c()
ref_nt <- c()
samtools_nt <- c()
episeq_nt <- c()

for (i in 1:nchar(aligned_fasta[[1]])){
  
  if (ref_seq[i] != samtools_cns[i]){
    
  }
}



