context("get_bc_change_ratio")


test_that("get_bc_change_ratio works as expected", {
	# create test data
	l <- list(
	  bases11 = c("10,0,0,0", "0,0,0,10", "5,0,0,0"),
	  bases21 = c("5,5,0,0", "0,0,5,10", "5,0,0,0"),
	  bases22 = c("5,10,0,0", "0,0,10,10", "20,0,0,0"))
	l <- add_bc_matrix(l)
	l <- add_bc(l)
  
	r <- get_bc_change_ratio(l$bc1, l$bc2, l$bc_matrix2)

	# expected result
	bc_change_ratio1 <- c(5/10, 5/15, 0)
	bc_change_ratio2 <- c(10/15, 10/20, 0)
	bc_change_ratio <- (bc_change_ratio1 + bc_change_ratio2) / 2 

	expect_equal(bc_change_ratio1, r$bc_change_ratio1)
	expect_equal(bc_change_ratio2, r$bc_change_ratio2)
	expect_equal(bc_change_ratio, r$bc_change_ratio)
})
