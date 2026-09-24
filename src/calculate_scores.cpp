#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
NumericVector calculate_scores_cpp(
    NumericVector values,
    NumericVector local_means,
    NumericVector local_sds
) {

  int n = values.size();

  NumericVector scores(n);

  for (int i = 0; i < n; i++) {

    scores[i] = (values[i] - local_means[i]) / local_sds[i];

  }

  return scores;
}
