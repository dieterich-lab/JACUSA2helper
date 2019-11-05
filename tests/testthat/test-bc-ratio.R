context("bc_ratio")

test_that("bc_ratio works as expected", {
  bases <- tibble::tribble(
    ~A, ~C, ~G, ~T,
    1,  0,  0,  0,
    0,  1,  0,  0,
    0,  0,  1,  0,
    0,  0,  0,  1,
    1,  1,  1,  1,
  )
  
  expected <- tibble::tribble(
    ~A, ~C, ~G, ~T,
    1,  0,  0,  0,
    0,  1,  0,  0,
    0,  0,  1,  0,
    0,  0,  0,  1,
  1/4,1/4,1/4,1/4,
  )

    expect_equal(
    bc_ratio(bases),
    expected  
  )
})
