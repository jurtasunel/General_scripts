# Libraries
library(ggplot2)
library(ggtree)
library(treeio) # Load before seqinr to avoid "read.fasta" functions overlapping.
library(seqinr)
library(ape)
library(phangorn) # Get midpoint of tree to re root it.

# Load fasta files and metadata files.
fasta_path = "/home/gabriel/Desktop/Jose/Projects/GISAID_reports/Data/PaulGrier_03112022/gisaid_hcov-19_2022_11_03_15.fasta"
fasta_file <- read.fasta(fasta_path, as.string = TRUE, forceDNAtolower = FALSE, set.attributes = FALSE)
reference_path = "/home/gabriel/Desktop/Jose/Reference_sequences/Covid/MN908947.fasta"
reference_file <- read.fasta(reference_path, as.string = TRUE, forceDNAtolower = FALSE, set.attributes = FALSE)
# Load metadata_files.
metadata_path = "/home/gabriel/Desktop/Jose/Projects/GISAID_reports/Data/PaulGrier_03112022/gisaid_hcov-19_2022_11_03_15.tsv"
metadata_file <- read.table(metadata_path,  sep = '\t', header = TRUE, stringsAsFactors = FALSE)
lab_path = "/home/gabriel/Desktop/Jose/Projects/GISAID_reports/Data/PaulGrier_03112022/gisaid_auspice_input_hcov-19_2022_11_03_15/1667490538436.metadata.tsv"
lab_file <- read.table(lab_path,  sep = '\t', header = TRUE, stringsAsFactors = FALSE, quote = "£")
# Rename fasta file names.
for (i in 1:length(fasta_file)){
  names(fasta_file)[i] <- unlist(strsplit(names(fasta_file)[i], "|", fixed = TRUE))[2]
}
# Filter for specific IDs
target_IDs <- c("EPI_ISL_15545063", "EPI_ISL_15545064", "EPI_ISL_15545065", "EPI_ISL_15545066", "EPI_ISL_15545067", "EPI_ISL_15545068", "EPI_ISL_15545069")
Healthcare_setting <- c("St.Vincents_Care_centre", "St.Vincents_Care_centre", "Newbrook_Nursing_Home", "Newbrook_Nursing_Home", "Newbrook_Nursing_Home", "Hospital_Inpatient", "Hospital_Inpatient")
metadata_file <- metadata_file[metadata_file$Accession.ID %in% target_IDs,]
lab_file <- lab_file[lab_file$gisaid_epi_isl %in% target_IDs,]
fasta_file <- fasta_file[target_IDs]
# Append the reference for mafft.
ref_appended <- c(fasta_file, reference_file)
write.fasta(sequences =  ref_appended, names = names(ref_appended), file.out = "ref_appended.fasta")

# Run mafft and raxml commands
mafft_command = "mafft --auto --reorder ref_appended.fasta > mafft_aligned.fasta"
raxml_command = "/usr/bin/raxmlHPC-PTHREADS-AVX /usr/share/man/man1/raxmlHPC-PCTHREADS-AVX -T 12 -f a -x 123 -p 123 -N 100 -m GTRCAT -k -O -s mafft_aligned.fasta -n raxml_tree -w `pwd`"
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
Healthcare_setting <- c(Healthcare_setting, "MN908947.3")
# Make the data frame for ploting.
tree_df <- data.frame(tree_IDs, tree_lineages, Healthcare_setting)
colnames(tree_df) <- c("Accession.ID", "Lineage", "Healthcare_setting")

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
  geom_tippoint(aes(color = factor(Healthcare_setting)),
                size = 3,
                alpha = 1) +
  #scale_fill_hue() +
  guides(color = guide_legend(title = "Healthcare_setting")) +
  theme_tree2()
plot_tree

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
# Write csv files.
write.table(as.matrix(nt_diff), "nt_changes.csv", row.names = FALSE)
write.table(as.matrix(gen_distance), "genetic_distance.csv", row.names = FALSE)

system("mkdir phylogeny_results")
system("mv genetic_distance.csv nt_changes.csv phylogenetic_tree.png mafft_aligned.fasta ref_appended.fasta *.raxml_tree phylogeny_results")



