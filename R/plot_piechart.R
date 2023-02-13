# Libraries:
library(ggplot2)
library(RColorBrewer)

# Path to data.
datapath <- "/home/josemari/Desktop/Jose/Projects/Illumina_taxonomy/Results/09022023_NetoVir/Extract8_S8_L001_result/taxon_results.csv"
data_df <- read.csv(datapath, stringsAsFactors = FALSE)

# Summarize the data for plotting. All organisms tha represent less than 1% are grouped in "others".
summary_data <- data_df[data_df$Percentage > 1,]
summary_data <- summary_data[order(-summary_data$Percentage),]
others_data <- data_df[data_df$Percentage < 1,]
others <- c("", sum(others_data$Frequency), "", "others", sum(others_data$Percentage))
summary_data <- rbind(summary_data, others)

# Get the desired number of colours.
number_of_colors <- nrow(summary_data)
mycolors <- colorRampPalette(brewer.pal(8, "Set2"))(number_of_colors)

# Create the pie chart:
taxon_pie <- ggplot(summary_data, aes(x="", y=Percentage, fill=Organism)) + geom_bar(stat="identity", width=1) + # basic bar plot.
  coord_polar("y", start=0) + geom_text(aes(x = 1.1, label = paste0(round(as.numeric(Percentage), 2), "%")),  # x defines the text distance from the center. 
                                        position = position_stack(vjust = 0.5),
                                        check_overlap = TRUE) + # If labels overlap, don't plot them.
  theme_void() +
  labs(x = NULL, y = NULL, fill = NULL) +
  scale_fill_manual(values = mycolors, breaks = as.character(summary_data$Organism)) +  # Rearrange legend on decreasing freq.
  labs(caption = (paste0("*There are ", nrow(others_data), " organisms with less than 1% representation grouped in 'Others'"))) +
  theme(plot.margin = unit(c(10,5,10,5), "mm"))
taxon_pie

ggsave("taxon_piechart.pdf", taxon_pie, width = 10, height = 10, dpi = 10, limitsize = FALSE)
