context("get_robust_variant_index filter_robust_variants")

.get_data_no_rep <- function() {
  l <- list(contig <- c(1, 2),
            bases11 = c("10,0,0,0", "0,10,0,0", "0,0,10,0", "0,10,0,1"),
            bases21 = c("10,0,0,2", "0,10,0,1", "0,0,0,2", "0,10,0,1"))
  l <- add_bc_matrix(l)
  l <- add_bc(l)
  l
}

.get_data <- function() {
  l <- list(contig = c(1, 2, 3, 4),
            bases11 = c("10,0,0,0", "0,10,0,0", "0,0,10,0", "0,10,0,1"),
            bases12 = c("10,0,0,0", "0,10,0,0", "0,0,10,2", "0,10,0,1"),
            bases21 = c("10,0,0,0", "0,10,0,1", "0,0,10,2", "0,10,0,1"),
            bases22 = c("10,0,0,2", "0,10,0,0", "0,0,10,2", "0,10,0,1"))
  l <- add_bc_matrix(l)
  l <- add_bc(l)
  l
}

test_that("get_robust_variant_index on no replicates", {
  l <- .get_data_no_rep()

  expect_equal(c(TRUE, TRUE, TRUE, TRUE), get_robust_variant_index(l$bc_matrix1, l$bc_matrix2))
})

test_that("get_robust_variant_index on two replicates each", {
  l <- .get_data()
  
  expect_equal(c(FALSE, FALSE, TRUE, TRUE), get_robust_variant_index(l$bc_matrix1, l$bc_matrix2))
})

test_that("filter_robust_variants on two replicates each", {
  l <- .get_data()
  
  expect_true(length(filter_robust_variants(l)$contig) == 2)
})