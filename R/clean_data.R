clean_data-function(data){ #at this stage i think that data is the input which is
  #the dataframe that the user would input...
  #this will clean and prepare the input data

  #check for missing data

  if(is.null(data)){
    stop("Data is missing")
  }

  #check for missing values

  if(any(is.na(data))){
    stop("Data contains missing values")
  }

  #check for duplicates

  if(any(duplicated(data))){
    stop("Data contains observations that are duplicates")
  }

  if(nrow(data)<20){
    stop("Insufficient Observations") #using 20 at this stage - might change this
  }

  if(class(data$time)!="POSIXct"){
    stop("Time must be in POSIXct format")
  }
  return(data)
}

#so far these are the checks that need to be done for the input data
# - might need updating
