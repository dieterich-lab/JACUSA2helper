context("read_result")

test_that("read_result works on call-1 output", {
  expect_true({
    read_result("call-1.out"); TRUE
  })
})

test_that("read_result works on call-2 output", {
  expect_true({
    read_result("call-2.out"); TRUE
  })
})

test_that("read_result works on pileup output", {
  expect_true({
    read_result("pileup.out"); TRUE
  })
})

test_that("read_result works on rt-arrest output", {
  expect_true({
    read_result("rt-arrest.out"); TRUE
  })
})

test_that("read_result works on lrt-arrest output", {
  expect_true({
    read_result("lrt-arrest.out"); TRUE
  })
})

test_that("read_result fails on unknown method type", {
  file <- "unknown-type.out"
  expect_error(read_result(file), "Result type could not be guessed from header: *")
})

test_that("read_result fails on missing header", {
  file <- "call-2-missing-header.out"
  expect_error(read_result(file), paste0("No header line for file: ", file))
})
