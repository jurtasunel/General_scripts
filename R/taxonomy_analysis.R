library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(ggrepel)
library(taxonomizr) # Manage ncbi taxonomy files as data bases for fast output.
# Documentation: https://cran.r-project.org/web/packages/taxonomizr/readme/README.html
# taxonomizr only needs to be set up once, then it functions can be used.

# accessionTaxa_sql_path = "/home/josemari/Desktop/Jose/Projects/MetaMIX/Scripts/accessionTaxa.sql"

# Allow argument usage.
args = commandArgs(trailingOnly = TRUE)
# Print required input file if typed help.
if (args[1] == "-h" || args[1] == "help"){
  print("Syntax: Rscript.R ")
  q()
  N
}

# Get input file with depth from command line and print it.
input_file = args[1]

#datapath = "/home/josemari/Desktop/Jose/Projects/MetaMIX/Scripts"
# Prepare the taxonomizr database.
prepareDatabase('/home/josemari/Desktop/Jose/Projects/MetaMIX/Scripts/accessionTaxa.sql')

# Read in the blast output.
blastOut.default<- read.table(input_file, sep="\t", stringsAsFactors = FALSE)

# Filter the blast output to remove low length reads below 50 base pairs long.
blastOut.default <- blastOut.default[blastOut.default$V4 > 50, ]
# Get frequencies of each match and reorder the data frame.
acs_freq <- as.data.frame(table(blastOut.default$V2))
acs_freq <- acs_freq[order(-acs_freq$Freq),]
# Get the tax_ID of the accession numbers.
taxaId <- accessionToTaxa(acs_freq$Var1,"accessionTaxa.sql")
# Get the names of the organism on a variable.
taxonomy <- getTaxonomy(taxaId,'accessionTaxa.sql')
organism <- as.character(taxonomy[, "species"])
# Get the taxonomy result in a dataframe and change the columns.
tax_result <- cbind(acs_freq, taxaId, organism)
colnames(tax_result) <- c("NCBI_acs", "Frequency", "taxaID", "Organism")

# Make a plot df to summarize the tax results. Start storing the first line of the tax results.
filtered_res <- tax_result[1,]
# Loop through the lines of the data frame.
for (i in 2:nrow(tax_result)){
  current_row <- tax_result[i,]
  # If the organism on the current row already exist on tplot df:
  if (current_row$Organism %in% filtered_res$Organism){
    # Add the current frequency to the df plot frequency.
    filtered_res[filtered_res$Organism == current_row$Organism, "Frequency"] <- filtered_res[filtered_res$Organism == current_row$Organism, "Frequency"] + current_row$Frequency
  } else{
    # Add the new row to the df plot.
    filtered_res <- rbind(filtered_res, current_row)
  }
}
# Add a column with the percentage of each frequency.
filtered_res <- filtered_res %>% mutate(Percentage = 100 * Frequency/sum(Frequency))
# Write out csv with the filtered taxonomy results.
write.csv(filtered_res, file = "taxon_results.csv", row.names = FALSE)

# Start a count at 0 and get the index for the first row.
cnt <- 0
i.row = 1;
# While the count is below 95:
while (cnt < 95) {
  # Add the Percentage of the current row and update the row index.
  cnt = cnt + filtered_res[i.row, "Percentage"]
  i.row=i.row+1
}
# Make a plot df with only the top 95 representatives of the taxonomy.
plot_df <- filtered_res[1:i.row,]
# Make a row to store the "others" data.
others <- c("", sum(filtered_res$Frequency[(i.row+1):nrow(filtered_res)]), "", "Others", 100-cnt)
plot_df <- rbind(plot_df, others)
# Save the amount of rows summarized in others.
others_length <- nrow(filtered_res[(i.row+1):nrow(filtered_res),])

# Get the desired number of colours.
number_of_colors <- nrow(filtered_res)
mycolors <- colorRampPalette(brewer.pal(8, "Set2"))(number_of_colors)

# Create the pie chart:
taxon_pie <- ggplot(plot_df, aes(x="", y=Percentage, fill=Organism)) + geom_bar(stat="identity", width=1) + # basic bar plot.
  coord_polar("y", start=0) + geom_text(aes(label = paste0(round(as.numeric(Percentage), 2), "%")), position = position_stack(vjust = 0.5)) + # Circular coord and labels. 
  theme_void() +
  labs(x = NULL, y = NULL, fill = NULL) +
  scale_fill_manual(values = mycolors, breaks = as.character(plot_df$Organism)) +  # Rearrange legend on decreasing freq.
  labs(caption = (paste0("*There are ", others_length, " organisms grouped in 'Others'"))) +
  theme(plot.margin = unit(c(10,5,10,5), "mm"))

ggsave("taxon_piechart.pdf", taxon_pie, width = 10, height = 10, dpi = 10, limitsize = FALSE)


