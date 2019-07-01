context("add_ref_base2bc")

test_that("add_ref_base2bc fails on unknown ref_field", {
  expect_error(
    add_ref_base2bc(
      data.frame(
        id = c(1, 1),
        bc = c("G", "G"),
        condition = c(1, 1), 
        ref_base = c("A", "A"),
        stringsAsFactors = FALSE
      ), 
      "unknown"
    ),
    "Unknown ref_field: *"
  )
})

test_that("add_ref_base2bc fails on unknown condition", {
  expect_error(
    add_ref_base2bc(
      data.frame(
        id = c(1, 1),
        bc = c("G", "G"),
        condition = c(1, 1), 
        ref_base = c("A", "A"),
        stringsAsFactors = FALSE
      ), 2
    ),
    "Unknown ref_field: *"
  )
})

test_that("add_ref_base2bc fails on > 2 alleles", {
  expect_error(
    add_ref_base2bc(
      data.frame(
        condition = c(1, 1), 
        id = c(1, 1), 
        bc = c("AC", "G"),
        ref_base = c("A", "A"),
        stringsAsFactors = FALSE
      ), 1
    ),
    "Sites with alleles > 2 not allowed"
  )
})

test_that("add_ref_base2bc fails on 2 conditions when using ref_base", {
  result <- data.frame(
    condition = c(1, 1, 2, 2), 
    id = c(1, 1, 1, 1), 
    bc = c("A", "G", "T", "T"),
    ref_base = c("A", "A", "C", "C"),
    stringsAsFactors = FALSE
  )
  expected <- result
  expected$ref_base2bc <- c("no change", "A->G", "C->T", "C->T") 
  
  expect_error(
    add_ref_base2bc(result, "ref_base"),
    "Sites with alleles > 2 not allowed"
  )
})

test_that("add_ref_base2bc works as expected on ref_base", {
  result <- data.frame(
    condition = c(1, 1), 
    id = c(1, 1), 
    bc = c("A", "G"),
    ref_base = c("A", "A"),
    stringsAsFactors = FALSE
  )
  expected <- result
  expected$ref_base2bc <- c("no change", "A->G") 
  
  expect_equal(
    add_ref_base2bc(result, "ref_base"),
    expected  
  )
})

test_that("add_ref_base2bc works as expected of condition", {
  result <- data.frame(
    condition = c(1, 1, 2, 2), 
    id = c(1, 1, 1, 1), 
    bc = c("A", "G", "A", "A"),
    ref_base = c("A", "A", "A", "A"),
    stringsAsFactors = FALSE
  )
  expected <- result
  expected$ref_base2bc <- c(
    .BC_CHANGE_NO_CHANGE, 
    "A->G", 
    .BC_CHANGE_NO_CHANGE, 
    .BC_CHANGE_NO_CHANGE
  ) 

  expect_equal(
    add_ref_base2bc(result, 2),
    expected  
  )
})