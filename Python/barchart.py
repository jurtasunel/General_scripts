
### Libraries.
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

### Read csv function. Return dictionary.
def read_csv(path_to_file):

    # Open the file on reading mode.
    f = open(path_to_file, "r")
    # Skip header.
    header = f.readline()

    # Create lists to return.
    csv_dict = {}
    # Fill the dictionary.
    for line in f:
        
        line = line.strip().split(",")
        # Gene names are keys, l2fc and pval are values.
        csv_dict[line[0]] = line[1:]
    
    # Close file.
    f.close()

    return csv_dict

### Define variables.
file_name = "/home/josemari/Desktop/phoPR_lastDraft/Transcriptomics/supplementary_data.csv"
csv_dict = read_csv(file_name)

# Convert dictionary to pandas DF and drop rows with NA values.
data_df = pd.DataFrame.from_dict(csv_dict, orient = "index", columns = ["l2fc", "padj"])
data_df.dropna()
# Add column with gene names, now they are the index of the data frame.
data_df["Locus_tag"] = data_df.index

# Remove last row, which has phoP.
#data_df.drop(data_df.tail(1).index,inplace=True) # drop last n rows

# print(data_df.head, "\n")
# print(data_df.info(), "\n")
# print(data_df.shape, "\n")
print(data_df)

# Convert data from string to float.
data_df["l2fc"] = data_df["l2fc"].astype(float)
# Subset dataframe for 1.5 l2fc
data_df = data_df[(data_df["l2fc"] <= -1) | (data_df["l2fc"] >= 1)]
# Add color column.
data_df["color"] = ["red" if data_df.loc[i, "l2fc"] <= -1 else "green" for i in data_df.index]

red_patch = mpatches.Patch(color='red', label='Downregulated in Dpho')
green_patch = mpatches.Patch(color='green', label='Upwnregulated in Dpho')
ax = data_df.plot.barh(x = "Locus_tag", y = "l2fc", fontsize = 5, color = data_df["color"], legend = False)
plt.xlabel('Log2 fold change', fontsize = 12)
plt.ylabel('Locus_tag', fontsize = 12)
plt.legend(handles=[red_patch, green_patch])

plt.show()   

