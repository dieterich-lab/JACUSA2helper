context("base_sub")

test_that("base_sub works as expected", {
  ref_base <- c("A", "A", "T", "A")
  bc <- c("A", "AG", "C", "ACGT")
  
  expected <- c(
    BC_CHANGE_NO_CHANGE,
    paste("A", "G", sep = BC_CHANGE_SEP),
    paste("T", "C", sep = BC_CHANGE_SEP),
    paste("A", "CGT", sep = BC_CHANGE_SEP)
  )

  expect_equal(
    base_sub(ref_base, bc),
    expected
  )
})

test_that("base_sub fails on ", {
  expect_error(
    base_sub("AG", paste("A", "G", sep = BC_CHANGE_SEP)),
    "All ref_base elements must be *"
  )
})