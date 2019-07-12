context("add_ref_base2bc_ratio")

test_that("add_ref_base2bc_ratio fails on > 1 alleles", {
  r <- tibble::tribble(
    ~contig, ~start, ~end, ~strand, ~condition, ~replicate, ~primary, ~base_type, ~bc, ~ref_base,
          1,      1,    2,     "+",          1,          1,     TRUE,    "total", "G",       "A",
          1,      1,    2,     "+",          1,          2,     TRUE,    "total", "CG",      "A",
  )
  r <- add_ref_base2bc(r, ref_field = "ref_base")
  expect_error(
    add_ref_base2bc_ratio(r),
    "More than 1 allele for observed base call is not allowed!"
  )
  
  r <- tibble::tribble(
    ~contig, ~start, ~end, ~strand, ~condition, ~replicate, ~primary, ~base_type, ~bc, ~ref_base, ~ref_base2bc,
          1,      1,    2,     "+",          1,          1,     TRUE,    "total", "G",       "A",       "A->G",
          1,      1,    2,     "+",          1,          2,     TRUE,    "total", "G",      "AG",      "AG->G",
  )
  expect_error(
    add_ref_base2bc_ratio(r),
    "More than 1 allele for reference base is not allowed!"
  )
})

test_that("add_ref_base2bc_ratio works correctly", {
  r <- tibble::tribble(
    ~contig, ~start, ~end, ~strand, ~condition, ~replicate, ~primary,       ~base_type,  ~bc, ~ref_base, ~bc_A, ~bc_C, ~bc_G, ~bc_T, 
          1,      1,    2,     "+",          1,          1,     TRUE,          "total", "AG",       "A",    10,     0,    10,     0,
          1,      1,    2,     "+",          1,          1,     FALSE,   ARREST_COLUMN,  "G",       "A",     0,     0,    10,     0,
          1,      1,    2,     "+",          1,          1,     FALSE,  THROUGH_COLUMN,  "A",       "A",    10,     0,     0,     0,
          1,      1,    2,     "+",          1,          2,     TRUE,          "total",  "G",       "A",    10,     0,     5,     0,
          1,      1,    2,     "+",          1,          2,     FALSE,   ARREST_COLUMN,  "G",       "A",     5,     0,     2,     0,
          1,      1,    2,     "+",          1,          2,     FALSE,  THROUGH_COLUMN,  "G",       "A",     5,     0,     3,     0,
  )
  r <- add_ref_base2bc(r, ref_field = "ref_base")
  r <- add_ref_base2bc_ratio(r)
  expect_equal(
    r[["ref_base2bc_ratio"]],
    c(10 / 20, 10 / 10, 0 / 10, 5 / 15, 2 / 7, 3 / 8)
  )
})
