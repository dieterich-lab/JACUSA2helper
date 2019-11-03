context("mask")

test_that("mask fails on expected op", {
  expect_error(
    mask(matrix(rep(0, 4), ncol = 4, byrow = TRUE), op = "unknown"),
    "Unknown op: *"
  ) 
})

test_that("mask works as expected on all", {
  input <- matrix(
    c(
      1, 0, 0, 0,
      0, 1, 0, 0, 
      0, 0, 1, 0, 
      0, 0, 0, 1
    ), ncol = 4, byrow = TRUE
  )
  expected <- matrix(
    c(FALSE, FALSE, FALSE, FALSE),
    ncol = 4, byrow = TRUE
  )
  expect_equal(mask(input, op = all), expected)
  
  input <- matrix(
    c(
      1, 0, 0, 0,
      1, 0, 0, 0, 
      1, 0, 0, 0, 
      1, 0, 0, 0
    ), ncol = 4, byrow = TRUE
  )
  expected <- matrix(
    c(TRUE, FALSE, FALSE, FALSE),
    ncol = 4, byrow = TRUE
  )
  expect_equal(mask(input, op = all), expected)
  
})

test_that("mask works as expected on any", {
  input <- matrix(
    c(
      1, 0, 0, 0,
      0, 1, 0, 0, 
      0, 0, 1, 0, 
      0, 0, 0, 1
    ), ncol = 4, byrow = TRUE
  )
  expected <- matrix(
    c(TRUE, TRUE, TRUE, TRUE),
    ncol = 4, byrow = TRUE
  )
  expect_equal(mask(input, op = any), expected)
})
