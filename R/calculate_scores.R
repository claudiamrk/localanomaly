#' Calculate anomaly scores
#'
#' Calculates a standardised anomaly score for each observation
#' using its local mean and standard deviation.
#'
#' @param data A data frame containing a numeric `value` column.
#' @param local_stats A list containing local mean and standard deviation
#' for each observation.
#' @return A numeric vector of anomaly scores.
#' @export
calculate_scores <- function(data, local_stats) {

  values <- data$value

  local_means <- sapply(local_stats, function(x) x$mean)
  local_sds <- sapply(local_stats, function(x) x$sd)

  calculate_scores_cpp(
    values,
    local_means,
    local_sds
  )
}

#positive scores are observatins above its local mean
#negative scores are observations below its local mean
