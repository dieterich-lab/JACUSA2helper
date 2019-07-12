context("robust_variants_helper")


test_that("robust_variants_helper works on 1 condition", {
  n <- 2
  expect_equal(
    robust_variants_helper(
      rep(TRUE, n),
      rep("total", n),
      rep(1, n),
      c(0, 0),
      c(0, 0),
      c(0, 1),
      c(1, 0)
    ),
    FALSE
  )
  
  n <- 2
  expect_equal(
    robust_variants_helper(
      rep(TRUE, n),
      rep("total", n),
      rep(1, n),
      c(0, 0),
      c(0, 0),
      c(0, 1),
      c(1, 1)
    ),
    TRUE
  )
})

test_that("robust_variants_helper works on 2 condition", {
  n <- 4
  expect_equal(
    robust_variants_helper(
      rep(TRUE, n),
      rep("total", n),
      c(1, 1, 2, 2),
      c(0, 0, 0, 0),
      c(0, 0, 0, 0),
      c(0, 0, 0, 1),
      c(1, 1, 1, 1)
    ),
    FALSE
  )
  
  n <- 4
  expect_equal(
    robust_variants_helper(
      rep(TRUE, n),
      rep("total", n),
      c(1, 1, 2, 2),
      c(0, 0, 0, 0),
      c(0, 0, 0, 0),
      c(0, 0, 1, 1),
      c(1, 1, 1, 1)
    ),
    TRUE
  )
  
  n <- 4
  expect_equal(
    robust_variants_helper(
      rep(TRUE, n),
      rep("total", n),
      c(1, 1, 2, 2),
      c(0, 0, 0, 0),
      c(0, 0, 0, 0),
      c(0, 0, 1, 1),
      c(1, 1, 0, 0)
    ),
    TRUE
  )
})
