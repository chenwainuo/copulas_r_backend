# Load required libraries
library(plumber)
library(VineCopula)
library(jsonlite)


#* @apiTitle VineCopula API

#* Predict using VineCopula and store the result
#* @param U1 First input vector
#* @param U2 Second input vector
#* @param key A key provided by the client to store the result
#* @post /train
function(U1, U2, key, res) {
  U1 <- as.numeric(strsplit(U1, split=",")[[1]])
  U2 <- as.numeric(strsplit(U2, split=",")[[1]])
  
  cop1 <- BiCopSelect(U1, U2, familyset = NA, indeptest = FALSE, level = 0.05, rotations = TRUE)
  print(cop1$familyname)
  
  # Check if the key already exists in the environment
  if (exists(key, envir = .GlobalEnv)) {
    res$status <- 409
    return(list("error" = "Key already exists"))
  }
  
  # Store cop1 in the environment using the provided key
  assign(key, cop1, envir = .GlobalEnv)
  
  return(list("status" = "OK"))
}


#* Make a prediction using a stored model
#* @param U1 First input vector
#* @param U2 Second input vector
#* @param key The key to identify the result
#* @post /predict
function(U1, U2, key, res) {
  # Check if the key exists in the environment
  if (!exists(key, envir = .GlobalEnv)) {
    res$status <- 404
    return(list("error" = "Key not found"))
  }
  
  # Retrieve the cop1 from the environment
  cop1 <- get(key, envir = .GlobalEnv)
  
  U1 <- as.numeric(strsplit(U1, split=",")[[1]])
  U2 <- as.numeric(strsplit(U2, split=",")[[1]])
  
  h1_given_2 <- BiCopHfunc1(U1, U2, cop1)
  h2_given_1 <- BiCopHfunc2(U1, U2, cop1)
  
  # Return the results as a list
  return(list("h1_given_2" = h1_given_2, "h2_given_1" = h2_given_1))
}


