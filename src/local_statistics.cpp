#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List local_statistics_cpp(Rcpp::NumericVector x){
  int n =x.size();
  double sum=0;

  for(int i = 0; i < n; i++){
    sum+=x[i];
  }

  double mean=sum/n;
  double squared_sum=0;

  for(int i = 0; i < n; i++){
    squared_sum+=(x[i]-mean)*(x[i]-mean);
  }
  double sd=sqrt(squared_sum/(n-1));

  double min_value=min(x);
  double max_value=max(x);

  return Rcpp::List::create(
    Rcpp::Named("mean")=mean,
    Rcpp::Named("sd")=sd,
    Rcpp::Named("min")=min_value,
    Rcpp::Named("max")=max_value
  );

}

