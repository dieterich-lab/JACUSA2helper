context("post_process")

test_that("post_process works as expected on call", {
  result <- tibble::tribble(
      ~contig, ~start, ~condition, ~replicate,     ~bases, 
    "contig1",      1,          1,          1,      EMPTY,
    "contig1",      1,          1,          2, "10,0,0,0",
  )
  actual <- post_process(CALL_PILEUP_METHOD_TYPE, BASES_COLUMN, result)
  
  expected <- result
  expected[[BASES_COLUMN]] <- tibble::tribble(
    ~A, ~C, ~G, ~T,
     0,  0,  0,  0,
    10,  0,  0,  0,
  )
  expected[[bc_obs_col()]] <- c("", "A")
  expected[[cov_col()]] <- c(0, 10)

  expect_equal(
    as.data.frame(actual), 
    as.data.frame(expected)
  )
})

test_that("post_process works as expected on call", {
  result <- tibble::tribble(
    ~contig, ~start, ~condition, ~replicate,      ~arrest,   ~through,
    "contig1",      1,          1,          1,      EMPTY, "0,10,0,0",   
    "contig1",      1,          1,          2, "10,0,0,0", "0,0,0,10",
  )
  actual <- post_process(
    RT_ARREST_METHOD_TYPE, 
    c(ARREST_COLUMN, THROUGH_COLUMN), 
    result
  )
  
  expected <- result
  expected[[ARREST_COLUMN]] <- tibble::tribble(
    ~A, ~C, ~G, ~T,
     0,  0,  0,  0,
    10,  0,  0,  0,
  )
  expected[[THROUGH_COLUMN]] <- tibble::tribble(
    ~A, ~C, ~G, ~T,
     0, 10,  0,  0,
     0,  0,  0, 10,
  )
  expected[[bc_obs_col(ARREST_COLUMN)]] <- c("", "A")
  expected[[cov_col(ARREST_COLUMN)]] <- c(0, 10)
  expected[[bc_obs_col(THROUGH_COLUMN)]] <- c("C", "T")
  expected[[cov_col(THROUGH_COLUMN)]] <- c(10, 10)
  expected[[BASES_COLUMN]] <- expected[[ARREST_COLUMN]] + expected[[THROUGH_COLUMN]]
  expected[[bc_obs_col()]] <- c("C", "AT")
  expected[[cov_col()]] <- c(10, 20)
  expected[[arrest_rate_col()]] <- c(0, 1/2)
  
  expect_equal(
    as.data.frame(actual), 
    as.data.frame(expected)
  )
})
