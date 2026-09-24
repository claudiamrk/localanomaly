test_that("calculate_scores calculates scores correctly",{
  data<-data.frame(
    value=c(10,20,30)
  )

  local_stats<-list(
    list(mean=9,sd=1),
    list(mean=18,sd=2),
    list(mean=25,sd=5)
  )

  scores<-calculate_scores(data,local_stats)

  expect_equal(scores,c(1,1,1))
})

test_that("calculate_scores returns one score for each observation",{
  data<-data.frame(
    value=c(10,20,30,40)
  )

  local_stats<-list(
    list(mean=10,sd=1),
    list(mean=20,sd=2),
    list(mean=30,sd=3),
    list(mean=40,sd=4)
  )

  scores<-calculate_scores(data,local_stats)

  expect_length(scores,4)
})

test_that("calculate_scores handles negative scores",{
  data<-data.frame(
    value=c(5)
  )

  local_stats<-list(
    list(mean=10,sd=2)
  )

  scores<-calculate_scores(data,local_stats)

  expect_equal(scores,-2.5)
})
