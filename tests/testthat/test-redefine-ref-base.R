context("redefine_ref_base")

create_result <- function() {
  r <- tibble::tribble(
    ~contig, ~start, ~end, ~strand, ~condition, ~replicate, ~bc, ~ref_base,
          1,      1,    2,     "+",          1,          1, "C",       "A",
          1,      1,    2,     "+",          2,          1, "C",       "A",
          1,      1,    2,     "+",          2,          2, "C",       "A",
  )
  
  r
}

test_that("redefine_ref_base fails on unknown condition", {
  r <- create_result()
  expect_error(
    extract_ref_base(r$condition, r$bc, 3),
    "Unknown ref_condition: *"
  )
})

test_that("extract_ref_base works as expected", {
  r <- create_result()
  expected <- rep("C", 3)
  
  expect_equal(
    extract_ref_base(r$condition, r$bc, 1),
    expected
  )
})
