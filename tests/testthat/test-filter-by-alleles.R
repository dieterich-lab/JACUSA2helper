context("get_allele_count filter_allele_count")

get_data <- function() {
  data.frame(
    contig = rep(1, 8), 
    start = rep(c(1, 2), each = 4),
    end = rep(c(2, 3), each = 4),
    strand = rep("+", 8),
    condition = rep(c(1, 2), 2, each = 2),
    primary = rep(TRUE, 8),
    base_type = rep("total", 8),
    bc = c("A", "A", "G", "G", "A", "A", "G", "C"),
    ref_base = rep("A", 8),
    stringsAsFactors = FALSE
  )
}

test_that("get_allele_count works as expected on <= 2", {
  expect_equal(
    filter_by_alleles(get_data(), 2),
    get_data()[1:4, ]
  )
})

test_that("filter_allele_count works as expected <= 3", {
  expect_equal(
    filter_by_alleles(get_data(), 3),
    get_data()
  )
})
