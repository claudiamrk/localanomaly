# Make simple test data
make_test_data <- function(n = 30) {
  data.frame(
    time = as.POSIXct("2026-01-01", tz = "UTC") + (0:(n - 1)) * 3600,
    value = 1:n
  )
}

test_that("returns a list", {
  result <- detect_anomalies(make_test_data())
  expect_type(result, "list")
})

test_that("returns three outputs", {
  result <- detect_anomalies(make_test_data())
  expect_named(result, c("anomalies", "plot", "summary"))
})

test_that("returns anomaly data", {
  result <- detect_anomalies(make_test_data())
  expect_true(is.data.frame(result$anomalies))
})

test_that("keeps all observations", {
  result <- detect_anomalies(make_test_data())
  expect_equal(nrow(result$anomalies), 30)
})

test_that("adds a score column", {
  result <- detect_anomalies(make_test_data())
  expect_true("score" %in% names(result$anomalies))
})

test_that("adds an anomaly column", {
  result <- detect_anomalies(make_test_data())
  expect_true("anomaly" %in% names(result$anomalies))
})

test_that("adds a classification column", {
  result <- detect_anomalies(make_test_data())
  expect_true("classification" %in% names(result$anomalies))
})

test_that("scores are numeric", {
  result <- detect_anomalies(make_test_data())
  expect_type(result$anomalies$score, "double")
})

test_that("anomaly indicators are logical", {
  result <- detect_anomalies(make_test_data())
  expect_type(result$anomalies$anomaly, "logical")
})

test_that("returns a plot", {
  result <- detect_anomalies(make_test_data())
  expect_false(is.null(result$plot))
})

test_that("returns a summary", {
  result <- detect_anomalies(make_test_data())
  expect_false(is.null(result$summary))
})

test_that("rejects data without a time column", {
  expect_error(detect_anomalies(data.frame(value = 1:30)))
})

test_that("rejects too few observations", {
  expect_error(
    detect_anomalies(make_test_data(10)),
    "Insufficient observations"
  )
})
