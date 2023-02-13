# This script plots different amplicons over the genome and the CSD under the genome.
# It takes as inputs a reference.fasta, a reference.gff (for the ORFs notation) and a primer.bed file (for the amplicons position).

### Libraries:
library(seqinr)
library(ggplot2)

### Functions:
# Function to extract sub string between left and right strings.
inbetween_str <- function(input_str, left_str, right_str){
  
  # Construct the pattern to match in-between string. The ? will match only the first match.
  pattern <- paste0(".*", left_str, "(.*?)", right_str, ".*")
  # Extract and return the in-between string.
  result <- gsub(pattern, "\\1", input_str)
  return(result)
}
# Function to draw polygon using four x-y coordinates.
draw_rectangle <- function(x_start, x_end, y_start, y_end, colour){
  
  # 
  polygon(x = c(x_end, x_start, x_start, x_end),  # Top right, top left, bottom left, bottom right. 
          y = c(y_end, y_end, y_start, y_start),
          col = colour)
  
}

### Load sequences:
reference_path = "/home/josemari/Desktop/Jose/Reference_sequences/AAV2/NC_001401.2"
reference <- read.fasta(paste0(reference_path, ".fasta"), as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)
ref_gff <- read.table(paste0(reference_path, ".gff3"), sep = "\t", header = FALSE, stringsAsFactors = FALSE, quote = "")
# Load primers bed.
primers_bed_path = "/home/josemari/Desktop/Jose/Projects/AAV2/AAV2_primers.csv"
primers_bed <- read.csv(primers_bed_path, header = TRUE, stringsAsFactors = FALSE)
# Rename bed columns.
colnames(primers_bed) <- c("V1", "Start", "End", "Name", "V5", "V6", "Sequence")

### Workflow:
# Subset the gff to drop the CDS lines and only retain the gene lines.
ref_gff <- ref_gff[grepl("ID=gene", ref_gff$V9) == TRUE,]
# Drop unnecessary columns and rename existing columns.
ref_gff <- ref_gff[-c(1:3, 6, 8)]
colnames(ref_gff) <- c("Start", "End", "Strand", "Name")
# Replace the name column with only the gene name using regular expression.
ref_gff$Name <- gsub(".*;Name=(.+);gbkey=.*", "\\1", ref_gff$Name)

# Make variables to store each amplicon and the pool they belong to.
amplicon <- c()
pool <- c()
# Loop through the bed rows.
for (i in 1:nrow(primers_bed)){
  # Get the amplicon from the primer name.
  pr_name <- primers_bed[i,]$Name
  ampl <- inbetween_str(pr_name, "AAV2_", "_")
  amplicon <- c(amplicon, ampl)
  # Add odd amplicons to pool 1 and even amplicons to pool 2
  if ((as.integer(ampl) %% 2) != 0){
    pool<- c(pool, "1")
  } else{pool <- c(pool, "2")}
}
# Bind the bed with the column amplicon and pool and reorder it based on the amplicon number.
primers_bed <- cbind(primers_bed, amplicon, pool)
primers_bed <- primers_bed[order(as.integer(primers_bed$amplicon)),]

# Make lists to store the start and end position of the amplicons corresponding to the same pool.
pool_1 <- list()
pool_2 <- list()
pool_alt <- list()
# Make a counter for each amplicon.
last_amplicon <- 0
# Loop through the primer bed rows.
for (i in 1:nrow(primers_bed)){
  
  # Get the current amplicon.
  new_amplicon <- primers_bed$amplicon[i]
  
  # Do only if the amplicon is different than the previous one. 
  if (new_amplicon != last_amplicon){
    
    # Subset the bed to extract all primers of the current amplicon.
    current_primers <- primers_bed[primers_bed$amplicon == new_amplicon,]
    
    # Get start and end position and the pool.
    start_pos <- current_primers[grepl("_LEFT$", current_primers$Name) == TRUE, "Start"] # Regex "$" will only match "LEFT/RIGHT" and nothing after it.
    end_pos <- current_primers[grepl("_RIGHT$", current_primers$Name) == TRUE, "End"] # "^" is the regex equivalent for nothing before.
    current_pool <- unique(current_primers$pool)
    # Append the corresponding pool with the primer positions pair.
    if (current_pool == 1){pool_1[[new_amplicon]] <- c(start_pos, end_pos)
    } else{pool_2[[new_amplicon]] <- c(start_pos, end_pos)}
    
    # Count how many primers are for the current amplicon.
    n_primers <- nrow(current_primers)
    
    # If there are 3 and one of the is the alternative left:
    if ((n_primers == 3) & length(grep("_LEFT_alt", current_primers$Name))){
      
      # The start position becomes the start of the alternative left. End position remains the same for this amplicon.
      start_pos <- current_primers[grepl("_LEFT_alt", current_primers$Name) == TRUE, "Start"]
      # Append the alternative pool.
      pool_alt[[new_amplicon]] <- c(start_pos, end_pos)
    
    # If there are 3 and one of the is the alternative right:
    } else if ((n_primers == 3) & length(grep("_RIGHT_alt", current_primers$Name))){
      
      # The end position becomes the end of the alternative right. Start position remains the same for this amplicon.
      end_pos <- current_primers[grepl("_RIGHT_alt", current_primers$Name) == TRUE, "End"]
      # Append the alternative pool.
      pool_alt[[new_amplicon]] <- c(start_pos, end_pos)
      
    # If there are 4 primers:
    } else if (n_primers == 4){
      
      # Get the two start and two end positions.
      start_pos <- current_primers[grepl("_LEFT$", current_primers$Name) == TRUE, "Start"]
      end_pos <- current_primers[grepl("_RIGHT$", current_primers$Name) == TRUE, "End"]
      start_alt <- current_primers[grepl("_LEFT_alt", current_primers$Name) == TRUE, "Start"]
      end_alt <- current_primers[grepl("_RIGHT_alt", current_primers$Name) == TRUE, "End"]
      
      # Append the alternative pool with all the combinations.
      pool_alt[[paste0(new_amplicon, "_1")]] <- c(start_alt, end_pos)
      pool_alt[[paste0(new_amplicon, "_2")]] <- c(start_alt, end_alt)
      pool_alt[[paste0(new_amplicon, "_3")]] <- c(start_pos, end_pos)
      pool_alt[[paste0(new_amplicon, "_4")]] <- c(start_pos, end_alt)
    }
  }
  
  # Update the last amplicon.
  last_amplicon <- new_amplicon
}



# Make lists to store the start and end position of the amplicons corresponding to the same pool.
pool_1 <- list()
pool_2 <- list()
# Make a counter for each amplicon.
last_amplicon <- 0
# Loop through the primer bed rows.
for (i in 1:nrow(primers_bed)){
  
  # Get the current amplicon.
  new_amplicon <- primers_bed$amplicon[i]
  # Do only if the amplicon is different than the previous one. 
  if (new_amplicon != last_amplicon){
    
    # Subset the bed to extract all primers of the current amplicon.
    current_primers <- primers_bed[primers_bed$amplicon == new_amplicon,]
    print(current_primers$Name)
    # Get start and end position and the pool.
    start_pos <- current_primers[grepl("_F$", current_primers$Name) == TRUE, "Start"] # Regex "$" will only match "LEFT/RIGHT" and nothing after it.
    end_pos <- current_primers[grepl("_R$", current_primers$Name) == TRUE, "End"] # "^" is the regex equivalent for nothing before.
    current_pool <- unique(current_primers$pool)
    # Append the corresponding pool with the primer positions pair.
    if (current_pool == 1){pool_1[[new_amplicon]] <- c(start_pos, end_pos)
    } else{pool_2[[new_amplicon]] <- c(start_pos, end_pos)}
    
    # Count how many primers are for the current amplicon.
    n_primers <- nrow(current_primers)
  }
  
  # Update the last amplicon.
  last_amplicon <- new_amplicon
}




# Draw an empty plot with two points being -100,-1 and 30000,4.
plot(x = c(-100,5000), y = c(-1,4), col = "white", xlab = "Genomic position", ylab = "Pools", yaxt = "n") 

# Plot a rectangle for the genome at 0 height with text in the middle.
draw_rectangle(0, nchar(reference$NC_001401.2), 0,0.2, "darkblue")
text(nchar(reference$NC_001401.2)/2, 0.4, "NC_001401.2", cex = 0.7, col = "black")

# Plot rectangles under x = 0 for the ORFs with the gff information.
for (i in 1:nrow(ref_gff)){
  start <- ref_gff$Start[i]
  end <- ref_gff$End[i]
  draw_rectangle(start, end, -0.6, -0.2, "lightblue")
  #text((start + (end - start)/2), -0.8, ref_gff$Name[i], cex = 0.6, srt = -320) # srt rotates the text from 0 to 360 clockwise.
  
}

# Plot small rectangles for the different pools.
for (i in 1:length(pool_1)){
  start <- pool_1[[i]][1]
  end <- pool_1[[i]][2]
  draw_rectangle(start, end, 1.5, 1.55, "green")
  text((start + (end - start)/2), 1.65, names(pool_1)[i], cex = 0.6)
}
for (i in 1:length(pool_2)){
  start <- pool_2[[i]][1]
  end <- pool_2[[i]][2]
  draw_rectangle(start, end, 2, 2.05, "red")
  text((start + (end - start)/2), 2.15, names(pool_2)[i], cex = 0.6)
}
for (i in 1:length(pool_alt)){
  start <- pool_alt[[i]][1]
  end <- pool_alt[[i]][2]
  draw_rectangle(start, end, 2.5, 2.55, "yellow")
}








