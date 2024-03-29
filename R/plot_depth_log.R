# This script reads in the depth.txt file and a reference (fasta and gff) to produce depth plots.
# The gff reference needs to be manually cleaned for plotting.

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
reference_path = "/home/josemari/Desktop/Jose/Reference_sequences/Herpesvirus/Herpesvirus3"
reference <- read.fasta(paste0(reference_path, "/NC_023677.1.fasta"), as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)
ref_gff <- read.table(paste0(reference_path, "/NC_023677.1.gff3"), sep = "\t", header = FALSE, stringsAsFactors = FALSE, quote = "")
# Load the dept.txt file.
depth_file_path = "/home/josemari/Desktop/Jose/Projects/Illumina_taxonomy/Results/09022023_NetoVir/Extract6_S6_L001_result/NC_001798.2_alignment/Extract6_S6_L001_depth.txt"
depth_file <- read.table(depth_file_path,  sep = '\t', header = FALSE)
colnames(depth_file) <- c("Chromosome", "nt_pos", "depth")

### Workflow:
# Re-scale the depth to logarithmic scale and add it as a column.
depth_file$log_depth <- ifelse(depth_file$depth > 0, log10(depth_file$depth), depth_file$depth)
# Add a depth score.
depth_score <- c()
for (i in 1:nrow(depth_file)){
  if (depth_file$depth[i] < 11){
    depth_score <- c(depth_score, "0-10X")
  } else if(depth_file$depth[i] < 31){
    depth_score <- c(depth_score, "11-30X")
  } else{depth_score <- c(depth_score, ">30X")}
}
depth_file <- cbind(depth_file, depth_score)

# Plot depth with ggplot.
p <- ggplot(depth_file, aes(x = nt_pos, y = log_depth, fill = depth_score)) +
  geom_bar(stat = "identity") + # Fill identity for ggplot to accept the y axis data on geom bar.
  theme_minimal() + # Remove background grid.
  scale_fill_manual(values = c("#339966", "#CC0033", "#3333FF")) +
  theme(legend.position = "top") 
p

ggsave("depth_ggplot.pdf", p, width = 10, height = 10, dpi = 10, limitsize = FALSE)

# Plot depth manually.
# Clean the gff strings on V9 for plotting.
clean_gff <- ref_gff

# Draw an empty plot with the bottom-left and top-right points:
x <- c(-150, nchar(reference[[names(reference)]]) + 150) # x limit depends on the length of the genome.
y <- c(-2, max(depth_file$log_depth) + 1) # y limit depends on the highest log depth.
plot(x = x, y = y, col = "white", xlab = "Genomic position", ylab = "log(Depth)") # yaxt = "n"

# Plot a rectangle for the genome at -0.2 height with text in the middle.
draw_rectangle(-0.2, nchar(reference[[names(reference)]]), -0.2, -0.4, "darkblue")
text(nchar(reference[[names(reference)]])/2, -0.7, names(reference), cex = 0.8, col = "black")

# Plot rectangles for each protein on the gff:
for (i in 1:nrow(clean_gff)){
  start <- clean_gff$V4[i]
  end <- clean_gff$V5[i]
  name <- clean_gff$V9[i]
  draw_rectangle(start, end, -1.2, -1, "lightblue")
  #text((start + (end - start)/2), -1.3, name, cex = 0.6, srt = 0) # srt rotates the text from 0 to 360 clockwise.
}

# Plot dots for each depth.
points(x = depth_file$nt_pos, y = depth_file$log_depth, pch = 1, cex = 0.1)

# Get the start and end of the sections with non zero depth and their average depth on a list:
flag <- FALSE;
sections <- list()
i.block <- 1
# Loop through the depth file rows.
for (i in 1:nrow(depth_file)){
  # Get the block name based on the length of the sections list.
  block.name = as.character(i.block);
  
  # If the depth is non zero and the flag is false:
  if (depth_file$depth[i] != 0 && flag == FALSE){
    # Add a new list with the block name to the section list.
    sections[[block.name]] = list();
    # Add the start position, end position and depth to the new list.
    sections[[block.name]]$x1 <- depth_file$nt_pos[i];
    sections[[block.name]]$x2 <- depth_file$nt_pos[i];
    sections[[block.name]]$avr_depth <- c(depth_file$depth[i]);
    # Update the flag.
    flag = TRUE;
    
    # If the depth is non zero and the flag is true:
    }else if(depth_file$depth[i] != 0 && flag == TRUE){
      # Update the end position with the current position and append the average depth.
      sections[[block.name]]$x2 <- depth_file$nt_pos[i];
      sections[[block.name]]$avr_depth <- c(sections[[block.name]]$avr_depth, depth_file$depth[i]);
      
      # If the depth is zero and the flag is true:
      }else if(depth_file$depth[i] == 0 && flag == TRUE){
        # Make the media for the average depth to summarize it, update the i.block and update the flag.
        flag = FALSE
        sections[[block.name]]$avr_depth <- median(sections[[block.name]]$avr_depth)
        i.block <- i.block + 1;
  }
}

# Plot rectangles for each item on the section
for (i in sections){
  i.start <- i$x1
  i.end <- i$x2
  i.depth <- i$avr_depth
  color <- c()
  if (i.depth < 51){color <- "darkred"}
  else if(i.depth < 151){color <- "blue"}
  else if(i.depth > 150){color <- "green"}
  draw_rectangle(i.start, i.end, 0.2, 0.3, color)
}
# Plot legend.
draw_rectangle(100000, 110000, 3.5, 3.6, "darkred")
text(105000, 3.3, "0-50X", cex = 0.7)
draw_rectangle(120000, 130000, 3.5, 3.6, "blue")
text(125000, 3.3, "51-150X", cex = 0.7)
draw_rectangle(140000, 150000, 3.5, 3.6, "green")
text(145000, 3.3, ">150X", cex = 0.7)

### EnterovirusA gff NC_038306.1 clean up:
#clean_gff <- ref_gff
#row_to_drop <- c()
#for (i in 1:nrow(clean_gff)){
#  i.string <- clean_gff$V9[i]
#  if (grepl("Parent=cds", i.string)){
#    new_str <- inbetween_str(i.string,left_str = "product=", right_str = " protein;")
#    clean_gff$V9[i] <- new_str
#  } else{row_to_drop <- c(row_to_drop, i)}
#}
#clean_gff <- clean_gff[-row_to_drop,]
#clean_gff <- rbind(ref_gff[2,], clean_gff, ref_gff[16,])
#clean_gff$V9[1] <- gsub(clean_gff$V9[1], "5'UTR", clean_gff$V9[1])
#clean_gff$V9[nrow(clean_gff)] <- gsub(clean_gff$V9[nrow(clean_gff)], "3'UTR", clean_gff$V9[nrow(clean_gff)])

### EnterovirusB gff NC_038307.1 clean up.
#clean_gff <- ref_gff
#row_to_drop <- c()
#for (i in 1:nrow(clean_gff)){
#  if (clean_gff$V4[i] == clean_gff$V5[i]){
#    row_to_drop <- c(row_to_drop, i)
#  }
#}
#clean_gff <- clean_gff[-row_to_drop,]
#clean_gff <- rbind(ref_gff[2,], ref_gff[8,], ref_gff[71,])
#clean_gff$V9 <- c("5'UTR", "D1P32_gp1", "3'UTR")

### EnterovirusA NC_030454.1 clean up.
#clean_gff <- ref_gff
#row_to_drop <- c()
#for (i in 1:nrow(clean_gff)){
#  i.string <- clean_gff$V9[i]
#  if (grepl("Parent=cds", i.string)){
#    new_str <- inbetween_str(i.string,left_str = "product=", right_str = ";")
#    print(new_str)
#    if (grepl("capsid protein ", new_str)){new_str <- gsub("capsid protein ", "", new_str)}
#    clean_gff$V9[i] <- new_str
#  } else{row_to_drop <- c(row_to_drop, i)}
#}
#clean_gff <- clean_gff[-row_to_drop,]
#clean_gff <- rbind(ref_gff[2,], clean_gff, ref_gff[16,])
#clean_gff$V9[1] <- gsub(clean_gff$V9[1], "5'UTR", clean_gff$V9[1])
#clean_gff$V9[nrow(clean_gff)] <- gsub(clean_gff$V9[nrow(clean_gff)], "3'UTR", clean_gff$V9[nrow(clean_gff)])
#clean_gff$V9[6] <- gsub("protease ", "", clean_gff$V9[6])


