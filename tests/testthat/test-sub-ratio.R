context("sub_ratio")

test_that("observed_bc works as expected", {
  expect_equal(
    observed_bc(
      matrix(c(
        c(10, 0, 10, 0),
        c(0, 0, 10, 0),
        c(0, 0, 0, 10),
        c(10, 10, 10, 10),
        c(0, 0, 0, 0)
      ),
      byrow = T, ncol = 4)
    ),
    c("AG", "G", "T", "ACGT", "")
  )
})

test_that("max_observed_bc without ref works as expected", {
  expect_equal(
    max_observed_bc(
      matrix(c(
        c(10, 0, 10, 0),
        c(10, 0, 9, 0),
        c(0, 0, 10, 0),
        c(0, 0, 0, 10),
        c(10, 10, 10, 10),
        c(0, 0, 0, 0)
      ),
      byrow = T, ncol = 4)
    ),
    c("AG", "A", "G", "T", "ACGT", "")
  )
})
  
test_that("max_observed_bc with ref works as expected", {
  expect_equal(
    max_observed_bc(
      matrix(c(
        c(10, 0, 10, 0),
        c(10, 0, 9, 0),
        c(0, 0, 10, 0),
        c(0, 0, 0, 10),
        c(10, 10, 10, 10),
        c(0, 0, 0, 0)
      ),
      byrow = T, ncol = 4), 
      c("A", "A", "A", "T", "C", "G")
    ),
    c("G", "G", "G", "", "AGT", "")
  )
})

test_that("variant_bc works as expected", {
  expect_equal(
    variant_bc(
      c("A", "A", "A", "T", "C", "G"),
      c("AG", "A", "AC", "AT", "AC", "GT")
    ),
    c("G", "", "C", "A", "A", "T")
  )
})


test_that("variant_bc fails on > 2 alleles", {
  expect_error(
    variant_bc(
      c("A"),
      c("AGC")
    ),
    "More than 2 alleles not supported! ref: *"
  )
  expect_error(
    variant_bc(
      c("A"),
      c("GC")
    ),
    "More than 2 alleles not supported! ref: *"
  )
})

test_that("sub_ratio fails on > 2 alleles", {
  expect_error(
    sub_ratio(
     c("A"),
     matrix(c(
       c(0, 10, 10, 0)
     ),
     byrow = T, ncol = 4)
   ),
   "More than 2 alleles not supported! ref: *"
 )
 expect_error(
   sub_ratio(
     c("A"),
     matrix(c(
       c(10, 10, 10, 0)
     ),
     byrow = T, ncol = 4)
   ),
   "More than 2 alleles not supported! ref: *"
 )
})

test_that("sub_ratio works as expected", {
   expect_equal(
     sub_ratio(
      c("A"),
      matrix(c(
        c(10, 0, 10, 0)
      ),
      byrow = T, ncol = 4)
    ),
    c(0.5)
  )
  expect_equal(
    sub_ratio(
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
    sub_ratio(
      c("A", "A"),
      matrix(c(
        c(10, 0, 10, 0),
        c(10, 0, 0, 0)
      ),
      byrow = T, ncol = 4)
    ),
    c(0.5, 0.0)
  )
  expect_equal(
    sub_ratio(
      c("A", "A"),
      matrix(c(
        c(10, 0, 10, 0),
        c(10, 0, 0, 0)
        ),
        byrow = T, ncol = 4
      ), c("T", "T")
    ),
    c(0.0, 0.0)
  )
  expect_equal(
    sub_ratio(
      c("T", "T"),
      matrix(c(
        c(10, 10, 10, 10),
        c(0, 5, 0, 0)
      ),
      byrow = T, ncol = 4
      ), c("C", "C")
    ),
    c(0.25, 1.0)
  )
})
