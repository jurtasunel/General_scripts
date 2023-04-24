### 
# Fasta files processing for ML: https://www.kaggle.com/code/singhakash/dna-sequencing-with-machine-learning

### Libraries:
import os
for dirname, _, filenames in os.walk('/kaggle/input'):
    for filename in filenames:
        print(os.path.join(dirname, filename))


