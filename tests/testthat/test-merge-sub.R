context("merge_sub")

test_that("merge_sub fails on > 1 reference bases", {
  expect_error(
    merge_sub(c("A->G", "C->G")),
    "Reference base is required to be identical for all observations: *"
  )
})

test_that("merge_sub fails on merging other and e.g. A->G", {
  expect_error(
    merge_sub(c("A->G", "other")),
    "Cannot merge: *"
  )
})

test_that("merge_sub works as expected", {
  expect_equal(
    merge_sub(c("A->G", "A->CT")),
    c("A->CGT")
  )
  expect_equal(
    merge_sub(c("A->T", "A->G", "A->C")),
    c("A->CGT")
  )
  expect_equal(
    merge_sub(c("A->T", "A->GT")),
    c("A->GT")
  )
  expect_equal(
    merge_sub(c("A->T", .SUB_NO_CHANGE)),
    c("A->T")
  )
  expect_equal(
    merge_sub(c(.SUB_OTHER, .SUB_NO_CHANGE)),
    c(.SUB_OTHER)
  )
})
