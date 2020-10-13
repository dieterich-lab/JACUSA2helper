context("helper_filter")

test_that("filter_artefact works as expected", {
  expect_equal(
    filter_artefact(c(.EMPTY, .EMPTY, .EMPTY), "D"),
    c(FALSE, FALSE, FALSE)
  )
  
  expect_equal(
    filter_artefact(c("D", "D;B", .EMPTY), "B"),
    c(FALSE, TRUE, FALSE)
  )
  
  expect_equal(
    filter_artefact(c("D", "D;B", .EMPTY), "D"),
    c(TRUE, TRUE, FALSE)
  )
})
