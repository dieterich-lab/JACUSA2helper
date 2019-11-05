context("helper-sub")

# merge_sub
test_that("merge_sub fails as expected on merging other", {
  expect_error(
    merge_sub(c("A->G", "other")),
    "Cannot merge: *"
  )
})

test_that("merge_sub fails as expected on different ref", {
  expect_error(
    merge_sub(c("A->G", "C->G")),
    "Reference base is required to be identical for all observations: *"
  )
})

test_that("merge_sub work as expected", {
  expect_equal(
    merge_sub(c("A->G", "A->G")),
    "A->G"
  )
  
  expect_equal(
    merge_sub(c("A->G", "A->C")),
    "A->CG"
  )
  
  expect_equal(
    merge_sub(c("A->G", "A->CG")),
    "A->CG"
  )
  
  expect_equal(
    merge_sub(c("A->C", "A->G", "A->T")),
    "A->CGT"
  )
})

# mask_sub
test_that("mask_sub work as expected", {
  expect_equal(
    mask_sub(c("A->G", "A->G", "A->T"), "A->G"),
    c("A->G", "A->G", "other")
  )
  
  expect_equal(
    mask_sub(c("A->G", "A->G", "T->C", "A->T"), c("A->G", "T->C")),
    c("A->G", "A->G", "T->C", "other")
  )
  
})
