calculate_scores<-function(data,local_stats){
  #calculates anomaly scores for each observation
  scores<-sapply(1:nrow(data),function(i){
    x<-data$value[i]
    local_mean<-local_stats[[i]]["mean"]
    local_sd<-local_stats[[i]]["sd"]
    score<-(x-local_mean)/local_sd
    return(score)
  })
  return(scores)

}
