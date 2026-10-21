---
title: "501 Final Report for Localanomaly"
output:
  pdf_document: default
  html_document:
    df_print: paged
date: "2026-10-13"
author: "Claudia Mark"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

**1. Introduction and Aim**

Identifying anomalous observations in data is important for detecting unusual patterns, understanding underlying trends and identifying changes in behaviour. In time series data, anomalies may indicate sudden changes or unexpected fluctuations in time. Detecting these observations can provide invaluable insights in areas such as environmental monitoring, finance and human behaviour.

Existing anomaly detection methods can identify unusual observations, but these methods are global anomaly detection methods and do not have classification of anomalous observations available. This motivated the development of localanomaly() as it was designed to identify and classify anomalies in time series data using a local neighbourhood method. This method calculates local statistics of the neighbourhood of each observation in the time series and classify these into four groups which are point anomaly, contextual anomaly or collective anomaly or normal.

The package provides visualisations of the provided time series data as well as summary statistics of findings. To evaluate the performance of this package, it was tested with a real world temperature data set and these results are discussed in this report. As well as this, there is a self-reflection on the development of the package including limitations, critiques and future recommendations. 

**1.2 Objectives**

-	Develop an R package that identifies anomalous observations in time series data by identifying neighbourhoods of the observations

-	Implement methods to calculate local statistics and anomaly scores to identify observations that differ from their surrounding behaviour

-	Classify detected anomalies as point, contextual or collective

-	Produce visualisations and summary outputs that are easily interpretable for the user, no matter the education or background of the user 

-	Develop automated tests to assess the functionality, consistently and reliability of the package

-	Evaluate the package using real world time series data sets and identify limitations and improvements 

**2. Package Design and Development**

**2.1 Development Process**

Cleaning input – clean_data():

Validates and prepares input data by checking required columns, data types, missing values, duplicate time stamps and minimum number of observations. 

Find neighbourhoods – find_neighbours():

The neighbours of neighbours is determined using k=min(20,sqrt(n)) where n is the number of observations. I choose that the formula has the restriction that 20 is the maximum number of neighbours to have for a single observation and so it chooses between either the square root of the number of observations or 20 as the number of neighbours to use, whichever is smaller. The square root of n allows the number of neighbours to increase as the data set gets larger, and the maximum of 20 prevents the function from using too many neighbours that is unnecessary and too much computational effort. These restrictions help keep the neighbourhood local, so each observation is compared with nearby observations rather than the entire data set. 

Calculate local statistics – local_statistics():

For each neighborhood, the local mean, median, standard deviation, maximum and minimum were calculated. These being calculated directly from the neighbourhood ensures that the individual observations are being compared to their neighbourhood which was what I aimed for with this calculation. 

Calculate anomaly scores – calculate_scores():

The anomaly score was calculated using the formula:

$$z = \frac{x_i - \mu_{\text{local}}}{\sigma_{\text{local}}}$$

This calculates a z score by subtracting the local mean from each observation and dividing this difference by the standard deviation for the neighbourhood. A z score was calculated for each observation relative to its neighbourhood.

Classify Anomalies – classify_anomalies():

Observations were classified as being a point anomaly, contextual anomaly, collective anomaly or normal.

Point anomalies: Individual observations whose local and overall anomaly scores both exceed a threshold of 3 

Contextual anomalies: Observations that are unusual relative to their local neighbourhood, with an absolute local anomaly score exceeding 3.5.

Collective anomalies: Sustained shifts across consecutive observations, identified by comparing windows of 10 observations against 20 baseline observations before and after the window.

I used different thresholds to distinguish between point and contextual anomalies. As this is a z score, the threshold means that the observation is that many standard deviations from either the local mean (for contextual) or both the local mean and global mean (for point).  A threshold of 3 identifies observations that are unusually extreme both locally and overall. The higher threshold of 3.5 for contextual anomalies makes the classification more conservative, helping to identify observations that are particularly unusual relative to their local neighbourhood without classifying too many observations as anomalies.

Visualise the results – summarise_anomalies() and plot_anomalies()

The plot_anomalies() function uses ggplot2 to visualise the time series. I choose for the function to include the option to change whether classifications are included in the plot with an optional detailed argument where:

- detailed = TRUE: Displays the time series and highlights anomalous observations with different classification shapes 

- detailed = FALSE: Displays only the time series line

summarise_anomalies() produces a summary table with the time, value, score and classification for anomalies.

User friendly interface – detect_anomalies()

The detect_anomalies() function provides a single entry point for users to perform anomaly detection without needing to run each function individually. It takes the input data set and automatically carries out all the functions in the workflow. I wanted to have a final function that the user could call that did the entire pipeline and produced just the summary and visualisation which this does.

**2.2 Implementation Approach**

C++: Computationally intensive calculations such as finding the neighbouring observations (find_neighbours.cpp), calculating local statistics (local_statistics.cpp) and calculating anomaly scores (calculate_scores.cpp) were done using C++

R: Data cleaning and validation, anomaly identification and classification, visualisation of results and generation of the summary table of anomalies.

**3. Test Results**

**3.1	Testing Strategy**

The testing for this package had three main components which were automated tests, testing on a created test data frame and testing on a real world time series. These three different ways of testing allowed me to understand both the functionality and reliability of the package.

**3.2	Automated Test Results**

A total of 102 automated tests were executed and all 102 of the tests passed with 0 fails, 0 warnings and 0 skips. This suggests that the functionalities produced the expected results.

Using devtools::check() as an overall check of the package, this produced 0 errors, 0 warnings and 1 note. The note was related to the testing environment being unable to verify the current time, rather than indicating an error or warning in the package functionality itself. This was the same note that I received during the peer assessment which indicates that it is a note related to the testing environment of my mac.

**3.4 Comparison of Anomaly detection compared to current anomaly detection packages**

To evaluate the performance of localanomaly, its results were compared with those from an existing R package anomalize. Both packages were tested using the same time series data set made containing 100 observations and had generated labels for the three anomaly types; point, contextual and collective. These labels were assigned at the start to provide a known reference against which the detection could be compared against. The data followed a repeating pattern and 13 anomalies were intentionally added. This included four point anomalies, four contextual anomalies and five collective anomalies. The remaining 87 observations were normal in the data.

This test compared the anomaly detection performance of the two packages. As anomalize does not classify anomalies into different types, the comparison focused on whether each package detected the planted anomalies. The detection results were compared against the predefined labels to evaluate each packages to detect these different types of anomalies. This allowed me to understand how well my package was performing compared to an existing R package.

| Measure | `localanomaly` | `anomalize` |
|---|---:|---:|
| Point Anomalies | 4/4 | 4/4 |
| Contextual Anomalies | 4/4 | 1/4 |
| Collective Anomalies | 0/5 | 2/5 |
| Total | 8/13 | 6/13 |


| Metric | `localanomaly` | `anomalize` |
|---|---:|---:|
| Recall | 61.50% | 46.20% |
| Precision | 100.00% | 100.00% |
| False Positives | 0 | 0 |

These results highlight difference in how localanomaly and anomalize identify different types of anomalies. Both of the packages detected all four of the point anomalies. This suggests that both methods were effective at identifying individual observations that were different from normal neighbourhood behaviour. The main difference in performance between the two models was with the contextual and collective anomalies. 

Localanomaly detected all four contextual anomalies, whereas anomalize only detected one. This difference could be because of how the packages define an unusual observation. Localanoamly calculated the anomaly score by comparing each observation with the mean and standard deviation of its local neighbourhood. This allows an observation to be identified as anomalous when its different from its nearby values, even if its value is not unusual when looking at the time series globally. In contrast, anomalize identifies anomalies based on differences form an estimated trend and seasonal pattern. Therefore, an observation that is unusual relative to its immediate nearest other points may not be identified as anomalies and is does not deviate sufficiently from the overall expected trend and seasonal behaviour. 

Anomalize detected two out of the five collective anomalies, whereas localanomaly detected none. This difference may be due to how each method identifies collective anomalies. The collective detection method in localanomaly compares a window of 10 consecutive observations with a baseline calculated from the 20 surrounding observations on either side of the window. This baseline is the median of the 40 observations in the surrounding neighbourhood. However, unusual observations next to the window may influence the baseline if they are included in the surrounding observations used for comparison. This could make the difference between the window and the baseline less significant, causing some collective anomalies to be missed. In contrast, anomalize identifies anomalies based on deviations from the estimated trend and seasonal patterns, allowing it to detect collective anomalies when consecutive observations deviate from the expected behaviour of the overall time series.

Both methods had 100% precision meaning that every observation identified as an anomaly was a true anomaly, with no false positives. Localanomaly had a recall of 61.5% and anomalize had a recall of 46.2%. This suggests that localanomaly detected a greater proportion of the planted anomalies in the data set, while anomalize missed a larger proportion. These differences reflect how each method identifies unusual observations based on its underlying approach.

Overall, the two methods had different strengths in identifying anomalies in the data due to the different approaches. Both packages had 100% precision which is very important for anomaly detection because it reduces the risk of incorrectly flagging normal observations as anomalous. 

**3.5	Evaluation using real world data set**

The data set that I used to assess the package was sourced from https://www.stats.govt.nz/indicators/temperature-data-to-2025/ 
which contained temperature data across Aotearoa ranging from 1909 to 2022. 

The data set was loaded in as an csv file and was converted to the correct input format as described by the package instructions in the documentation. These steps included:

1. Loading the CSV file into R using read.csv()

2. Filtering the data set to select the required location and temperature statistic

3. Selecting the date and temperature value columns and renaming them to time and value, respectively

4. Converting the date column into the appropriate date-time format and ensuring that the temperature observations were numeric

5. Checking the data for missing values 

6. Passing the prepared data set to the package's clean_data() function to validate and prepare it for anomaly detection

The data set contained 33,632 observations for maximum temperature in Wellington. The method identified 9 point anomalies, 89 contextual anomalies and 48 collective anomalies, while the remaining 33,486 observations were classified as normal. Therefore, 99.57% of the observations were classified as normal and 0.43% as anomalous. There were few point anomalies, and many contextual anomalies. These results show that the package can identify all three anomaly categories in a large time series. However, because the data set did not contain verified anomaly labels, the classification cannot be treated as confirmed anomalies as there is no ground truth. 

**4.	Critical Reflection and Future Improvements**

**4.1	Evaluation of the final package**

The development of this package meets my objectives set out during the planning stage of this project. The package successfully identifies anomalies in time series data using the neighbourhood approach. It implements the methods to calculate local statistics which were mean, standard deviation, maximum and minimum of each observations neighbourhood. It classifies the detected anomalies as normal, point, collective or contextual. The final package produces visualisations and summary outputs that are straight forward for the user to interpret. The performance of the package has been assessed on real life data and these results were presented above.

**4.2	Reflection on the Process**

The timeline created in the project proposal was extremely beneficial for the development of this package as this time line set out at the beginning of the planning stage kept me accountable throughout the trimester and gave me a set of dates to follow to know I was on track. This meant that I was able to thoroughly analyse every design made throughout the process and gave me time to assess whether the decisions made were appropriate for the function and overall package. 

The writing of code in C++ was new to me so was something I spent extra time on to ensure that the code written in C++ was behaving as expected. Developing my C++ programming skills was something that I found very interesting throughout this package and something I think will help in my future endeavors. 

Creating a clear package structure from the beginning meant that the code and calculations for each function was in the designated place in a structured format. This allowed me to separate the functions and have everything in an organised structure that will also make it easier for the user to understand the internal calculations.

**4.3 Limitations**

A limitation is that the package does not accept duplicate time stamps. The temperature data set had multiple sites across Aotearoa, as well as different temperature statistics recorded including minimum, maximum and average. Whilst this provides a detailed data set that works well for analysis and anomaly detection, it highlighted a limitation in the package. As there were multiple statistics for each site, this meant that there were duplicate time stamps in the data and in clean_data(), if there are duplicate time stamps there is an error message returned and the function stops. To overcome this for the purpose of testing, I filtered the data so that it was only one statistic from each site for instance analysing the maximum temperature trends only across Aotearoa. This approach allows for detailed analysis and ensures anomalies are attributed to changes in temperature and not other factors like geographical location. However, it may be a limitation because it restricts the package to analysing one temperature statistic at a time. This reduces its flexibility when working with real world data sets that contain multiple measurements recorded at the same time stamp. 

Another limitation is that the method for collective anomalies compares consecutive observations against points surrounding the window on either side. This means that groups of points are compared between their direct neighbours as I wanted to keep the approach as neighbourhood based as possible. One potential improvement would be to modify the collective anomaly detection method to compare consecutive observations against a broader baseline, rather than only using 20 observations immediately before and after the window. This could help identify sustained changes that may be difficult to detect when neighbouring anomalous observations influence the local baseline. However, the broader baseline would need to account for trends and seasonal patterns to avoid incorrectly identifying normal changes as anomalies.

Another limitation is that the package uses fixed thresholds to determine whether observations are classified as anomalies. I choose these thresholds to be 3 and 3.5 for point and contextual respectively. If the thresholds are too high, the real anomalies could be missed but if they are too low, observations may be incorrectly classified. Whist values around 3 are common for methods that use a z score, future improvements could be to investigate ways of automatically selecting these parameters based on characteristics of the input time series.

**4.4 Development Challenges**

Developing the package so that it worked in a pipeline way meant that the different functions had to work together correctly throughout the anomaly detection process. Most of the stages depended on output from the previous stage, meaning that errors in input validation, neighbourhood selection or anomaly scoring would effect the final classifications. This required testing individual functions as well as the overall process. Testing different input formats and invalid data also helped ensure that the package handled errors correctly rather than continuing and producing unexpected results.

Another challenge was learning to implement the C++ code into the R package. As writing C++ was new to me, I needed to spend additional time understanding how to ensure the code written was producing expected results. 

Another challenge was related to github and pushing the changes to the repository. This was still relatively new to me and the first time using it on a project. Ensuring that I followed the same steps each time demonstrated in the tutorial allowed me to ensure that I knew the status of the work and what was being pushed to the repository was in the right place.

**4.5	Future Changes**

The package currently requires the data input to contain columns that are specifically named time and value. This means that every input time series that is used must have the columns relating to the date and the observations must be called ‘time’ and ‘value’ respectively. Whilst this provides a consistent input structure across the package and provides a simple implementation of the detection pipeline, it does introduce some difficulties. It requires the user to adapt the naming of their columns so that they match with these two values which can be a restricting requirement of the package. Something that would make this package more flexible would be to allow the user to specify which columns in the data set they want to be used as the time and value column. This would mean the package wouldn’t require the user to change the column to exactly time and value labels. 

The requirement that I had for the package was that duplicate time stamps weren’t allowed in the package and each observation had a unique time stamp. It was designed in this way because of the neighbourhood based approach it uses to calculate the local statistics. The algorithm selects a specific number of neighbours for each observation, so if there are duplicate time stamps, multiple neighbours could have the same time rather than representing different points in the time series. This could affect the local statistics and anomaly scores calculated by the package, which then affects the anomaly classifications. In the future, I would improve the package so that it allows duplicate time stamps and give the user the option to aggregate observations that were recorded at the same time. This would allow the package to be used with a wider range of data and not have to remove a potentially significant amount of observations from a data set. 

**5.	Conclusion**

To conclude, the localanomaly package can successfully detect point, contextual and collective anomalies in time series. The performance of this package was compared against an existing R package as well as on a real world time series. Limitations and challenges in the development of this package were identified as well as future improvements. Overall, the package functions as intended and has both R and C++ implementation. 




