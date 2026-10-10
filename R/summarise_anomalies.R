summarise_anomalies <- function(data) {

  anomalies <- data[data$classification != "Normal", ]

  anomalies[, c("time", "value", "score", "classification")]
}
