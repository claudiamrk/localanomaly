test_that("find_neighbours returns the correct number of neighbours",{
  data<-data.frame(
    value=c(10,20,30,40,50)
  )

  neighbours<-find_neighbours(data)

  expect_length(neighbours,5)
  expect_length(neighbours[[1]],2)
})


test_that("find_neighbours does not include the observation itself",{
  data<-data.frame(
    value=c(10,20,30,40,50)
  )

  neighbours<-find_neighbours(data)

  for(i in 1:5){
    expect_false(i %in% neighbours[[i]])
  }
})


test_that("find_neighbours returns the closest observations",{
  data<-data.frame(
    value=c(10,20,30,40,50)
  )

  neighbours<-find_neighbours(data)

  expect_equal(neighbours[[1]],c(2,3))
  expect_equal(neighbours[[3]],c(2,4))
  expect_equal(neighbours[[5]],c(4,3))
})
