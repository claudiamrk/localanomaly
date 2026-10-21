#' @useDynLib localanomaly, .registration = TRUE
NULL

#' Find Local Neighbours
#'
#' Identifies neighbouring observations for each time series observation.
#'
#' @param data A cleaned time series data frame.
#' @return A list of neighbouring observations for each observation.
#' @export
find_neighbours <- function(data) {
  find_neighbours_cpp(nrow(data))
}
