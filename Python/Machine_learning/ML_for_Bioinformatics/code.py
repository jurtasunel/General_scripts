####################################################
#### Machine learning for Bioinformatics course ####
####################################################

### Documentation ###
# Youtube playlist: https://www.youtube.com/watch?v=YIdL6sJSoGE&list=PLsSUJubNtkrCESp-eEiWayFa3vQ2VN3kK
# Machine learning data repository: http://archive.ics.uci.edu/ml/index.php
# scikit-learn: https://scikit-learn.org/stable/
# Kernels/Solvers for model regressions: https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html
# Linear regression vs Suppor Vector Machines (SVM) algorithms: https://medium.com/axum-labs/logistic-regression-vs-support-vector-machines-svm-c335610a3d16

### Explore data: Breast Cancer Winsc Data (file.data) has 11 columns, description of them is on description file (file.name).
# "4. Relevant information" shows total of 699 data values. 
# "7. Attribute information" shows column values. Col 1 for the ID, 2-10 for attributes, 11 for Clas. ML will predict a class value based on the values of the 9 attribute columns.
# "8. Missing values" shows 16 values denoted by "?".

### Libraries:
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
import pickle

### Functions:
# Define function that returns binary:
def retBin(x):
    if x == 2:
        return 0
    else:
        return 1

### Read data:
# Read data file.
data_file = "breast-cancer-wisconsin.data"
data = pd.read_csv(data_file)
# Define columns according to description file.
data.columns = ["Id","Clump_Thickness", "Uni_Size", "Uni_Shape", "Marg_Adhesion", "Epithelial_Size", "Bare_Nuclei", "Bland_Chromatin", "Normal_Nucleoli", "Mitoses", "Class"]
# Save file as csv.
data.to_csv("data.csv", index = None, header = True)

### Preprocess data:
# Read data csv file.
data_file = "data.csv"
data = pd.read_csv(data_file)
print(data.head())
# Remove Id column.
data.drop(["Id"], inplace = True, axis = 1)
# Replace missing values. Convention is -99999 for missing values.
data.replace("?", -99999, inplace = True)
# Change the class values (2 for benign, 4 for malign, by 0 and 1 respectively) because ML model requires binary notation.
#data["Class"] = data["Class"].map(retBin)
# One line-lambda function solution instead of defined function.
data["Class"] = data["Class"].map(lambda x: 0 if x == 2 else 1)
print(data.head())

### Features and Labels:
# Define X and y (Features and Label). Features are the data without the class column.
X = np.array(data.drop(["Class"], axis = 1))
print(X)
y = np.array(data["Class"])
print(y)

### Training and testing the model:
# Separate the data into training and testing data. 0.1 means means 10% of data will be used for testing and 90% for training.
[X_train, X_test, y_train, y_test] = train_test_split(X, y, test_size = 0.1, random_state = 0)

# Define a classifier and model, and check the accurazy.
# SVC model:
#Classifier = SVC(kernel = "linear")
#model = Classifier.fit(X_train, y_train)
#accu = model.score(X_test, y_test)
#print("Accuracy of SVC: ", accu)

# Logistic regression model:
#Classifier = LogisticRegression(solver = "liblinear")
#model = Classifier.fit(X_train, y_train)
#accu = model.score(X_test, y_test)
#print("Accuracy of Logistic Regression: ", accu)

### Saving and loading a model:
# Save model. We save Logistic Regression model because it has higher accuracy.
#pickle.dump(model, open("LogisticRegression.m", "wb"))
# Load model.
loaded_model = pickle.load(open("LogisticRegression.m", "rb"))
accu = loaded_model.score(X_test, y_test)
print("Accuracy of Logistic Regression: ", accu, "\n")

### Making predictions:
# Define the classes, 0 was Bening and 1 was malignant.
classes = ["Bening", "Malignant"]

# Define sample by creating array with values correspoding to the attributes matching the training data structure.
sample = np.array([[5, 1, 1, 1, 2, 1, 3, 1, 1]])
result = loaded_model.predict(sample)
# Print the result linking it with the defined classes (THEY MUST BE ON SAME ORDER). If no strings are defined for the classes, result will be only 0 or 1.
print(classes[int(result)])

sample2 = np.array([[8, 10, 10, 8, 7, 10, 9, 7, 1]])
result = loaded_model.predict(sample2)
print(classes[int(result)])


