context("read_str2read_matrix")

test_that("read_str2read_matrix works as expected on no replicates", {
	# create test data
	reads11 <- c("5,10,0", "2,10,5", "3,10,10", "10,0,10")

	expect_equal(matrix(
               c(5, 10, 0, 2, 10, 5, 3, 10, 10, 10, 0, 10), 
               byrow = T, ncol = 3, dimnames = list(c(), Jacusa2Helper:::.READ)), 
               read_str2read_matrix(reads11))
})

test_that("read_str2read_matrix works as expected on 3 replicates",  {
  # create test data
  reads11 <- c("5,10,0", "2,10,5", "3,10,10", "10,0,10")
  reads12 <- c("0,20,0", "3,15,5", "2,30,30", "1,2,5")
	reads13 <- c("0,30,0", "3,5,5", "2,20,20", "1,3,6")

  l <- list(reads11 = reads11,
            reads12 = reads12,
            reads13 = reads13)
  
  e <- list(reads11 = matrix(c(5,10,0, 2,10,5, 3,10,10, 10,0,10), 
                            byrow = T, ncol = 3, 
                            dimnames = list(c(), Jacusa2Helper:::.READ)),
            reads12 = matrix(c(0,20,0, 3,15,5, 2,30,30, 1,2,5), 
                            byrow = T, ncol = 3, 
                            dimnames = list(c(), Jacusa2Helper:::.READ)), 
            reads13 = matrix(c(0,30,0, 3,5,5, 2,20,20, 1,3,6), 
                            byrow = T, ncol = 3, 
                            dimnames = list(c(), Jacusa2Helper:::.READ)))
  
	expect_identical(e, read_str2read_matrix(l))
})
