test_that("clean_data accepts valid data",{
  data<-data.frame(
    time=seq(
      from=as.POSIXct("2026-01-01 00:00:00"),
      by="hour",
      length.out=20
    ),
    value=1:20
  )

  result<-clean_data(data)

  expect_equal(result,data)
})


test_that("clean_data rejects missing data",{
  data<-data.frame(
    time=seq(
      from=as.POSIXct("2026-01-01 00:00:00"),
      by="hour",
      length.out=20
    ),
    value=c(1:19,NA)
  )

  expect_error(clean_data(data))
})


test_that("clean_data rejects non-numeric values",{
  data<-data.frame(
    time=seq(
      from=as.POSIXct("2026-01-01 00:00:00"),
      by="hour",
      length.out=20
    ),
    value=letters[1:20]
  )

  expect_error(clean_data(data))
})


test_that("clean_data rejects too few observations",{
  data<-data.frame(
    time=seq(
      from=as.POSIXct("2026-01-01 00:00:00"),
      by="hour",
      length.out=10
    ),
    value=1:10
  )

  expect_error(clean_data(data))
})


test_that("clean_data rejects unordered times",{
  data<-data.frame(
    time=seq(
      from=as.POSIXct("2026-01-01 00:00:00"),
      by="hour",
      length.out=20
    ),
    value=1:20
  )

  data$time[10]<-data$time[5]

  expect_error(clean_data(data))
})
