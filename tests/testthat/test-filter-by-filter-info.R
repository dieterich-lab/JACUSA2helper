context("filter_by_filter_info")

filter_get_count <- function(df, artefacts) {
  df <- filter_by_filter_info(df, artefacts)
  nrow(df)
}

create_result <- function() {
  r <- tibble::tribble(
    ~contig, ~start, ~end, ~strand, ~condition, ~replicate, ~primary, ~base_type, ~filter_info,
    1,      1,    2,     "+",          1,          1,     TRUE,    "total",        "B;M",
    1,      1,    2,     "+",          1,          2,     TRUE,    "total",        "B;M",
    1,      1,    2,     "+",          2,          1,     TRUE,    "total",        "B;M",
    1,      1,    2,     "+",          2,          2,     TRUE,    "total",        "B;M",
    1,      2,    3,     "+",          1,          1,     TRUE,    "total",        "B;Y",
    1,      2,    3,     "+",          1,          2,     TRUE,    "total",        "B;Y",
    1,      2,    3,     "+",          2,          1,     TRUE,    "total",        "B;Y",
    1,      2,    3,     "+",          2,          2,     TRUE,    "total",        "B;Y",
  )

  r
}

test_that("filter_by_filter_info works as expected", {
  r <- create_result()
  expect_error(
    filter_get_count(r, c()),
    "artefacts cannot be 0"
  )
})

test_that("filter_by_filter_info works as expected", {
  r <- create_result()
  expect_equal(
    filter_get_count(r, c("D")),
    nrow(r)
  )
  expect_equal(
    filter_get_count(r, c("B", "M")),
    0
  )
  expect_equal(
    filter_get_count(r, c("M", "Y")),
    0
  )
})
