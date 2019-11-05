context("base_call")

test_that("base_call works as expected", {
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
    base_call(bases),
    expected  
  )
})
