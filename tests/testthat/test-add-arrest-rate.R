context("add_arrest_rate")

test_that("add_arrest_rate computes correct arrest rate", {
  n <- 6
  result <- data.frame(
    meta_condition = rep(1, n),
    contig = rep(1, n),
    start = rep(1, n),
    end = rep(2, n),
    strand = rep("+", n),
    condition = rep(c(1, 2), each = n / 2),
    replicate = rep(1, n),
    base_type = rep(c("arrest_bases", "through_bases", "total"), n / 3),
    coverage = c(1, 9, 10, 5, 5, 10),
    stringsAsFactors = FALSE
  )
  
  expected <- result
  expected[["arrest_rate"]] <- rep(c(1 / 10, 5 / 10), each = 3)

  pull_arrest_rate <- function(result) {
    arrest_rate <- result %>% 
      dplyr::arrange(contig, start, end, strand, condition, replicate, base_type) %>% 
      dplyr::pull(arrest_rate)
    
    arrest_rate
  }
    
  expect_equal(
    pull_arrest_rate(expected),
    pull_arrest_rate(add_arrest_rate(result)),
  )
})