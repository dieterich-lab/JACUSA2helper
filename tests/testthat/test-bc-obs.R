context("bc_obs")

test_that("bc_obs works as expected", {
  bases <- tibble::tribble(
    ~A, ~C, ~G, ~T,
     1,  0,  0,  0,
     0,  1,  0,  0,
     0,  0,  1,  0,
     0,  0,  0,  1,
     1,  1,  1,  1,
  )
  
  expected <- c(
    "A",
    "C",
    "G",
    "T",
    "ACGT"
  )
  
  expect_equal(
    bc_obs(bases),
    expected  
  )
})
