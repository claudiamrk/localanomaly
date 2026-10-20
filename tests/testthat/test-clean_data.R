
# Create sample data for testing
test_data <- function(n = 20) {
  data.frame(
    time = seq(
      from = as.POSIXct("2026-01-01 00:00:00", tz = "UTC"),
      by = "hour",
      length.out = n
    ),
    value = seq_len(n)
  )
}

# Accept valid data
test_that("clean_data accepts valid data", {
  data <- test_data()
  expect_equal(clean_data(data), data)
})

# Convert Date timestamps to POSIXct
test_that("clean_data converts Date timestamps", {
  data <- test_data()
  data$time <- as.Date("2026-01-01") + 0:19

  result <- clean_data(data)

  expect_s3_class(result$time, "POSIXct")
  expect_equal(result$value, data$value)
})

# Convert supported character timestamps
test_that("clean_data converts character timestamps", {
  data <- test_data()
  data$time <- format(data$time, "%Y-%m-%d %H:%M:%S", tz = "UTC")
  result <- clean_data(data)
  expect_s3_class(result$time, "POSIXct")
  expect_equal(result$value, data$value)
})

# Reject invalid character timestamps
test_that("clean_data rejects invalid character timestamps", {
  data <- test_data()
  data$time <- rep("not a date", 20)
  expect_error(clean_data(data))
})

# Reject NULL input
test_that("clean_data rejects NULL input", {
  expect_error(clean_data(NULL), "Data is missing")
})

# Reject input that is not a data frame
test_that("clean_data rejects non-data-frame input", {
  expect_error(clean_data(1:20), "Data must be a data frame")
})

# Reject missing timestamps
test_that("clean_data rejects missing timestamps", {
  data <- test_data()
  data$time[5] <- as.POSIXct(NA, tz = "UTC")
  expect_error(clean_data(data), "missing or invalid values")
})

# Reject missing numerical values
test_that("clean_data rejects missing numerical values", {
  data <- test_data()
  data$value[5] <- NA
  expect_error(clean_data(data), "missing or invalid values")
})

# Reject non-numeric values
test_that("clean_data rejects non-numeric values", {
  data <- test_data()
  data$value <- letters[1:20]
  expect_error(clean_data(data), "Value must be numeric")
})

# Reject fewer than 20 observations
test_that("clean_data rejects fewer than 20 observations", {
  data <- test_data(n = 19)
  expect_error(clean_data(data), "Insufficient observations")
})

# Reject duplicate timestamps
test_that("clean_data rejects duplicate timestamps", {
  data <- test_data()
  data$time[10] <- data$time[5]
  expect_error(clean_data(data), "duplicate timestamps")
})

# Sort timestamps and preserve matching values
test_that("clean_data sorts timestamps and preserves values", {
  data <- test_data()
  data <- data[rev(seq_len(nrow(data))), ]
  result <- clean_data(data)
  expect_true(all(diff(result$time) > 0))
  expect_equal(result$value, 1:20)
})

# Accept exactly 20 observations
test_that("clean_data accepts exactly 20 observations", {
  data <- test_data(n = 20)
  result <- clean_data(data)
  expect_equal(nrow(result), 20)
})

# Reject factor values
test_that("clean_data rejects factor values", {
  data <- test_data()
  data$value <- factor(letters[1:20])
  expect_error(clean_data(data), "Value must be numeric")
})

# Reject logical values
test_that("clean_data rejects logical values", {
  data <- test_data()
  data$value <- rep(TRUE, 20)
  expect_error(clean_data(data), "Value must be numeric")
})

# Reject factor timestamps
test_that("clean_data rejects factor timestamps", {
  data <- test_data()
  data$time <- factor(as.character(data$time))
  expect_error(clean_data(data), "Time must be POSIXct")
})

# Reject a missing time column
test_that("clean_data rejects a missing time column", {
  data <- test_data()
  data$time <- NULL
  expect_error(clean_data(data), "time.*column")
})

# Reject a missing value column
test_that("clean_data rejects a missing value column", {
  data <- test_data()
  data$value <- NULL
  expect_error(clean_data(data), "value.*column")
})
