context("base_ratio")

test_that("base_ratio works as expected", {
  bases <- tidyr::tribble(
    ~A, ~C, ~G, ~T,
    1,  0,  0,  0,
    0,  1,  0,  0,
    0,  0,  1,  0,
    0,  0,  0,  1,
    1,  1,  1,  1,
  )
  
  expected <- tidyr::tribble(
    ~A, ~C, ~G, ~T,
    1,  0,  0,  0,
    0,  1,  0,  0,
    0,  0,  1,  0,
    0,  0,  0,  1,
  1/4,1/4,1/4,1/4,
  )

    expect_equal(
    base_ratio(bases),
    expected  
  )
})
