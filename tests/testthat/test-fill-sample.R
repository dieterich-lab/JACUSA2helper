context("fill_sample")

test_that("fill_sample works as expected", {
  cond2rep <- get_cond2rep(c("11", "12", "21"))
  sample <- c("", "1", "11", "2")
  
  expect_equal(
    fill_sample(sample, cond2rep),
    c("11,12,21", "11,12", "11", "21")
  )
})