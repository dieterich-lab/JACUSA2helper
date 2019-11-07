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

test_that("redefine_ref works as expected", {
  df <- tibble::tribble(
    ~contig, ~start, ~end, ~strand, ~cond, ~bc, ~ref,
      "chr",      1,    2,     ".",     1, "A",  "T",
      "chr",      1,    2,     ".",     1, "A",  "T",
      "chr",      1,    2,     ".",     2,"AG",  "T",
      "chr",      1,    2,     ".",     2,"AG",  "T",
      "chr",      2,    3,     ".",     1, "C",  "C",
      "chr",      2,    3,     ".",     1, "C",  "C",
      "chr",      2,    3,     ".",     2,"CT",  "C",
      "chr",      2,    3,     ".",     2,"CT",  "C",
  )
  expected <- df
  expected$ref <- c(rep("A", 4), rep("C", 4))
  
  expect_equal(
    redefine_ref(df, ref_cond = 1),
    expected
  )
})

test_that("extract_ref fails on unknown condition", {
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
