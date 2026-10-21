utils::globalVariables(c("time", "value", "classification"))

#' Plot Detected Anomalies
#'
#' Visualises time series observations and highlights detected anomalies.
#'
#' @param data A data frame containing `time`, `value`, and `classification` columns.
#' @param detailed Logical. If `TRUE`, highlights anomalies by classification.
#'   If `FALSE`, plots only the time series.
#' @return A ggplot object showing the time series and, optionally, detected anomalies.
#' @export

plot_anomalies <- function(data, detailed = TRUE) {
  p <- ggplot2::ggplot(data, ggplot2::aes(x = time, y = value)) +
    ggplot2::geom_line() +
    ggplot2::labs(x = "Time", y = "Value") +
    ggplot2::theme_minimal()

  if (detailed) {
    p <- p +
      ggplot2::geom_point(
        data = data[data$classification != "Normal", ],
        ggplot2::aes(shape = classification)
      ) +
      ggplot2::labs(shape = "Anomaly type")
  }

  return(p)
}
