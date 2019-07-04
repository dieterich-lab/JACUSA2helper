context("filter_by_coverage")

.w <- function(df, min_coverage, type) {
  df <- filter_by_coverage(df, min_coverage, type)
  nrow(df)
}

test_that("filter_by_coverage fails on unknown type", {
  expect_error(
    filter_by_coverage(
      data.frame(
        contig = 1, start = 1, end = 2, strand = "+",
        condition = 1,
        replicate = 1,
        base_type = "total",
        primary = TRUE,
        coverage = 10,
        stringsAsFactors = FALSE
      ),
      10,
      "unknown"
    ),
    "Unknown parameter type: *"
  )
})

test_that("filter_by_coverage fails on invalid min_coverage", {
  expect_error(
    filter_by_coverage(
      data.frame(
        contig = 1, start = 1, end = 2, strand = "+",
        condition = 1,
        replicate = 1,
        base_type = "total",
        primary = TRUE,
        coverage = 10,
        stringsAsFactors = FALSE
      ),
      "string"
    ),
    "min_coverage not a number or negative: *"
  )
  expect_error(
    filter_by_coverage(
      data.frame(
        contig = 1, start = 1, end = 2, strand = "+",
        condition = 1,
        replicate = 1,
        base_type = "total",
        primary = TRUE,
        coverage = 10,
        stringsAsFactors = FALSE
      ),
      -1
    ),
    "min_coverage not a number or negative: *"
  )
})

test_that("filter_by_coverage works as expected for replicate", {
  expect_equal(
    .w(
      data.frame(
        contig = rep(1, 4), start = rep(1, 4), end = rep(2, 4), strand = rep("+", 4),
        condition = rep(c(1, 2), each = 2),
        replicate = rep(c(1, 2), 2),
        base_type = rep("total", 4),
        primary = rep(TRUE, 4),
        coverage = c(10, 10, 20, 20),
        stringsAsFactors = FALSE
      ),
      20, "replicate"
    ),
    0
  )
})

test_that("filter_by_coverage works as expected for total", {
  expect_equal(
    .w(
      data.frame(
        contig = rep(1, 4), start = rep(1, 4), end = rep(2, 4), strand = rep("+", 4),
        condition = rep(c(1, 2), each = 2),
        replicate = rep(c(1, 2), 2),
        base_type = rep("total", 4),
        primary = rep(TRUE, 4),
        coverage = c(10, 10, 20, 20),
        stringsAsFactors = FALSE
      ),
      60, "total"
    ),
    4
  )
  expect_equal(
    .w(
      data.frame(
        contig = rep(1, 4), start = rep(1, 4), end = rep(2, 4), strand = rep("+", 4),
        condition = rep(c(1, 2), each = 2),
        replicate = rep(c(1, 2), 2),
        base_type = rep("total", 4),
        primary = rep(TRUE, 4),
        coverage = c(10, 10, 20, 20),
        stringsAsFactors = FALSE
      ),
      61, "total"
    ),
    0
  )
})

test_that("filter_by_coverage works as expected for condition", {
  expect_equal(
    .w(
      data.frame(
        contig = rep(1, 4), start = rep(1, 4), end = rep(2, 4), strand = rep("+", 4),
        condition = rep(c(1, 2), each = 2),
        replicate = rep(c(1, 2), 2),
        base_type = rep("total", 4),
        primary = rep(TRUE, 4),
        coverage = c(10, 10, 20, 20),
        stringsAsFactors = FALSE
      ),
      20, "condition"
    ),
    4
  )
  expect_equal(
    .w(
      data.frame(
        contig = rep(1, 4), start = rep(1, 4), end = rep(2, 4), strand = rep("+", 4),
        condition = rep(c(1, 2), each = 2),
        replicate = rep(c(1, 2), 2),
        base_type = rep("total", 4),
        primary = rep(TRUE, 4),
        coverage = c(10, 10, 20, 20),
        stringsAsFactors = FALSE
      ),
      21, "condition"
    ),
    0
  )
})
