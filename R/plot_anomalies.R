plot_anomalies <- function(data) {

  ggplot2::ggplot(data, ggplot2::aes(x = time, y = value)) +

    ggplot2::geom_line() +

    ggplot2::geom_point(
      data = data[data$classification != "Normal", ],
      ggplot2::aes(shape = classification)
    ) +

    ggplot2::labs(
      x = "Time",
      y = "Value",
      shape = "Anomaly type"
    ) +

    ggplot2::theme_minimal()
}
