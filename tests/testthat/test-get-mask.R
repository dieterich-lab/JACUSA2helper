context("get_mask")

test_that("get_mask fails on expected op", {
  expect_error(
    get_mask(matrix(rep(0, 4), ncol = 4, byrow = TRUE), op = "unknown"),
    "Unknown op: *"
  ) 
})

test_that("get_mask works as expected on all", {
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
  expect_equal(get_mask(input, op = "all"), expected)
})

test_that("get_mask works as expected on any", {
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
  expect_equal(get_mask(input, op = "any"), expected)
})
