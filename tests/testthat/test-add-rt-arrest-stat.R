context("add_rt_arrest_stat")

test_that("add_rt_arrest_stat as expected", {
	# create test data
  jacusa <- read_jacusa("rt-arrest.out")
  jacusa <- add_rt_arrest_stat(jacusa, aa = TRUE)
  
  expect_false(any(is.na(jacusa$pvalue)))
  expect_true(all(is.numeric(jacusa$pvalue)))
  expect_true(all(jacusa$pvalue >= 0 & jacusa$pvalue <= 1))
})