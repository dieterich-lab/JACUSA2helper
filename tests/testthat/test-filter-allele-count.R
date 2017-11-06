context("get_allele_count filter_allele_count")

.get_data <- function() {
  l <- list(
    contig = c(1, 2, 3, 4),
    bases1 = list(
      bases11 = c("10,0,0,0", "0,10,0,0", "0,0,10,0", "0,10,0,1"),
      bases12 = c("10,0,0,0", "0,10,0,0", "0,0,10,2", "0,10,0,1")
    ),
    bases2 = list(
      bases21 = c("10,0,0,2", "0,10,0,1", "0,0,10,2", "0,10,1,1"),
      bases22 = c("10,0,0,2", "0,10,0,0", "0,0,10,2", "0,10,0,1")
    )
  )
  add_bc_matrix(l)
}

test_that("get_allele_count works as expected", {
  l <- .get_data()

  expect_equal(c(2, 2, 2, 3), 
               get_allele_count(l$bc_matrix1, l$bc_matrix2))
})

test_that("filter_allele_count works as expected", {
  l <- .get_data()
  
  expect_true(length(filter_allele_count(l)$contig) == 3)
  expect_true(length(filter_allele_count(l, max_alleles = 3)$contig) == 4)
})