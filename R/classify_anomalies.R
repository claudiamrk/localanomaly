classify_anomalies <- function(data, scores, neighbours, threshold = 3) {

  classification <- rep("Normal", nrow(data))

  # Point anomalies
  classification[abs(scores) > threshold] <- "Point"

  # Check for collective and contextual anomalies
  for (i in seq_along(scores)) {

    if (classification[i] == "Point") {
      next
    }

    neighbour_scores <- abs(scores[neighbours[[i]]])

    # Collective anomaly
    if (sum(neighbour_scores > threshold * 0.7) >= 2) {
      classification[i] <- "Collective"
    }

    # Contextual anomaly
    else if (length(neighbour_scores) > 0 &&
             abs(scores[i]) > 2 * mean(neighbour_scores)) {
      classification[i] <- "Contextual"
    }
  }

  data$score <- scores
  data$classification <- classification

  return(data)
}
