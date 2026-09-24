#' @useDynLib localanomaly, .registration = TRUE
NULL

#' Find local neighbours
#'
#' Finds the nearest neighbours for each observation using C++.
#'
#' @param data A data frame containing the observations.
#' @return A list containing the neighbour indices for each observation.
#' @export
find_neighbours <- function(data) {
  find_neighbours_cpp(nrow(data))
}
