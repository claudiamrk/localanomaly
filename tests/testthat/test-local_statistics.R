
test_that("local_statistics uses the supplied neighbours",{
  data<-data.frame(
    value=c(10,20,30,40,50)
  )

  neighbours<-list(
    c(2,3),
    c(1,3),
    c(1,2),
    c(3,5),
    c(3,4)
  )

  result<-local_statistics(data,neighbours)

  expect_equal(result[[1]]$mean,25)
  expect_equal(result[[1]]$min,20)
  expect_equal(result[[1]]$max,30)
})

test_that("local_statistics calculates statistics correctly",{
  data<-data.frame(
    value=c(10,20,30,40,50)
  )

  neighbours<-list(
    c(2,3),
    c(1,3),
    c(1,2),
    c(3,5),
    c(3,4)
  )

  result<-local_statistics(data,neighbours)

  expect_equal(result[[1]]$mean,25)
  expect_equal(result[[1]]$sd,sd(c(20,30)))
  expect_equal(result[[1]]$min,20)
  expect_equal(result[[1]]$max,30)
})

test_that("local_statistics returns statistics for every observation",{
  data<-data.frame(
    value=c(10,20,30,40,50)
  )

  neighbours<-list(
    c(2,3),
    c(1,3),
    c(1,2),
    c(3,5),
    c(3,4)
  )

  result<-local_statistics(data,neighbours)

  expect_length(result,5)
})
