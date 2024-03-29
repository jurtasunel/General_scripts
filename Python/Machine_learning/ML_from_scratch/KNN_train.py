####################################################
#### Machine Learning From Scratch course ####
####################################################

### Lesson 1: KNN training dataset.

### Libraries.
import numpy as np
from sklearn import datasets
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from KNN import KNN

cmap = ListedColormap(["#FF0000", "#00FF00", "#0000FF"])

iris = datasets.load_iris()
X, y = iris.data, iris.target

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 1234)

plt.figure()
plt.scatter(X[:,2], X[:,3], c = y, cmap = cmap, edgecolors = "k", s = 20)
#plt.show()

# Create a classifier and make a prediction.
clf = KNN(k = 5)
clf.fit(X_train, y_train)
predictions = clf.predict(X_test)

print(predictions)

# Check accurazy of prediction.
acc = np.sum(predictions == y_test) / len(y_test)
print(acc)
