##############################################
### This script produces a simple ROC plot ###
##############################################

# Define Ground truth and predictions.
GroundTruth <- c("Benign", "Pathogenic", "Benign", "Benign", "Pathogenic", "Pathogenic")
Prediction <- c(0.1, 0.4, 0.35, 0.8, 0.9, 0.7)
dataDF <- data.frame(cbind(GroundTruth, Prediction))

# Sort file by descending score.
dataDF = dataDF[order(dataDF$Prediction, decreasing = TRUE),]
print(dataDF)
# Initialize vectors to store TPR and FPR at coordinates 0,0.
TPR <- c(0)
FPR <- c(0)

# Loop through the rows.
for (i in 1:nrow(dataDF)){
  print(dataDF[i,])
  
  # Set each i score as a threshold.
  threshold <- dataDF$Prediction[i]
  # Calculate TP, FP, TN and FN.
  TP <- sum(dataDF$GroundTruth != "Benign" & dataDF$Prediction >= threshold)
  FP <- sum(dataDF$GroundTruth == "Benign" & dataDF$Prediction >= threshold)
  TN <- sum(dataDF$GroundTruth == "Benign" & dataDF$Prediction < threshold)
  FN <- sum(dataDF$GroundTruth != "Benign" & dataDF$Prediction < threshold)
  
  # Append TPR and FPR.
  tpr <- TP / (TP + FN)
  fpr <- FP / (FP + TN)
  TPR <- c(TPR, tpr)
  FPR <- c(FPR, fpr)
}

# Plot the ROC plot.
plot(FPR, TPR, type = "b", col = "darkblue")
abline(coef = c(TPR[1],1-TPR[1])) # Diagonal with intercept at lower left corner and slope of ratio of increase between two axis.

