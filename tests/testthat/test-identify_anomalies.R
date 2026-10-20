test_that("identify_anomalies identifies scores above the threshold", {
  data <- data.frame(value = 1:5)
  scores <- c(0.5, 1, 4, 2, 0)

  result <- identify_anomalies(data, scores)

  expect_equal(result$anomaly, c(FALSE, FALSE, TRUE, FALSE, FALSE))
})

test_that("identify_anomalies uses absolute scores", {
  data <- data.frame(value = 1:3)
  scores <- c(-4, 0, 4)

  result <- identify_anomalies(data, scores)

  expect_equal(result$anomaly, c(TRUE, FALSE, TRUE))
})

test_that("identify_anomalies adds score and anomaly columns", {
  data <- data.frame(value = 1:3)
  scores <- c(0, 1, 5)

  result <- identify_anomalies(data, scores)

  expect_equal(result$score, scores)
  expect_type(result$anomaly, "logical")
  expect_equal(nrow(result), nrow(data))
})

test_that("identify_anomalies respects a custom threshold", {
  data <- data.frame(value = 1:3)
  scores <- c(1, 2, 3)

  result <- identify_anomalies(data, scores, threshold = 2)

  expect_equal(result$anomaly, c(FALSE, FALSE, TRUE))
})

test_that("identify_anomalies rejects non-data-frame input", {
  expect_error(
    identify_anomalies(1:3, c(1, 2, 3)),
    "data must be a data frame"
  )
})

test_that("identify_anomalies rejects non-numeric scores", {
  data <- data.frame(value = 1:3)

  expect_error(
    identify_anomalies(data, c("a", "b", "c")),
    "scores must be numeric"
  )
})

test_that("identify_anomalies rejects scores of the wrong length", {
  data <- data.frame(value = 1:3)

  expect_error(
    identify_anomalies(data, c(1, 2)),
    "same length"
  )
})

test_that("identify_anomalies rejects non-numeric thresholds", {
  data <- data.frame(value = 1:3)
  scores <- c(1, 2, 3)

  expect_error(
    identify_anomalies(data, scores, threshold = "high"),
    "threshold must be a single numeric value"
  )
})

test_that("identify_anomalies rejects thresholds with length greater than one", {
  data <- data.frame(value = 1:3)
  scores <- c(1, 2, 3)

  expect_error(
    identify_anomalies(data, scores, threshold = c(2, 3)),
    "threshold must be a single numeric value"
  )
})
