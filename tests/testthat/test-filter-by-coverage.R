context("filter_by_coverage")

filter_get_count <- function(df, min_coverage, type) {
  df <- filter_by_coverage(df, min_coverage, type)
  nrow(df)
}

create_result <- function() {
  r <- tibble::tribble(
    ~contig, ~start, ~end, ~strand, ~condition, ~replicate, ~primary, ~base_type, ~coverage,
    1,      1,    2,     "+",          1,          1,     TRUE,    "total",        10,
    1,      1,    2,     "+",          1,          2,     TRUE,    "total",        10,
    1,      1,    2,     "+",          2,          1,     TRUE,    "total",        20,
    1,      1,    2,     "+",          2,          2,     TRUE,    "total",        20,
  )
  
  r
}

test_that("filter_by_coverage fails on unknown type", {
  r <- create_result()
  expect_error(
    filter_by_coverage(r, 10, "unknown"),
    "Unknown parameter type: *"
  )
})

test_that("filter_by_coverage fails on invalid min_coverage", {
  expect_error(
    filter_by_coverage(r, "string"),
    "min_coverage not a number or negative: *"
  )
  expect_error(
    filter_by_coverage(r, -1),
    "min_coverage not a number or negative: *"
  )
})

test_that("filter_by_coverage works as expected for replicate", {
  r <- create_result()
  expect_equal(
    filter_get_count(r, 20, "replicate"),
    0
  )
})

test_that("filter_by_coverage works as expected for total", {
  r <- create_result()
  expect_equal(
    filter_get_count(r, 60, "total"),
    4
  )
  expect_equal(
    filter_get_count(r, 61, "total"),
    0
  )
})

test_that("filter_by_coverage works as expected for condition", {
  r <- create_result()
  expect_equal(
    filter_get_count(r, 20, "condition"),
    4
  )
  expect_equal(
    filter_get_count(r, 21, "condition"),
    0
  )
})
