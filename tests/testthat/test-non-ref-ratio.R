context("non_ref_ratio")

test_that("non_ref_ratio works as expected", {
  ref <- c("A", "A", "G", "C", "T")
  bases <- tidyr::tribble(
    ~A, ~C, ~G, ~T,
     1,  0,  0,  0,
     0,  1,  0,  0,
     0,  0,  1,  0,
     0,  0,  0,  1,
     1,  1,  1,  1,
  )
  
  expected <- c(
    0,
    1,
    0,
    1,
    3 /4
  )

  expect_equal(
    non_ref_ratio(bases, ref),
    expected  
  )
})
