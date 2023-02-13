library(seqinr)
library(ggplot2)
library(stringr)

fasta_path = "/home/josemari/Desktop/Jose/Tests/pango.fasta"
fasta_file <- read.fasta(fasta_path, as.string = TRUE, forceDNAtolower = FALSE, set.attributes = FALSE)

### Quality filter:
# Make vectors to store the coverage of each sequence, and coverage and ID of low coverage sequences.
nt_perc <- c()
low_quality_seqs_ID <- c()
low_quality_seqs_Nperc <- c()
# Loop through the fasta file.
for (i in 1:length(fasta_file)){
  
  N_perc <- (str_count(fasta_file[[i]], pattern = "N") * 100) / nchar(fasta_file[[i]])
  nt_perc <- c(nt_perc, (100 - N_perc))
  # If N percentage is higher than 20, get the value and the Id to separate vectors.
  if (N_perc > 20){
    low_quality_seqs_ID <- c(low_quality_seqs_ID, names(fasta_file)[i])
    low_quality_seqs_Nperc <- c(low_quality_seqs_Nperc, N_perc)
  }
}
# Make a dataframe to plot the coverage of all IDs
df_plot_quality <- data.frame(names(fasta_file), nt_perc)
colnames(df_plot_quality) <- c("Accession_ID", "Coverage")
# Plot barplot
quality_plot <- ggplot(df_plot_quality, aes(x = Accession_ID, y = Coverage)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  geom_hline(yintercept = 80, color = "red") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  theme(axis.title.y = element_text(),
        axis.text.y = element_text(size = 9),
        axis.ticks.y = element_line(),
        axis.title.x = element_text(),
        axis.text.x = element_text(angle = 90, size = 0.8)) +
  ggtitle("Quality filter: Coverage > 80%") +
  theme(plot.title = element_text(hjust = 0.5, size = 15, face = "bold")) +
  labs(caption = paste0("Sequences excluded from analysis: ", length(low_quality_seqs_Nperc)))

quality_plot
