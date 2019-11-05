context("redefine_ref")

create_result <- function() {
  r <- tibble::tribble(
    ~contig, ~start, ~end, ~strand, ~cond, ~repl, ~bc, ~ref,
          1,      1,    2,     "+",     1,     1, "C",  "A",
          1,      1,    2,     "+",     2,     1, "C",  "A",
          1,      1,    2,     "+",     2,     2, "C",  "A",
  )
  
  r
}

test_that("redefine_ref fails on unknown condition", {
  r <- create_result()
  expect_error(
    extract_ref(r[[CONDITION_COLUMN]], r[[BC]], 3),
    "Unknown ref_condition: *"
  )
})

test_that("extract_ref works as expected", {
  r <- create_result()
  expected <- rep("C", 3)
  
  expect_equal(
    extract_ref(r[[CONDITION_COLUMN]], r[[BC]], 1),
    expected
  )
})
