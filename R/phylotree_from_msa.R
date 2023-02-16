### This script makes a phylogenetic tree from a multiple sequence alignment fasta.
### The first sequence should be the reference sequence.

# Libraries:
library(ape)
library(TreeTools)

# Get the location of the alignment fasta.
fasta_path <- "/home/josemari/Desktop/Jose/Projects/AAV2/AAV2_mafft_aligned.fasta"
# Read in the file and get the reference.
aln <- read.dna(fasta_path, format = "fasta")
reference <- aln[1,]
reference_label <- rownames(reference)

# Make a tree using neighbor-joining method
tree <- nj(dist.dna(aln))
# Root the tree to the reference.
rooted_tree <- RootTree(tree, reference_label)

# Get the tip labels
labels <- rownames(aln)

# Colour the reference blue and the other sequences red
tip.colours <- c("darkblue", rep("darkred", (length(labels) - 1)))

# Calculate pairwise distances between tips
distances <- cophenetic(rooted_tree)
# Make a sequence between the minimun and maximun for plotting evenly spaced axis tips.
dist_axes <- round(seq(min(distances), max(distances), by = max(distances)/5), 3)

# Plot the tree with coloured tip labels and genetic distance on x-axis
plot(rooted_tree, tip.color = tip.colours, cex = 0.75, align.tip.label = TRUE)
axis(side = 1, at = dist_axes, labels = TRUE, tick = TRUE, xlim = range(distances), cex.axis = 0.8)










