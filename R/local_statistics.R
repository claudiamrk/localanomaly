local_statistics <- function(data, neighbours) {

  statistics <- lapply(1:nrow(data), function(i) {

    neighbour_indices <- neighbours[[i]]

    neighbour_values <- data$value[neighbour_indices]

    local_statistics_cpp(neighbour_values)
  })

  return(statistics)
}
