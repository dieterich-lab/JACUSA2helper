context("get_ref_base2bc_ratio")

test_that("get_ref_base2bc fails on > 2 alleles", {
  expect_error(
    get_ref_base2bc_ratio(
      c("A"), 
      matrix(c(
        c(0, 10, 10, 0)
      ),
      byrow = T, ncol = 4)
    ),
    "More than 2 alleles not supported! ref: *"
  )
  expect_error(
    get_ref_base2bc_ratio(
      c("A"), 
      matrix(c(
        c(10, 10, 10, 0)
      ),
      byrow = T, ncol = 4)
    ),
    "More than 2 alleles not supported! ref: *"
  )
})

test_that("get_ref_base2bc works as expected", {
  expect_equal(
    get_ref_base2bc_ratio(
      c("A"), 
      matrix(c(
        c(10, 0, 10, 0)
      ),
      byrow = T, ncol = 4)
    ),
    c(0.5)
  )
  expect_equal(
    get_ref_base2bc_ratio(
      c("A", "A"), 
      matrix(c(
        c(10, 0, 10, 0),
        c(0, 0, 10, 0)
      ),
      byrow = T, ncol = 4)
    ),
    c(0.5, 1.0)
  )
  expect_equal(
    get_ref_base2bc_ratio(
      c("A", "A"), 
      matrix(c(
        c(10, 0, 10, 0),
        c(10, 0, 0, 0)
      ),
      byrow = T, ncol = 4)
    ),
    c(0.5, 0.0)
  )
})
