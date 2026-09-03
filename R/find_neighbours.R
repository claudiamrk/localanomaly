find_neighbours<-function(data){ #this is the data returned from cleandata
  #finds the local neighbours for each observation

  n<-nrow(data)#number of observatiosn
  k<-floor(min(20,sqrt(n)))#number of neighbours
  neighbours<-lapply(1:n,function(i){
    distances=abs(1:n-i)#this is the distance from observation 1
    distsances[i]<-Inf#but dont include the observation itself
    order(distances[1:k])
  })
  return (neighbours)


}
