#include <Rcpp.h>
#include <algorithm>
#include <cmath>
#include <utility>
#include <vector>

using namespace Rcpp;

// [[Rcpp::export]]
List find_neighbours_cpp(int n) {

  int k = std::floor(std::min(20.0, std::sqrt((double)n)));

  List neighbours(n);
  for (int i =0; i<n; i++){
    std::vector<std::pair<double,int>>distances;
    for (int j =0;j<n;j++){

      if(j!=i){
        double distance=std::abs(j-i);
        distances.push_back(
          std::make_pair(distance,j)
        );
      }
    }

    std::sort(distances.begin(),distances.end());

    IntegerVector nearest(k);
    for (int m=0; m<k;m++){
      nearest [m] =distances[m].second +1;
    }
    neighbours[i]=nearest;
  }
  return neighbours;
}

