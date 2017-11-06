context("get_comp_bc_matrix, get_comp_bcs")

test_that("get_comp_bc_matrix works as expected", {
	matrix <- matrix(c(10,5,0,0,
									   0,10,5,0,
									   0,0,10,5,
									   5,0,0,10),
                   ncol = 4, byrow = TRUE)
	colnames(matrix) <- Jacusa2Helper:::.BASES
	
	comp_matrix <- matrix(c(0,0,5,10,
       									  0,5,10,0,
           								5,10,0,0,
          								10,0,0,5),
          							ncol = 4, byrow = TRUE
	)
	colnames(comp_matrix) <- Jacusa2Helper:::.BASES

	expect_equal(comp_matrix, get_comp_bc_matrix(matrix))
})

test_that("get_comp_bcs works as expected", {
	bcs <- list("A", "C", "G", "T")
	comp_bcs <- list("T", "G", "C", "A")

	expect_equal(comp_bcs, get_comp_bcs(bcs))

	bcs2 <- list(c("A", "G"), c("C", "T"), c("G", "G"), c("T", "A"))
	comp_bcs2 <- list(c("T", "C"), c("G", "A"), c("C", "C"), c("A", "T"))
	
	expect_equal(comp_bcs2, get_comp_bcs(bcs2))
})
