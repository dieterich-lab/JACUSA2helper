context("coverage")

test_that("coverage works as expected", {
  bases <- tibble::tribble(
    ~A, ~C, ~G, ~T,
    1,  0,  0,  0,
    0,  1,  0,  0,
    0,  0,  1,  0,
    0,  0,  0,  1,
    1,  1,  1,  1,
  )
  
  expected <- c(
    1,
    1,
    1,
    1,
    4
  )
  
  expect_equal(
    coverage(bases),
    expected  
  )
})
