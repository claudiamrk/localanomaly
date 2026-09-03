local_statistics<-function(data,neighbours){
  #calculates local statistics for each observation

  statistics<-lapply(1:nrow(data),function(i){
    neighbour_indices<-neighbours[[i]]
    neighbour_values<-data$value[neighbour_indices] ##just wrote datavalue at this stage
    #think what this will become
    mean<-mean(neighbour_values)
    sd<-sd(neighbour_values)
    min<-min(neighbour_values)
    max<-max(neighbour_values)

    #think these are the only values i want to calculate for each observation

    c(mean=mean,
      sd=sd,
      min=min,
      max=max)
    #returns these 4 metrics
  })
  return (statistics)
}
