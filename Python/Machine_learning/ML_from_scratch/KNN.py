####################################################
#### Machine Learning From Scratch course ####
####################################################

### Documentation ###
# Youtube playlist: https://www.youtube.com/watch?v=p1hGz0w_OCo&list=PLcWfeUsAys2k_xub3mHks85sBHZvg24Jd
# Course github: https://github.com/AssemblyAI-Examples/Machine-Learning-From-Scratch

### Lesson 1: KNN (K Nearest Neighbours) algorithm.

### Libraries
import numpy as np
from collections import Counter

# Define euclidian distante function:
def euclidean_distance(x1, x2):
    distance = np.sqrt(np.sum((x1 - x2)**2))
    return distance

# Define the KNN algorithm as a class with a k (number of neighbour points), a fit function and a prediction function.
class KNN:
    def __init__(self, k = 3):
        self.k = k
        
    def fit(self, X, y):
        self.X_train = X
        self.y_train = y        
        
    def predict(self, X):
        predictions = [self._predict(x) for x in X]
        return predictions
    
    def _predict(self, x):
        # Compute the distances.
        distances = [euclidean_distance(x, x_train) for x_train in self.X_train]
        
        # Get the closest k point.
        k_indices = np.argsort(distances)[:self.k]
        k_nearest_labels = [self.y_train[i] for i in k_indices]
        
        # Return the majority vote.
        most_common = Counter(k_nearest_labels).most_common()
        return most_common[0][0]
