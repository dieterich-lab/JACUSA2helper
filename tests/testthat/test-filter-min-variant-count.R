context("get_variant_count filter_min_variant_count")

.get_data <- function() {
  l <- list(
    contig = c(1, 2, 3),
    bases11 = c("10,0,0,0", "0,10,0,0", "0,0,10,0"),
    bases21 = c("10,0,0,2", "0,10,0,1", "0,0,10,0"),
    bases22 = c("10,0,0,2", "0,10,0,1", "0,0,10,2")
  )
  l <- add_bc_matrix(l)
  l <- add_bc(l)
  l
}

.get_invalid_data <- function() {
  l <- list(
    contig = c(1, 2, 3),
    bases11 = c("10,0,0,1", "0,10,1,0", "0,0,10,0"),
    bases21 = c("10,0,0,2", "0,10,0,1", "0,0,10,0"),
    bases22 = c("10,0,0,2", "0,10,0,1", "0,0,10,2")
  )
  l <- add_bc_matrix(l)
  l <- add_bc(l)
  l
}

test_that("get_variant_count works as expected", {
  l <- .get_data()
  
  count <- get_variant_count(l$bc1, l$bc2, l$bc_matrix2)
  expect_equal(list(bases21 = c(2, 1, 0),
                    bases22 = c(2, 1, 2)),
               count)
})

test_that("get_variant_count on 2 alleles in condition 1", {
  l <- .get_invalid_data()
  
  expect_error(get_variant_count(l$bc1, l$bc2, l$bc_matrix2), 
               "Too many (>=2) alleles for condition 1", 
               fixed = TRUE)
})

test_that("filter_min_variant_count works as expected", {
  l <- .get_data()

  f <- filter_min_variant_count(l)
  expect_true(length(f$contig) == 1)
  
  f <- filter_min_variant_count(l, min_count = 1)
  expect_true(length(f$contig) == 2)
  
  f <- filter_min_variant_count(l, min_count = 3)
  expect_true(length(f$contig) == 0)
})