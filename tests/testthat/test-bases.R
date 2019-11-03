context("bases")

test_that("extract_bases works as expected", {
  bases_str <- c(
    "0,0,0,0",
    "1,2,3,4"
  )
  expected <- tibble::tribble(
    ~A, ~C, ~G, ~T, 
    0, 0, 0, 0, 
    1, 2, 3, 4
  )

  expect_equal(
    extract_bases(bases_str),
    expected  
  )
})

test_that("fix_empty_bases works as expected", {
  bases_str <- c(
    EMPTY,
    "1,2,3,4"
  )
  expected <- c(
    paste0(rep(0, length(BASES)), collapse = ","),
    "1,2,3,4"
  )
  
  expect_equal(
    fix_empty_bases(bases_str),
    expected  
  )
})
