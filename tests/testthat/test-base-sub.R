context("base_sub")

test_that("base_sub works as expected", {
  ref <- c("A", "A", "T", "A")
  bc <- c("A", "AG", "C", "ACGT")
  
  expected <- c("no change", "A->G", "T->C", "A->CGT")


  expect_equal(
    base_sub(bc, ref),
    expected
  )
})

test_that("base_sub fails on ", {
  expect_error(
    base_sub("AG", "A->G"),
    "All ref elements must be *"
  )
})
