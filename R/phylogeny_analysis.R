#### This script runs a phylogenetic analysis and produces a results directory containing:
# 1: Phylogenetic tree pdf file.
# 2: A csv file with repoting metadata from the target sequences.
# 2: Two csv files containing the nucleotide differences between the sequences and their genetic distance.
# 3: Multiple sequence aligment fasta file.
# 4: Phylogenetic tree raxml files.
# The script requires an existing ~/Data directory containing four files downloaded from GSAID.
# The tree shows the sequences lineages and a second label:
# By default the second label is the patients age but it can be changed manually to show other attributes.

#### Libraries
library(ggplot2)
library(ggtree)
library(treeio) # Load before seqinr to avoid "read.fasta" functions overlapping.
library(seqinr)
library(ape)
library(phangorn) # Get midpoint of tree to re root it.
library(tidytree)

#### CHANGE the analysis_tag, data_path, file_names, target_IDs and second lable according to the specific analysis.
# Get the analysis tag.
analysis_tag = "PaulGrier_SJH_03112022"
# Set data path and working directory.
data_path = "/home/gabriel/Desktop/Jose/Projects/Phylogeny_analysis/PaulGrier_SJH_03112022/Data"
setwd(gsub("Data", "", data_path))
# Make results folder.
results_dir_name <- paste0(analysis_tag, "_results")
system(paste0("mkdir ", results_dir_name))

# Get the names of the input files.
fasta_file_name = "/gisaid_hcov-19_2022_11_03_15.fasta" # Nucleotide Sequences (FASTA) from GSAID.
metadata_file_name = "/gisaid_hcov-19_2022_11_03_15.tsv" # Patient status metadata from GSAID.
#subdate_file_name = "/gisaid_hcov-19_2022_12_16_13_B.tsv" # Dates and Location from GSAID.
lab_file_name = "/1667490538436.metadata.tsv" # Input for the Augur pipeline from GSAID (It download as a .tar file and the file is the .metadata.tsv file after extraction).

# Filter for specific IDs
target_IDs <- c("EPI_ISL_15545063", "EPI_ISL_15545064", "EPI_ISL_15545065", "EPI_ISL_15545066", "EPI_ISL_15545067", "EPI_ISL_15545068", "EPI_ISL_15545069")
# Get the secondary variable label to plot.
#patient_age <- c(); for (i in 1:length(target_IDs)){patient_age<-c(patient_age, metadata_file$Patient.age[i])}
Healthcare_Setting <- c("St.Vincents_Care_centre", "St.Vincents_Care_centre", "Newbrook_Nursing_Home", "Newbrook_Nursing_Home", "Newbrook_Nursing_Home", "Hospital_Inpatient", "Hospital_Inpatient")

# Get the mafft and raxml commands. Assume that ref_appended.fasta file has already been created.
mafft_command = "mafft --auto --reorder ref_appended.fasta > mafft_aligned.fasta"
raxml_command = "/usr/bin/raxmlHPC-PTHREADS-AVX /usr/share/man/man1/raxmlHPC-PCTHREADS-AVX -T 12 -f a -x 123 -p 123 -N 100 -m GTRCAT -k -O -s mafft_aligned.fasta -n raxml_tree -w `pwd`"

#### Load files
# Load fasta file.
fasta_path = paste0(data_path, fasta_file_name)
fasta_file <- read.fasta(fasta_path, as.string = TRUE, forceDNAtolower = FALSE, set.attributes = FALSE)
# Rename fasta file names.
for (i in 1:length(fasta_file)){names(fasta_file)[i] <- unlist(strsplit(names(fasta_file)[i], "|", fixed = TRUE))[2]}
# Load metadata_files.
metadata_path = paste0(data_path, metadata_file_name)
metadata_file <- read.table(metadata_path,  sep = '\t', header = TRUE, stringsAsFactors = FALSE)
#subdate_path = paste0(data_path, subdate_file_name)
#subdate_file <- read.table(subdate_path, sep = "\t", header = TRUE, stringsAsFactors = FALSE, quote = "£")
lab_path = paste0(data_path, lab_file_name)
lab_file <- read.table(lab_path,  sep = '\t', header = TRUE, stringsAsFactors = FALSE, quote = "£")
# Load reference file sequence.
reference_path = "/home/gabriel/Desktop/Jose/Reference_sequences/Covid/MN908947.fasta"
reference_file <- read.fasta(reference_path, as.string = TRUE, forceDNAtolower = FALSE, set.attributes = FALSE)

#### Workflow:
# Subset the files to get only the data linked with the target IDs.
metadata_file <- metadata_file[metadata_file$Accession.ID %in% target_IDs,]
lab_file <- lab_file[lab_file$gisaid_epi_isl %in% target_IDs,]
fasta_file <- fasta_file[target_IDs]
# Append the reference for mafft.
ref_appended <- c(fasta_file, reference_file)
write.fasta(sequences =  ref_appended, names = names(ref_appended), file.out = "ref_appended.fasta")

# Run mafft and raxml commands.
system(mafft_command)
system(raxml_command)

# Get lineages and accession ID for plotting.
tree_lineages <- c()
tree_IDs <- c()
for (i in 1:nrow(metadata_file)){
  tree_lineages <- c(tree_lineages, metadata_file$Lineage[i])
  tree_IDs <- c(tree_IDs, metadata_file$Accession.ID[i])
}
# Add the covid reference to all vectors.
tree_lineages <- c(tree_lineages, "MN908947.3")
tree_IDs <- c(tree_IDs, "MN908947.3")
Healthcare_Setting <- c(Healthcare_Setting, "MN908947.3")
# Make the data frame for ploting.
tree_df <- data.frame(tree_IDs, tree_lineages, Healthcare_Setting)
colnames(tree_df) <- c("Accession.ID", "Lineage", "Healthcare_Setting")
print(tree_df)

# Read tree and re root it to the reference.
tree <- read.tree(file = "RAxML_bipartitionsBranchLabels.raxml_tree")
rooted_tree <- midpoint(tree, node.labels = "support")
# Plot tree
plot_tree <- ggtree(rooted_tree) %<+% tree_df +
  geom_tiplab(aes(fill = factor(Lineage)),
              colour = "black",
              geom = "label",
              size = 3.5,
              label.padding = unit(0.2, "lines"), # amount of padding around the labels
              label.size = 0.2) + # size of label borders
  xlim(0, 0.0019) +
  guides(fill = guide_legend(title = "Lineage")) +
  geom_tippoint(aes(color = factor(Healthcare_Setting)),
                size = 3,
                alpha = 1) +
  #scale_fill_hue() +
  guides(color = guide_legend(title = "Healthcare_Setting")) +
  theme_tree2()
plot_tree
# Save the plot as a png.
ggsave("phylogenetic_tree.png", plot_tree, device = "png", height = 297, width = 210, units = "mm", dpi = 400)

# Read the mafft aligned fasta.
aligned_fasta <- read.fasta("mafft_aligned.fasta", as.string = TRUE, forceDNAtolower = TRUE, set.attributes = FALSE)
# Split all sequences on individual nt for to do the distance calculation.
for (i in 1:length(aligned_fasta)){
  aligned_fasta[[i]] <- unlist(strsplit(aligned_fasta[[i]], ""))
}
# Count nucleotide differences between sequences and raw genetic distance.
nt_diff <- dist.dna(as.DNAbin(aligned_fasta), model = "N")
gen_distance <- dist.dna(as.DNAbin(aligned_fasta), model = "raw")

# Add extra column with rownames because rownames are lost when saving the "dist" objects as tables.
nt_diff <- cbind(as.matrix(nt_diff),  rownames(as.matrix(nt_diff)))
gen_distance <- cbind(as.matrix(gen_distance), rownames(as.matrix(gen_distance)))
# Write csv files.
write.table(as.matrix(nt_diff), "nt_changes.csv", row.names = FALSE)
write.table(as.matrix(gen_distance), "genetic_distance.csv", row.names = FALSE)

# Move all files to the results directory.
system(paste0("mv genetic_distance.csv nt_changes.csv phylogenetic_tree.png mafft_aligned.fasta ref_appended.fasta *.raxml_tree ", results_dir_name))


# Read as raxml for bootstrap values.
#raxml_tree <- read.raxml("/home/gabriel/Desktop/Jose/Projects/Phylogeny_analysis/SJH_15122022/SJH_15122022_phylogeny_results/RAxML_bipartitionsBranchLabels.raxml_tree")
# Get the node of the reference to re root the tree.
#noderoot <-  nodeid(raxml_tree, "MN908947.3")
#raxml_rooted_tree <- root(raxml_tree, outgroup = noderoot)

#ggtree(raxml_rooted_tree) %<+% tree_df +
#  geom_label(aes(label=bootstrap, fill=bootstrap)) +
#  geom_tiplab() +
#  geom_tippoint(aes(color = factor(Healthcare_Setting)),
#                size = 3,
#                alpha = 1) +
#  guides(color = guide_legend(title = "Healthcare_Setting")) +
#  geom_tip (aes(color = factor(Lineage))) +
#  xlim(0, 0.0008) +
#  theme_tree2()

