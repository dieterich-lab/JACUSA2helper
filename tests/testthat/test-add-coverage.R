context("add_coverage")

test_that("add_coverage works as expected", {
	# create test data
	bases11 <- c("10,5,0,0", "10,0,5,10", "0,0,0,0", "5,5,5,5")
  bases21 <- c("0,5,0,0", "0,0,5,10", "0,0,0,0", "5,0,0,5")
	bases22 <- bases11
	l <- list(
		bases11 = bases11,
		bases21 = bases21,
		bases22 = bases22
	)
  l <- add_bc_matrix(l)
  l <- add_coverage(l)

	cov1 <- c(15, 25, 0, 20)
	covs2 <- list(
		bases21 = c(5, 15, 0, 10),
		bases22 = c(15, 25, 0, 20)
	)
	cov <- cov1 + c(5, 15, 0, 10) + c(15, 25, 0, 20)
  
	expect_equal(cov, l$cov)
	expect_equal(cov1, l$cov1)
	expect_equal(covs2, l$covs2)
})