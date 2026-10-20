make_plot_data <- function() {
  data.frame(
    time = as.POSIXct("2026-01-01", tz = "UTC") + (0:3) * 3600,
    value = c(10, 20, 30, 40),
    classification = c("Normal", "Point", "Contextual", "Normal")
  )
}

test_that("returns a ggplot object", {
  expect_s3_class(plot_anomalies(make_plot_data()), "ggplot")
})

test_that("uses Time as the x-axis label", {
  expect_equal(plot_anomalies(make_plot_data())$labels$x, "Time")
})

test_that("uses Value as the y-axis label", {
  expect_equal(plot_anomalies(make_plot_data())$labels$y, "Value")
})

test_that("labels the anomaly legend", {
  expect_equal(plot_anomalies(make_plot_data())$labels$shape, "Anomaly type")
})

test_that("contains a line layer", {
  result <- plot_anomalies(make_plot_data())
  expect_true(inherits(result$layers[[1]]$geom, "GeomLine"))
})

test_that("contains a point layer", {
  result <- plot_anomalies(make_plot_data())
  expect_true(inherits(result$layers[[2]]$geom, "GeomPoint"))
})

test_that("contains two layers", {
  expect_length(plot_anomalies(make_plot_data())$layers, 2)
})

test_that("uses a minimal theme", {
  result <- plot_anomalies(make_plot_data())
  expect_true(inherits(result$theme, "theme"))
})

test_that("works when all observations are normal", {
  data <- make_plot_data()
  data$classification <- "Normal"
  expect_s3_class(plot_anomalies(data), "ggplot")
})

test_that("works when all observations are anomalies", {
  data <- make_plot_data()
  data$classification <- c("Point", "Point", "Collective", "Contextual")
  expect_s3_class(plot_anomalies(data), "ggplot")
})

test_that("preserves the input data", {
  data <- make_plot_data()
  original <- data
  plot_anomalies(data)
  expect_equal(data, original)
})

test_that("retains the supplied data in the plot", {
  data <- make_plot_data()
  expect_equal(plot_anomalies(data)$data, data)
})
