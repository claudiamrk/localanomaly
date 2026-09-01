detect_anomalies<-function(){
  #this is the main function for detecting the anomalies
  cleaned_data<-clean_data(data)

  neighbours<-find_neighbours(cleaned_data)

  statistics<-local_statistics(cleaned,data,neighbours)

  scores<-calculate_scores(statistics)

  anomalies<-identify_anomalies(scores)

  classified<-classify_anomalies(anomalies)

  plot<-plot_anomalies(cleaned_data,classified)

  summary<-summarise_anomalies(classified)

  return(list(
    anomalies=classified,
    plot=plot,
    summary=summary
  ))
}
