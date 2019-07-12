context("add_ref_base2bc")

create_result <- function() {
  r <- tibble::tribble(
    ~contig, ~start, ~end, ~strand, ~condition, ~replicate, ~primary, ~base_type, ~bc, ~ref_base,
          1,      1,    2,     "+",          1,          1,     TRUE,    "total", "A",       "A",
          1,      1,    2,     "+",          1,          2,     TRUE,    "total", "AG",       "A",
  )
  
  r
}

test_that("add_ref_base2bc fails on unknown ref_field", {
  r <- create_result()
  expect_error(
    add_ref_base2bc(r, "unknown"),
    "Unknown ref_field: *"
  )
})

test_that("add_ref_base2bc fails on unknown condition", {
  r <- create_result()
  expect_error(
    add_ref_base2bc(r, 2),
    "Unknown condition: *"
  )
})

test_that("add_ref_base2bc works as expected on ref_base", {
  r <- create_result()
  expected <- r
  expected$ref_base2bc <- c(BC_CHANGE_NO_CHANGE, "A->G") 
  
  expect_equal(
    add_ref_base2bc(r, "ref_base"),
    expected  
  )
})

test_that("add_ref_base2bc works as expected of condition", {
  r1 <- create_result()
  #
  r2 <- create_result()
  r2[["condition"]] <- c(2, 2)
  r2[["bc"]] <- c("A", "A")
  #
  r <- dplyr::bind_rows(r1, r2)

  expected <- r
  expected$ref_base2bc <- c(
    BC_CHANGE_NO_CHANGE, 
    "A->G", 
    BC_CHANGE_NO_CHANGE, 
    BC_CHANGE_NO_CHANGE
  ) 

  expect_equal(
    add_ref_base2bc(r, 2),
    expected  
  )
})