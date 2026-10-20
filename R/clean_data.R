
clean_data <- function(data) {

  # Check that the input exists
  if (is.null(data)) {
    stop("Data is missing")
  }

  # Check that the input is a data frame
  if (!is.data.frame(data)) {
    stop("Data must be a data frame")
  }

  # Check that the required columns exist
  if (!"time" %in% names(data)) {
    stop("Data must contain a 'time' column")
  }

  if (!"value" %in% names(data)) {
    stop("Data must contain a 'value' column")
  }

  # Check that there are enough observations
  if (nrow(data) < 20) {
    stop("Insufficient observations")
  }

  # Check that values are numeric
  if (!is.numeric(data$value)) {
    stop("Value must be numeric")
  }

  # Convert Date times to POSIXct
  if (inherits(data$time, "Date")) {
    data$time <- as.POSIXct(data$time, tz = "UTC")

    # Convert supported character times to POSIXct
  } else if (is.character(data$time)) {
    data$time <- as.POSIXct(
      data$time,
      format = "%Y-%m-%d %H:%M:%S",
      tz = "UTC"
    )

    # Reject unsupported time formats
  } else if (!inherits(data$time, "POSIXct")) {
    stop("Time must be POSIXct, Date, or a supported character format")
  }

  # Check for missing or invalid values
  if (anyNA(data$time) || anyNA(data$value)) {
    stop("Data contains missing or invalid values")
  }

  # Check for duplicate timestamps
  if (anyDuplicated(data$time)) {
    stop("Data contains duplicate timestamps")
  }

  # Sort observations by time
  data <- data[order(data$time), ]

  return(data)
}


