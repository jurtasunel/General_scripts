def create_FASTA_dictionary_from_file(file_location):

    # Create an empty dictionary that will store the IDs of the fasta format as keys and the sequences as values.
    fasta_dict = {}

    # Open the file containing the fasta sequences.
    with open(file_location) as file:

        # Loop through the lines of the file.
        for line in file:
            
            # Rise an error message if the file contains empty lines.
            if line[0] is "\n":
                raise("EMPTY LINES ARE NOT ALLOWED. PLEASE REMOVE EMPTY LINES")

            # Create lists containing all possible nucleotide and aminoacid letters.
            nt_list = ["A", "a", "G", "g", "T", "t", "C", "c", "U", "u"]
            aa_list = ["A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y"]
            # If lines don't start with a nucleotide, an aminoacid or a fasta ID, raise an error message.
            if not (line[0] is ">" or line[0] in nt_list or line[0] in aa_list):
                raise("SOME LINES ARE NOT IN FASTA FORMAT. PLEASE MAKE SURE ALL LINES START WITH >ID, NUCLEOTIDE OR AMINOACID")

            # Remove the final \n of all lines with rstrip().
            line = line.rstrip()

            # If the line starts with ">".
            if line[0] == ">":
            
                # Add the line from position 1 (the 0 is the ">") to the end as a key in the fasta dictionary
                # and asign a 0 value to it.
                fasta_dict[line[1:]] = 0
        
            else:

                # Create a variable to store the current last key of the fasta dictionary.
                last_key = list(fasta_dict.keys())[-1]

                # If the last key equals 0 (which means it has no sequence asigned as a value).
                if fasta_dict[last_key] == 0:

                    # The last key takes the line as its value.
                    fasta_dict[last_key] = line
            
                else:
                    # The last key is updated by adding the current line to its existing sequence.
                    fasta_dict[last_key] = fasta_dict[last_key] + line
    
    return(fasta_dict)
def get_gc_percentage(sequence):

    # Create a variable to store the gc count of the sequence.
    gc_count = 0

    # Loop through the nucleotides of the input sequence.
    for nt in sequence:
    
        # If a nucleotide of the sequence is a G or a C.
        if nt == "G" or nt == "g" or nt == "C" or nt == "c":

            # The gc count is updated by adding 1.
            gc_count = gc_count + 1
    
    # Get the gc percentage by dividing it by the lenght of the sequence and multiplying it by 100. 
    gc_percentage = gc_count / len(sequence) * 100

    return(gc_percentage)
def create_consensus_seq_and_nt_profile_from_fasta_dictionary(fasta_dict):

    # Find the longest fasta sequence in the dictionary.
    maximum_length = 0
    for key in fasta_dict:
        if len(fasta_dict[key]) > maximum_length:
            maximum_length = len(fasta_dict[key])

    # Create four lists for store the counts of each letter.
    A = [0]*maximum_length
    C = [0]*maximum_length
    G = [0]*maximum_length
    T = [0]*maximum_length
    
    nt_profile = {"A" : A, "C" : C, "G" : G, "T" : T}

    # Loop through the keys in the fasta dictionary.
    for key in fasta_dict:

        # Loop through the length of each sequence.
        for i in range(len(fasta_dict[key])):

            # Update each list count by adding 1 on the corresponding positon.
            if fasta_dict[key][i] == "A" or fasta_dict[key][i] == "a":
                A[i] = A[i] + 1
            elif fasta_dict[key][i] == "C" or fasta_dict[key][i] == "c":
                C[i] = C[i] + 1
            elif fasta_dict[key][i] == "G" or fasta_dict[key][i] == "g":
                G[i] = G[i] + 1
            elif fasta_dict[key][i] == "T" or fasta_dict[key][i] == "t":
                T[i] = T[i] + 1

    consensus = ""

    # Loop through the conts lists by zipping them, so each iteration will check the same position in all lists.
    for i in zip(A,C,G,T):

        # If the highest value is in the 0 index of the zipped (A, C, G, T) (meaning the first value of the A count):
        if max(i) == i[0]:

            # Add an A to the consensus sequence.
            consensus = consensus + "A"
    
        # Index 1 means the highest value is in the C count, index 2 is G and index 3 is T.
        elif max(i) == i[1]:
            consensus = consensus + "C"
        elif max(i) == i[2]:
            consensus = consensus + "G"
        elif max(i) == i[3]:
            consensus = consensus + "T"

    cons_seq_and_nt_profile = [consensus, nt_profile]

    return(cons_seq_and_nt_profile)
# Define a function that creates a list of files in a specific directory with a specific extension
def create_list_of_files(directory, extension):

    # Initialize an empty list to store the names of the files
    list_of_files = []
    
    # Loop through the elements in the directory
    for element in listdir(directory):

        # If name of the element ends with the specified extension
        if element.endswith(extension):

            # Append the list with that file
            list_of_files.append(element)
    
    return(list_of_files)

def std_jm(repl_list):

    # Get the number of replicates into a variable.
    n_repl = len(repl_list)

    # Make an array with the mean of each group or replicates. If replicates are not 3, the indices here must be changed manually.
    mean_array = (repl_list[0] + repl_list[1] + repl_list[2]) / n_repl

    # Initialize empty list for std.
    std_array = []
    
    # Loop to calculate variance of each group or replicates.
    for i, j, k, in zip(repl_list[0], repl_list[1], repl_list[2]):
        tmp_mean = (i + j + k) / 3
        tmp_var = (pow((i-tmp_mean),2) + pow((j-tmp_mean),2) + pow((k-tmp_mean),2)) / n_repl
        tmp_std = np.sqrt(tmp_var)
        std_array.append(tmp_std)
    
    return(std_array)