### This script gets coverage % of an alignment from a depth.txt file. Depth file has three columns (Chromosome, Position, Depth).

### Libraries:


### Functions:
perc_coverage <- function(depth_table){
  
  # Get nrow of depth table, which is the length of the genome.
  genlength <- nrow(depth_table)
  print(paste0("Genome length: ", genlength))
  
  # Get the number of positions that have a depth different than 0, and the ones over 30X.
  covbases <- length(which(depth_table$Depth != 0))
  cov30X <- length(which(depth_table$Depth >= 30))
  
  # Make the percentages and return them.
  covbases_per <- 100 * covbases / genlength
  cov30X_per <- 100 * cov30X / genlength
  cov_df <- data.frame(covbases,covbases_per, cov30X, cov30X_per)
  
  # Print informative message.
  print(cat("Total bases covered at lest 1X:", covbases, "\n1X % :", covbases_per, "\nTotal bases over 30X:", cov30X, "\n30X %:", cov30X_per))
  
  return(cov_df)
}


### Load data:
data_path = "/home/josemari/Downloads/A1_Extract_1_S1_L001_depth.txt"
depth_table <- read.table(data_path,  sep = '\t', header = FALSE)

# Rename columns.
colnames(depth_table) <- c("Chrom", "Position", "Depth")
# Call the percentage coverage function. 
perc_coverage(depth_table)
