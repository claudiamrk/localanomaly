identify_anomalies <- function(data, scores, threshold = 3) {

  if (!is.data.frame(data)) {
    stop("data must be a data frame")
  }

  if (!is.numeric(scores)) {
    stop("scores must be numeric")
  }

  if (length(scores) != nrow(data)) {
    stop("scores must have the same length as the number of rows in data")
  }

  if (!is.numeric(threshold) || length(threshold) != 1) {
    stop("threshold must be a single numeric value")
  }

  data$score <- scores
  data$anomaly <- abs(scores) > threshold

  return(data)
}
