Overview 

localannomaly is an R package for detecting and classifying anomalies in time series data. It identifes observations that differ from their local surroundings and detects unusual patterns using a neighbourhood approach.

The package classifies observations into four categories:

Point anomalies: Individual observations that differ from both their local neighbourhood and overall time series

Contextual Anomalies: Observations that are unusual compared with their local neighbourhood only

Collective Anomalies: Groups of consecutive observations that show a sustained shift compared with the surrounding baseline of observations. 

Installation:

Install the package from GitHub using remotes:

install.packages("remotes")
remotes::install_github("claudiamrk/localanomaly")

Load the package:
library(localanomaly)

Input data

The package expects a data frame containing two columns:

time: The time stamp for each observation
value: The numeric measurement being analysed

Each observation must have a unique timestamp, and the data must contain at least 20 observations.

Example:
data <- data.frame(
  time = as.POSIXct("2026-01-01 00:00:00", tz = "UTC") +
    seq(0, by = 3600, length.out = 60),
  value = c(rnorm(30, 20, 1), 30, rnorm(29, 20, 1))
)

Running the workflow

result<-detect_anomalies(data)

The function returns a list containing three components 

result$anomalies #Data with anomaly scores and classifications 
result$plot #Anomaly detection plot
result$summary #Summary of detected anomalies

View the plot:
result$plot

View the summary:
result$summary

Method: 

Cleaning input – clean_data():

There are multiple functions that validate and prepare the input data so that it is in a valid input format for the following functions in the package. It checks for missing data, data type, data columns 'time' and 'value' exist, check there are enough observations (more than 20), check value is numeric, convert date time to POSIXct format, check for missing observations in the value column, check for duplicate timestamps and sort these observations by time. The function returns relevant error messages if these requirements are not met or returns the data if the function can process the input data frame.

Find neighbourhoods – find_neighbours():

The neighbours for each observation in the time series were identified using k=min(20,sqrt(n)) where n is the number of observations. This formula has the restriction that 20 is the maximum number of neighbours to have for a single observation and so it chooses between either the square root of the number of observations or 20 as the number of neighbours to use, whichever is smaller. The square root of n allows the number of neighbours to increase as the data set gets larger, and the maximum of 20 prevents the function from using too many neighbours that is unnecessary and too much computational effort. These restrictions help keep the neighbourhood local, so each observation is compared with nearby observations rather than the entire dataset. 

Calculate local statistics – local_statistics():

For each neighborhood, the local mean, median, standard deviation, maximum and minimum were calculated. 

Calculate anomaly scores – calculate_scores():

The anomaly score was calculated using the formula:

$$z = \frac{x_i - \mu_{\text{local}}}{\sigma_{\text{local}}}$$
This calculates a z score by subtracting the local mean from each observation adn dividing this difference by the standard deviation for the neighbourhood. A z score was calculated for each observation relative to its neighbourhood.

Classify Anomalies – classify_anomalies():

Observations were classified as being normal, point anomaly, contextual anomaly, or a collective anomaly.

Point anomalies: Individual observations whose local and overall anomaly scores both exceed a threshold of 3 

Contextual anomalies: Observations that are unusual relative to their local neighbourhood, with an absolute local anomaly score exceeding 3.5

Collective anomalies: Sustained shifts across consecutive observations, identified by comparing windows of 10 observations against baseline observations before and after the window

I used different thresholds to distinguish between point and contextual anomalies. A threshold of 3 identifies observations that are unusually extreme both locally and overall. The higher threshold of 3.5 for contextual anomalies makes the classification more conservative, helping to identify observations that are particularly unusual relative to their local neighbourhood without classifying too many observations as anomalies.

Visualise the time series – summarise_anomalies()

The plot_anomalies() function uses ggplot2 to visualise the time series. The function includes the option to change whether classifications are included in the plot with an optional detailed argument where:
- detailed = TRUE: Displays the time series as a line and highlights anomalous observations using different shapes for each anomaly classification
- detailed = FALSE: Displays only the time series line, providing a simpler visualisation without classification-specific shapes

This allows users to choose between a detailed plot that distinguishes anomaly types and a simplified plot that is easier to interpret when many anomalies are present.

User friendly interface – detect_anomalies()

The detect_anomalies() function provides a single entry point for users to perform anomaly detection without needing to run each function individually. It takes the input data set and automatically carries out all the functions in the workflow.

Author 

Claudia Mark


