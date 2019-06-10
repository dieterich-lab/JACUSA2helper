context("filter_by_coverage")

.a <-function(
  df = data.frame(id = c(), condition = c(), replicate = c(), coverage = c(), stringsAsFactors = FALSE), 
  id, con, rep, cov) {
  
  rbind(df, data.frame(id = id, condition = con, replicate = rep, coverage = cov, stringsAsFactors = FALSE))
}

.w <- function(df, min_coverage, type) {
  df <- filter_by_coverage(df, min_coverage, type)
  nrow(df)
}

test_that("filter_by_coverage fails on unknown type", {
  expect_error(
    filter_by_coverage(
      .a(id = 1, con = 1, rep = 1, cov = 10),
      10,
      "unknown"
    ),
    "Unknown parameter type: *"
  )
})

test_that("filter_by_coverage fails on invalid min_coverage", {
  expect_error(
    filter_by_coverage(
      .a(id = 1, con = 1, rep = 1, cov = 10),
      "string"
    ),
    "min_coverage not a number or negative: *"
  )
  expect_error(
    filter_by_coverage(
      .a(id = 1, con = 1, rep = 1, cov = 10),
      -1
    ),
    "min_coverage not a number or negative: *"
  )
})

test_that("filter_by_coverage works as expected for replicate", {
  expect_equal(
    .w(
      .a(id = 1, con = 1, rep = 1, cov = 10) %>%
        .a(id = 1, con = 1, rep = 2, cov = 10) %>%
        .a(id = 2, con = 2, rep = 1, cov = 20) %>%
        .a(id = 2, con = 2, rep = 2, cov = 20),
      20, type = "replicate"
    ),
    2
  )
})

test_that("filter_by_coverage works as expected for total", {
  expect_equal(
    .w(
      .a(id = 1, con = 1, rep = 1, cov = 10) %>%
        .a(id = 1, con = 1, rep = 2, cov = 10) %>%
        .a(id = 2, con = 2, rep = 1, cov = 20) %>%
        .a(id = 2, con = 2, rep = 2, cov = 20),
      20, type = "total"
    ),
    4
  )
  expect_equal(
    .w(
      .a(id = 1, con = 1, rep = 1, cov = 10) %>%
        .a(id = 1, con = 1, rep = 2, cov = 10) %>%
        .a(id = 2, con = 2, rep = 1, cov = 20) %>%
        .a(id = 2, con = 2, rep = 2, cov = 20),
      40, type = "total"
    ),
    2
  )
})

test_that("filter_by_coverage works as expected for condition", {
  expect_equal(
    .w(
      .a(id = 1, con = 1, rep = 1, cov = 10) %>%
        .a(id = 1, con = 1, rep = 2, cov = 10) %>%
        .a(id = 2, con = 2, rep = 1, cov = 20) %>%
        .a(id = 2, con = 2, rep = 2, cov = 20),
      10, type = "condition"
    ),
    4
  )
  expect_equal(
    .w(
      .a(id = 1, con = 1, rep = 1, cov = 10) %>%
        .a(id = 1, con = 1, rep = 2, cov = 10) %>%
        .a(id = 2, con = 2, rep = 1, cov = 20) %>%
        .a(id = 2, con = 2, rep = 2, cov = 20),
      40, type = "condition"
    ),
    2
  )
})
