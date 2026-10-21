#' Detect anomalies in a time series
#'
#' Runs the complete anomaly detection workflow, including data cleaning,
#' neighbourhood identification, scoring, classification and visualisation.
#'
#' @param data A data frame containing `time` and `value` columns.
#' @return A list containing the classified anomalies, plot and summary.
#' @export

detect_anomalies <- function(data) {
  # Clean the input data
  cleaned_data <- clean_data(data)

  # Find neighbouring observations
  neighbours <- find_neighbours(cleaned_data)

  # Calculate local statistics
  statistics <- local_statistics(cleaned_data, neighbours)

  # Calculate anomaly scores
  scores <- calculate_scores(cleaned_data, statistics)

  # Identify anomalies
  anomalies <- identify_anomalies(cleaned_data, scores)

  # Classify anomalies
  classified <- classify_anomalies(
    anomalies,
    scores,
    neighbours
  )

  # Create plot
  plot <- plot_anomalies(classified)

  # Create summary
  summary <- summarise_anomalies(classified)

  return(list(
    anomalies = classified,
    plot = plot,
    summary = summary
  ))
}
