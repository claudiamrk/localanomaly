#' Calculate Local Statistics
#'
#' Calculates statistics for each observation using its local neighbourhood.
#'
#' @param data A time series data frame.
#' @param neighbours The neighbouring observations for each observation.
#' @return Local statistics for each observation.
#' @keywords internal

local_statistics <- function(data, neighbours) {

  statistics <- lapply(1:nrow(data), function(i) {

    neighbour_indices <- neighbours[[i]]

    neighbour_values <- data$value[neighbour_indices]

    local_statistics_cpp(neighbour_values)
  })

  return(statistics)
}
