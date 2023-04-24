### This script reads fasta files and does different encoding of the nucleotide strings to match Machine Learning inputs.
# SeqIO from Biopython Documentation: https://biopython.org/wiki/SeqIO
# Fasta files processing for ML: https://www.kaggle.com/code/singhakash/dna-sequencing-with-machine-learning

### Libraries:
import numpy as np
import re # Work with regular expressions.
from sklearn.preprocessing import LabelEncoder # Translate labels to values between 0 and 1.
from sklearn.preprocessing import OneHotEncoder # Transform labels to numerical arrays.
from sklearn.feature_extraction.text import CountVectorizer # Convert a collection of string documents to a matrix of token counts.
from Bio import SeqIO # Input/output fasta files.

# Load fasta file.
fasta_path = "/home/josemari/Desktop/Jose/Projects/AAV2/Data/AAV2_allsamples.fasta"
fasta_file = SeqIO.parse(fasta_path, "fasta")

# Loop through the sequences and print their Id, seq and length.
#for sequence in fasta_file:
#    print(sequence.id)
#    print(sequence.seq)
#    print(len(sequence))

### 1. Ordinal encoding of DNA sequences.
# Convert fasta string to numpy array. Returns string as an array.
def string_to_array(seq_string):
    
    # Lower case the string.
    seq_string = seq_string.lower()
    # Convert all characters that are not nucleotides to n. Use "z" for "n" because the encoding of strings will be alphabetical, so "n" wouldn't be before "t" but "z" will.
    seq_string = re.sub("[^actg]", "z", seq_string)
    # Convert the string into a numpy array.
    seq_string = np.array(list(seq_string))
    
    return seq_string

# Encode DNA array as an ordinal vector. Returns an array encoded with float values instead of itnegers. 
def ordinal_encoder(my_array):
    
    # Transform the array to integers (a, c, g, t, z to 0, 1, 2, 3, 4).
    integer_encoded = label_encoder.transform(my_array)
    # Convert the integers to float values between 0 and 1.
    float_encoded = integer_encoded.astype(float)
    float_encoded[float_encoded == 0] = 0.25 # A.
    float_encoded[float_encoded == 1] = 0.50 # C.
    float_encoded[float_encoded == 2] = 0.75 # G.
    float_encoded[float_encoded == 3] = 1.00 # T.
    float_encoded[float_encoded == 4] = 0.00 # anything else, n.
    
    return float_encoded

# Create a label encoder 
label_encoder = LabelEncoder()
label_encoder.fit(np.array(['a','c','g','t','z']))

seq_test = "AACTNGGA"
print(f"Ordinal encoding of `{seq_test}`")
print(ordinal_encoder(string_to_array(seq_test)), "\n")

### 2. One-hot encoding DNA sequences.
# Convert fasta string to one-hot numeric arrays.
def one_hot_encoder(seq_string):
    
    # Transform the dna sequence to an array of integers.
    int_encoded = label_encoder.transform(seq_string)
    # Create a one-hot object from the integer encoded array.
    onehot_encoder = OneHotEncoder(sparse = False, dtype = int)
    # Reshapes the array to a two-dimensional array with one column and as many rows as the input sequence length.
    int_encoded = int_encoded.reshape(len(int_encoded), 1)
    # Transform the integer-encoded array into a one-hot encoded matrix. 
    onehot_encoded = onehot_encoder.fit_transform(int_encoded)
    # Delete last column of the one-hot matrix because it correspond to encoding of no-standard DNA bases.
    onehot_encoded = np.delete(onehot_encoded, -1, 1)
    
    return onehot_encoded

seq_test = "tgcaccan"
print(f"One-hot encoding of `{seq_test}`")
print(one_hot_encoder(string_to_array(seq_test)), "\n")

### 3. k-mer encoding.
# Function to split string into kmers of equal lenght.
def kmers_split(seq_string, kmer_size):
    return [seq_string[x:x+kmer_size].lower() for x in range(len(seq_string) - kmer_size + 1)]

seq_test = "GTGCCCAGGTTCAGTGAGTGACACAGGCAG"
print(f"k-mer of length 7 encoding of `{seq_test}`")
print(kmers_split(seq_test, 7), "\n")

# Join the kmers again to get the sequence back.
kmers = kmers_split(seq_test, 12)
joined_kmers = " ".join(kmers)
print(f"k-mers of length 12 of {seq_test} in one joined string \n", joined_kmers, "\n")

# Split two sequences as kmers of length 6.
mySeq1 = 'TCTCACACATGTGCCAATCACTGTCACCC'
mySeq2 = 'GTGCCCAGGTTCAGTGAGTGACACAGGCAG'
sentence1 = ' '.join(kmers_split(mySeq1, 6))
sentence2 = ' '.join(kmers_split(mySeq2, 6))

# Transform the two kmers splitted sentences to a binary array.
cv = CountVectorizer()
X = cv.fit_transform([sentence1, sentence2]).toarray()

print(f"k-mers of length 6 of {mySeq1} and {mySeq2} transformed to binary arrays")
print(X, "\n")


