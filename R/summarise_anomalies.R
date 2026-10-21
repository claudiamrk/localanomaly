#' Summarise Detected Anomalies
#'
#' Summarises the anomalies detected in a time series.
#'
#' @param data A data frame containing anomaly detection results.
#' @return A summary of the detected anomalies.
#' @export

summarise_anomalies <- function(data) {

  anomalies <- data[data$classification != "Normal", ]

  anomalies[, c("time", "value", "score", "classification")]
}
