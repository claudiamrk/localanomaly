
make_test_neighbours <- function(n) {
  lapply(seq_len(n), function(i) {
    setdiff(seq_len(n), i)[seq_len(min(5, n - 1))]
  })
}


test_that("classify_anomalies identifies normal observations", {
  data <- data.frame(time = 1:20, value = rep(1, 20))
  scores <- rep(0.5, 20)

  result <- classify_anomalies(
    data, scores, make_test_neighbours(20)
  )

  expect_true(all(result$classification == "Normal"))
})


test_that("classify_anomalies identifies positive point anomalies", {
  data <- data.frame(time = 1:20, value = rep(1, 20))
  data$value[10] <- 20

  scores <- rep(0.5, 20)
  scores[10] <- 5

  result <- classify_anomalies(
    data, scores, make_test_neighbours(20)
  )

  expect_equal(result$classification[10], "Point")
})


test_that("classify_anomalies identifies negative point anomalies", {
  data <- data.frame(time = 1:20, value = rep(1, 20))
  data$value[10] <- -20

  scores <- rep(0.5, 20)
  scores[10] <- -5

  result <- classify_anomalies(
    data, scores, make_test_neighbours(20)
  )

  expect_equal(result$classification[10], "Point")
})


test_that("classify_anomalies identifies collective anomalies", {
  data <- data.frame(time = 1:80, value = rep(1, 80))

  # A sustained change across ten consecutive observations
  data$value[36:45] <- 10

  scores <- rep(0.5, 80)

  result <- classify_anomalies(
    data, scores, make_test_neighbours(80)
  )

  expect_true(any(result$classification == "Collective"))
  expect_equal(result$classification[40], "Collective")
})


test_that("classify_anomalies identifies contextual anomalies", {
  data <- data.frame(time = 1:20, value = 1:20)

  scores <- rep(0.5, 20)
  scores[10] <- 4

  result <- classify_anomalies(
    data, scores, make_test_neighbours(20)
  )

  expect_equal(result$classification[10], "Contextual")
})


test_that("point anomalies are not reclassified as collective", {
  data <- data.frame(time = 1:80, value = rep(1, 80))
  data$value[40] <- 100

  scores <- rep(0.5, 80)
  scores[40] <- 5

  result <- classify_anomalies(
    data, scores, make_test_neighbours(80)
  )

  expect_equal(result$classification[40], "Point")
})


test_that("classify_anomalies adds scores and classifications", {
  data <- data.frame(time = 1:20, value = rep(1, 20))
  scores <- rep(0.5, 20)

  result <- classify_anomalies(
    data, scores, make_test_neighbours(20)
  )

  expect_true("score" %in% names(result))
  expect_true("classification" %in% names(result))
  expect_equal(result$score, scores)
  expect_equal(nrow(result), nrow(data))
})


test_that("classify_anomalies respects a custom point threshold", {
  data <- data.frame(time = 1:20, value = rep(1, 20))
  data$value[10] <- 20

  scores <- rep(0.5, 20)
  scores[10] <- 2.5

  result <- classify_anomalies(
    data,
    scores,
    make_test_neighbours(20),
    point_threshold = 2
  )

  expect_equal(result$classification[10], "Point")
})
