#' @importFrom stats mad median sd
classify_anomalies <- function(data, scores, neighbours, point_threshold=3,
                               contextual_threshold=3.5) {

  n <- nrow(data)
  values <- data$value
  classification <- rep("Normal", n)

  # 1. Calculate overall z-scores
  overall_sd <- sd(values, na.rm = TRUE)

  if (is.finite(overall_sd) && overall_sd > 0) {
    overall_scores <- (values - mean(values, na.rm = TRUE)) / overall_sd
  } else {
    overall_scores <- rep(NA_real_, n)
  }

  # 2. Detect point and contextual anomalies
  for (i in seq_len(n)) {

    if (!is.finite(scores[i])) next

    local_anomaly <- abs(scores[i]) > point_threshold

    overall_anomaly <- is.finite(overall_scores[i]) &&
      abs(overall_scores[i]) > point_threshold

    if (local_anomaly && overall_anomaly) {
      classification[i] <- "Point"

    } else if (
      abs(scores[i]) > contextual_threshold &&
      !overall_anomaly
    ) {
      classification[i] <- "Contextual"
    }
  }
  # 3. Detect sustained collective changes
  window_size <- 10
  baseline_size <- 20

  if (n >= window_size + 2 * baseline_size) {

    for (start in seq_len(n - window_size + 1)) {

      end <- start + window_size - 1

      if (any(classification[start:end] == "Point" |
              classification[start:end] == "Contextual")) next

      left_start <- start - baseline_size
      right_end <- end + baseline_size

      if (left_start < 1 || right_end > n) next

      left_values <- values[left_start:(start - 1)]
      window_values <- values[start:end]
      right_values <- values[(end + 1):right_end]

      left_median <- median(left_values, na.rm = TRUE)
      right_median <- median(right_values, na.rm = TRUE)
      window_median <- median(window_values, na.rm = TRUE)

      baseline_values <- c(left_values, right_values)
      baseline_median <- median(baseline_values, na.rm = TRUE)
      baseline_mad <- mad(baseline_values, na.rm = TRUE)

      scale <- max(baseline_mad, 0.2, na.rm = TRUE)

      stable_baseline <- abs(left_median - right_median) < 2 * scale
      sustained_shift <- abs(window_median - baseline_median) > 4 * scale

      if (stable_baseline && sustained_shift) {
        classification[start:end] <- "Collective"
      }
    }
  }

  # 4. Add output columns
  data$score <- scores
  data$classification <- classification
  data$anomaly <- classification != "Normal"

  data
}
