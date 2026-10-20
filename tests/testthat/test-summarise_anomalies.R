# Make test data
make_summary_data <- function() {
  data.frame(
    time = as.POSIXct("2026-01-01", tz = "UTC") + (0:3) * 3600,
    value = c(10, 20, 30, 40),
    score = c(0.5, 4, 2, 5),
    classification = c("Normal", "Point", "Contextual", "Normal")
  )
}

test_that("returns a data frame", {
  expect_true(is.data.frame(summarise_anomalies(make_summary_data())))
})

test_that("returns the required columns", {
  result <- summarise_anomalies(make_summary_data())
  expect_named(result, c("time", "value", "score", "classification"))
})

test_that("removes normal observations", {
  result <- summarise_anomalies(make_summary_data())
  expect_false(any(result$classification == "Normal"))
})

test_that("returns exactly two anomalies", {
  expect_equal(nrow(summarise_anomalies(make_summary_data())), 2)
})

test_that("returns the expected values", {
  result <- summarise_anomalies(make_summary_data())
  expect_equal(result$value, c(20, 30))
})

test_that("returns the expected scores", {
  result <- summarise_anomalies(make_summary_data())
  expect_equal(result$score, c(4, 2))
})

test_that("returns the expected classifications", {
  result <- summarise_anomalies(make_summary_data())
  expect_equal(result$classification, c("Point", "Contextual"))
})

test_that("keeps the correct timestamps", {
  data <- make_summary_data()
  result <- summarise_anomalies(data)
  expect_equal(result$time, data$time[2:3])
})

test_that("keeps point anomalies", {
  result <- summarise_anomalies(make_summary_data())
  expect_true("Point" %in% result$classification)
})

test_that("keeps contextual anomalies", {
  result <- summarise_anomalies(make_summary_data())
  expect_true("Contextual" %in% result$classification)
})

test_that("returns zero rows when all observations are normal", {
  data <- make_summary_data()
  data$classification <- "Normal"
  expect_equal(nrow(summarise_anomalies(data)), 0)
})

test_that("returns all rows when none are normal", {
  data <- make_summary_data()
  data$classification <- c("Point", "Contextual", "Collective", "Point")
  expect_equal(nrow(summarise_anomalies(data)), 4)
})

test_that("does not change the input data", {
  data <- make_summary_data()
  original <- data
  summarise_anomalies(data)
  expect_equal(data, original)
})
