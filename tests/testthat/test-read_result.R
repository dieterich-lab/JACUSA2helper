context("read_result")

# TODO
# correct number of conditions -> call-1 call-2

test_that("read_result works on call-1 output", {
  # TODO
})

test_that("read_result works on call-2 output", {
  j <- read_result("call-2.out")
})

test_that("read_result works on pileup output", {
  # TODO
})

test_that("read_result works on rt-arrest output", {
  # TODO
})

test_that("read_result works on lrt-arrest output", {
  # TODO
})

test_that("read_result fails on unknown method type", {
  file <- "unknown-type.out"
  r <- NULL
  expect_error(r <- read_result(file), "Result type could not be guessed from header: *")
})

test_that("read_result fails on missing header", {
  file <- "call-2-missing-header.out"
  r <- NULL
  expect_error(r <- read_result(file), "No header line for file: *")
})