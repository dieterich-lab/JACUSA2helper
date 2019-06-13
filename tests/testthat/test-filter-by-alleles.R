context("get_allele_count filter_allele_count")

.get_data <- function() {
  data.frame(
    id = c(1, 1, 1, 1, 2, 2, 2, 2),
    condition = c(1, 1, 2, 2, 1, 1, 2, 2),
    bc = c("A", "A", "G", "G", "A", "A", "G", "C"),
    ref_base = c("A", "A", "A", "A", "A", "A", "A", "A"),
    stringsAsFactors = FALSE
  )
}

test_that("get_allele_count works as expected on <= 2", {
  expect_equal(
    filter_by_alleles(.get_data(), 2),
    .get_data()[1:4, ]
  )
})

test_that("filter_allele_count works as expected <= 3", {
  expect_equal(
    filter_by_alleles(.get_data(), 3),
    .get_data()
  )
})
