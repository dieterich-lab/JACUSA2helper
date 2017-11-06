context("matrix2str, get_bc, get_bcs")

# helper functions
.get_matrix <- function(counts) {
	m <- matrix(counts, ncol = 4, byrow = TRUE)
	colnames(m) <- Jacusa2Helper:::.BASES
	m
}

test_that("matrix2str works as expected", {
	# create sample data RDDs
	bases1 = c("10,0,0,0", "0,10,0,0", "0,0,10,0", "0,0,0,10")
	bases2 = c("10,5,0,0", "0,10,5,0", "0,0,10,5", "5,0,0,10")

	m1 <- .get_matrix(c(10,0,0,0,  0,10,0,0,  0,0,10,0,  0,0,0,10))
	m2 <- .get_matrix(c(10,5,0,0,  0,10,5,0,  0,0,10,5,  5,0,0,10))
	
	l <- list(bases11 = bases1, bases12 = bases2)
	m <- list(bases11 = m1, bases12 = m2)

	# one replicate
	expect_equal(bases1, matrix2str(m1))

	# two replicates
	expect_equal(l, matrix2str(m))
})

test_that("get_bc and get_bcs works as expected", {
	# create sample data RDDs
  m1 <- .get_matrix(c(10,0,0,0,  0,10,0,0,  0,0,10,0,  0,0,0,10))
  m2 <- .get_matrix(c(10,5,0,0,  0,10,5,0,  0,0,10,5,  5,0,0,10))

  l <- list(bases11 = m1, bases12 = m2)
  
  # one replicate
	expect_equal(c("A", "C", "G", "T"), get_bc(m1))
  expect_equal(list("A", "C", "G", "T"), get_bcs(m1))
  
  # two replicates
  expect_equal(list(c("A", "C"), 
                    c("C", "G"), 
                    c("G", "T"),
                    c("A", "T")), 
                    get_bcs(m2))
})