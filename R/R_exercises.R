# Programming exercises.
# Date: 15-05-19
# Due: 07-06-19
# Author: Josemari 

# Write a mean function
mean_jose <- function(vector_of_numbers){
  
  # Create a variable to store the sum of the vector of numbers
  sum_numbers <- 0
  
  # Loop through each of the numbers on the input vector of numbers
  for (number in vector_of_numbers){
    
    # Add the current number to the growing sum of numbers
    sum_numbers <- sum_numbers + number
  }
  
  # Calculate the mean of the vector of numbers
  mean_vector_of_numbers <- sum_numbers / length(vector_of_numbers)
  
  return(mean_vector_of_numbers)
} # mean

# Write a median function
median_jose <- function(vector_of_numbers){
  
  # Create variables
  numbers_sorted <- sort(vector_of_numbers)
  mid_value <- length(vector_of_numbers) / 2
  
  # Decide if the vector's lenght is even or odd and calc median for each case
  if(length(vector_of_numbers) %% 2 == 0){
    
    # Length of even numbers / 2 always gives 0.5 less than the "middle possition" 
    #  ---------------------------------------------------------------------
    # � n = 6, median = mean of 3rd and 4th value    |  |  [ | | ]  |  |   �       
    # �                                                     mean           �                           
    # �                                                                    � 
    # � 6 / 2 = 3 ;  (6 / 2) + 1 = 4                 |  |  [|] [|]  |  |   �         
    # �                                                                    �
    # ----------------------------------------------------------------------
    median_vector_of_numbers <- (numbers_sorted[mid_value] + numbers_sorted[mid_value + 1]) / 2
  }else{
    
    # Length of odd numbers / 2 always gives 0.5 less than the "middle position" 
    #  -------------------------------------------------------------
    # � n = 7, median = 4th value            |  |  | [|] |  |  |   �
    # �                                              4th           �
    # �                                                            �
    # � 7 / 2 = 3.5 ; (7 / 2) + 0.5 = 4      |  |  |[]|  |  |  |   �
    # �                                            3.5             �
    # --------------------------------------------------------------
    median_vector_of_numbers <- numbers_sorted[mid_value + 0.5]
  }
  
  return(median_vector_of_numbers)
} # median

# Write a function that returns the index of a value in a vector
indexVal_jose <- function(vector, value_in_vector, verbose = FALSE){
  
  # Define indices variable
  indices <- 1:length(vector)
  
  # Create a variable to store the indices
  indices_value_in_vector <- c()
  
  # Loop through the indices 
  for (index in 1: length(vector)){
    
    # If the input value equeals a vector value
    if(value_in_vector == vector[index]){
      
      # Append the index of that value to the indices vector
      indices_value_in_vector[length(indices_value_in_vector) + 1] <- index
    }
  }
  
  # Check if printed output requested
  if(verbose == TRUE){
    
    # Check if found once
    if(length(indices_value_in_vector) == 1){
      
      # Cat command for concatenate strings & values. \n = next line. No separation between things.
      cat("Value (", value_in_vector, ") found at index: ", indices_value_in_vector[1], "\n", sep="")
    
    # Check if found more than once
    }else if(length(indices_value_in_vector) > 1){
      cat("Value (", value_in_vector, ") found at indices: ", 
          paste(indices_value_in_vector, collapse=","), "\n", sep="")
      
    # Otherwise, not founc
    }else{
      cat("Value (", value_in_vector, ") not found.\n", sep="")
    }
  }
    
  return(indices_value_in_vector)
} # which

# Write a function that returns the maximum value of a vector of numbers
maxVal_jose <- function(vector){
  
  # Create a variable to store the maximum value of the vector
  current_max <- vector[1]
  
  # Create indices variable starting from 2, because index 1 has already been added
  indices <- 2:length(vector)
  
  #Loop through the indices
  for(index in indices){
    
    # If current vector value > than current_max, that value becomes the new maximum
    if(vector[index] > current_max){
      current_max <- vector[index]
    }
  }
  
  return(current_max)
} # max

# Write a function that returns the minimum value of a vector of numbers
minVal_jose <- function(vector){
  
  # Create a variable to store the minimum value of the vector
  current_min <- vector[1]
  
  # Create indices variable starting from 2, because index 1 has already been added
  indices <- 2:length(vector)
  
  #Loop through the indices
  for(index in indices){
    
    # If current vector value < than current_max, that value becomes the new minimum
    if(vector[index] < current_min){
      current_min <- vector[index]
    }
  }
  
  return(current_min)
} # min

# Write a function that returns the index of maximum value of a vector
indexMaxVal_jose <- function(vector){
  
  # Create variable to store the maximum value
  current_max <- vector[1]
  
  # Create vector to store the index/indices of the maximum value
  indices_of_max_value <- c(1)
  
  # Find the maximum value by looping through the indices, starting on 2 to avoid redundancy of 1st positon
  for (index in 2:length(vector)){
    
    # If vector value is higher than current maximum
    if (vector[index] > current_max){
      
      # That value becomes the new maximum and its index becomes the only value of the indices vector
      current_max <- vector[index]
      indices_of_max_value <- c(index)
      
    # If vector value equals the current maximum
    }else if(vector[index] == current_max){
      
      # Append the indices vector with the index
      indices_of_max_value[length(indices_of_max_value) + 1] <- index
    }
  }
  
  return(indices_of_max_value)
} # which.max

# Write a function that returns the index of minimum value of a vector
indexMinVal_jose <- function(vector){
  
  # Create variable to store the minimum value
  current_min <- vector[1]
  
  # Create vector to store the index/indices of the minimum value
  indices_of_min_value <- c(1)
  
  # Find the minimum value by looping through the indices, starting on 2 to avoid redundancy of 1st positon
  for (index in 2:length(vector)){
    
    # If vector value is lower than current minimum
    if (vector[index] < current_min){
      
      # That value becomes the new minimum and its index becomes the only value of the indices vector
      current_min <- vector[index]
      indices_of_min_value <- index
      
    # If vector value equals the current minimum
    }else if(vector[index] == current_min){
      
      # Append the indices vector with the index
      indices_of_min_value[length(indices_of_min_value) + 1] <- index
      }
  }
  
  return(indices_of_min_value)
} # which.min

# Write a function that returns a vector containing the values from a start index to an end index
valIndices_jose <- function(vector,start_index,end_index){
  
  # Create new vector whose 1st value is the start index value and the last one is the end index value
  new_vector_values <- vector[start_index:end_index]
  
  # Conditions that will stop the function an error message
  if (start_index > end_index){
    stop("Start_index can not be bigger than end_index")

  }else if(start_index == 0){
    stop("Start_index can not be zero")
    
  }else if(end_index > length(vector)){
    stop("end index can not be bigger than the lenght of the vector")
  }
  
  return(new_vector_values)
} # subset

# Write a function that returns a vector containing the input value repeated n times
repVal_jose <- function(input_value, n){
  
  # Stop message
  if (n <= 0){
    stop("Number_of_repeats can not be zero or negative")
  }
  
  # Initialise a vector to hold the repeated values
  repeats_vector <- c()
  
  # Append the repeats_vector n times with the input_value
  for (index in seq_len(n)){
    repeats_vector[length(repeats_vector) + 1] <- input_value
  }
  
  return(repeats_vector)
} # rep
  
# Write a function that reports the number of times each value in a vector occur
uniqValFrec_jose <- function(vector){
  
  # Create one vector that stores the unique values and another that stores their respective counts
  unique_val <- c(vector[1])
  unique_val_counts <- c(1)

  # Loop through the indices of the input vector
  for (index in 2:length(vector)){
    
    # If a vector value is found within the unique values vector
    if (vector[index] %in% unique_val){
      
      # The match function returns its first occurance in the unique values vector, and is stored in a
      a = match(vector[index], unique_val)
      
      # Index-a position in the counts vector is increased in one 
      unique_val_counts[a] = unique_val_counts[a] + 1

    # If the input vector value is not found within the uniqye values vector
    }else {
      
      # Append the unique values vector with the new value 
      unique_val[length(unique_val) + 1] <- vector[index]
      
      # Append the counts vector with a new position starting in 1
      unique_val_counts[length(unique_val_counts) + 1] <- 1
    }
  }
  
  # Create a dataframe that returns the unique values along with their counts
  unique_val_frecc <- data.frame("UniqueValues"=unique_val, "NumberOfOccurences"=unique_val_counts)
  
  return(unique_val_frecc)
} # table

# Table function again but using a list
uniqValFrec_withList <- function(vector){
  
  # Create one vector that stores the unique values and another that stores their respective counts
  uniqueValues <- list()
  
  #  Examine each value in the input vector
  for(value in vector){
    
    # Convert the current value to a character
    value <- as.character(value)
    
    # Check if we have'nt seen this value before
    if(is.null(uniqueValues[[value]])){
      
      # Add the current value to our list
      uniqueValues[[value]] <- 1
      
    # Add to the count for the current value
    }else{
      
      # Increment the count for the current unique value
      uniqueValues[[value]] <- uniqueValues[[value]] + 1
    }
  }
  
  return(uniqueValues)
} # table

# Write a function that returns a vector without specific values
remove_jose <- function (vector, specific_value){
  
  # Create a new vector that will store all values except for the removed ones 
  vector_with_values_removed <- c()

  # Loop through the indices of the input vector
  for (index in 1:length(vector)){
    
    # If a vector value is different than the input specific value
    if (vector[index] != specific_value){
      
      # Append the removed values vector with the current value of the input vector
      vector_with_values_removed[length(vector_with_values_removed) + 1] = vector[index]
    }
    
  }
  
  return(vector_with_values_removed)
} # remove

# Write a function that returns a vector where the input values are scaled such that they add to one
scaleToSumOne_jose <- function(vector){
  
  # Create a variable to store the sum of all values of the input vector
  sum_of_all_values = vector[1]
  
  # Loop through the indices of the input values
  for (index in 2:length(vector)){
    
    # Update the sum of all values by adding the current value
    sum_of_all_values = sum_of_all_values + vector[index]
  }
  
  # Create a vector that will store the normalized values
  normalized_vector <- c()
  
  # Loop through the values of the input vector
  for (value in vector){
    
    # Each value is divided by the sum of all values of the input vector
    value = value / sum_of_all_values
    
    # The normalized vector is appended with the normalized value
    normalized_vector[length(normalized_vector) + 1] = value
  }
    
  return(normalized_vector)
} # scaleToSum1

# Write a function that returns a vector where the input values such that they vary between min and max
scaleBetweenTwoValues_jose <- function(vector, min_value, max_value){
  
  # Give an error message if the minimum is equal or bigger than the maximum
  if (min_value >= max_value){
    stop("The minimum value can not be equal or higher than the maximum value")
  }
  
  # Calculate the difference between the minimum and the maximum
  difference = max_value - min_value
  
  # Create an empty vector to store the normalized values
  normalized_vector <- c()
  
  # Loop through the values of the input vector
  for (value in vector){
    
    # Normalized value = input value minus the min and divided by the diference (min will be 0, max will be 1)
    norm_value = (value - min_value) / difference
    
    # Append the normalized vector with the normalized value
    normalized_vector <- append(normalized_vector, norm_value)
  }
  
  return(normalized_vector)
}

# Write a function that returns a vector where the values of the input vector have been randomly shuffled
shuffle_jose <- function (vector){
  
  # Create an empty shuffled vector that will store the values of the input vector randomly shuffled
  shuffled_vect <- c()
  
  # Locate the first value of the input vector in a random index of the shuffled vector
  # Random index will be between 0 and the lenght of the vector (ceiling will avoid 0 and allow lenght) 
  shuffled_vect[ceiling(runif(1, 0, length(vector)))] = vector[1]
  
  # Loop through the indices of the input vector starting on 2
  for (index in 2:length(vector)){
    
    # Create another random index
    rand_ind = ceiling(runif(1, 0, length(vector)))
    
    # While the random index of the random vector is not a NA value
    while (isFALSE(is.na(shuffled_vect[rand_ind]))){
      
      # Repeat the creation of the random index
      rand_ind = ceiling(runif(1, 0, length(vector)))
    }
    
    # Locate the value of the input vector in the random index of the shuffled vector
    shuffled_vect[rand_ind] = vector[index]
    
  }
  
  return(shuffled_vect)
} # shuffle

