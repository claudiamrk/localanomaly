clean_data<-function(data){ #at this stage i think that data is the input which is
  #the dataframe that the user would input...
  #this will clean and prepare the input data

  #check that the inpt exists
  if(is.null(data)){
    stop("Data is missing")
  }

  #check that the input is a dataframe
  if(!is.data.frame(data)){
    stop("Data must be a data frame")
  }

  #check there is a time column for the time series

  if(!"time" %in% names(data)){
    stop("Data must contain a 'time' column")
  }

  #check there is a value column
  if(!"value" %in% names(data)){
    stop("Data must contain a 'value' column")
  }

  #check for missing data

  if(any(is.na(data))){
    stop("Data contains missing values")
  }

  # correct date time format
  if(!inherits(data$time, "POSIXct")){
    stop("Time must be in POSIXct format")
  }

  #check values are numeric
  if(!is.numeric(data$value)){
    stop("Value must be numeric")
  }

  #check for duplicates
  if(any(duplicated(data))){
    stop("Data contains observations that are duplicates")
  }

  #check there's a sufficient amount of observations

  if(nrow(data)<20){
    stop("Insufficient Observations") #using 20 at this stage - might change this
  }

  #check the time is ordered
  if(any(diff(data$time) < 0)){
    stop("Time values must be in increasing order")
  }

  return(data)
}

#so far these are the checks that need to be done for the input data
# - might need updating
