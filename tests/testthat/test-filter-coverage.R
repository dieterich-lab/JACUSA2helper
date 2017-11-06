context("filter_coverage")

.get_data <- function() {
  l <- list(contig = c(1, 2, 3, 4),
            bases11 = c("10,0,0,0", "0,10,0,0",	"0,0,10,0", "0,0,0,10"),
            bases21 = c("5,0,0,0", "0,5,0,15", "0,0,5,0", "0,0,0,5"),
            bases22 = c("0,0,25,0", "0,0,0,20", "0,0,0,0", "0,0,5,0"))
  l <- add_coverage(l)
  l
}

test_that("filter_coverage works as expected ", {
  l <- .get_data()
  
  # no filtering 
  expect_true(length(l$contig) == 4)
  
  # site needs to have total coverage >= 40
  r <- filter_coverage(l, field = "cov", 40)
  expect_true(length(r$contig) == 2)
  
  # total coverage in condition 1 and total coverage in condition 2 must >= 20
  r <- filter_coverage(l, field = c("cov1", "cov2"), c(10, 40))
  expect_true(length(r$contig) == 1)
  
  # each replicate in condition 1 and condition 2 must have coverage >= 5
  r <- filter_coverage(l, field = c("covs1", "covs2"), c(5, 5))
  expect_true(length(r$contig) == 3)
})