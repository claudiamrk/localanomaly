## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(localanomaly)

## -----------------------------------------------------------------------------
set.seed(123)

n <- 100

example_data <- data.frame(
  time = as.POSIXct("2026-01-01 00:00:00", tz = "UTC") +
    seq(0, by = 300, length.out = n),
  value = 10 + sin(2 * pi * (1:n) / 20) +
    rnorm(n, mean = 0, sd = 0.2)
)

# Add point anomaliess
example_data$value[c(15, 35, 55, 95)] <- c(30, 32, 29, 33)

# Add contextual anomalies
example_data$value[c(25, 45, 65, 85)] <- c(14, 14, 14, 14)

# Add collective anomaly
example_data$value[71:75] <- c(25, 26, 25.5, 27, 26)

head(example_data)

## -----------------------------------------------------------------------------
result <- detect_anomalies(example_data)

## -----------------------------------------------------------------------------
head(result$anomalies)

## -----------------------------------------------------------------------------
result$summary

## ----fig.width=6, fig.height=4------------------------------------------------
result$plot

