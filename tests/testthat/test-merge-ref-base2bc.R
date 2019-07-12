context("merge_ref_base2bc")

test_that("merge_ref_base2bc fails on > 1 reference bases", {
  expect_error(
    merge_ref_base2bc(c("A->G", "C->G")),
    "Reference base is required to be identical for all observations: *"
  )
})

test_that("merge_ref_base2bc fails on merging other and e.g. A->G", {
  expect_error(
    merge_ref_base2bc(c("A->G", "other")),
    "Cannot merge: *"
  )
})

test_that("merge_ref_base2bc works as expected", {
  expect_equal(
    merge_ref_base2bc(c("A->G", "A->CT")),
    c("A->CGT")
  )
  expect_equal(
    merge_ref_base2bc(c("A->T", "A->G", "A->C")),
    c("A->CGT")
  )
  expect_equal(
    merge_ref_base2bc(c("A->T", "A->GT")),
    c("A->GT")
  )
  expect_equal(
    merge_ref_base2bc(c("A->T", BC_CHANGE_NO_CHANGE)),
    c("A->T")
  )
  expect_equal(
    merge_ref_base2bc(c(BC_CHANGE_OTHER, BC_CHANGE_NO_CHANGE)),
    c(BC_CHANGE_OTHER)
  )
})
