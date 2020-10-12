context("coverage")

test_that(".cov works as expected", {
  bases <- tidyr::tibble(
    bases1 = tidyr::tribble(
      ~A, ~C, ~G, ~T,
      1,  0,  0,  0,
      0,  1,  0,  0,
      0,  0,  1,  0,
      0,  0,  0,  1,
      1,  1,  1,  1,
    ),
    bases2 = tidyr::tribble(
      ~A, ~C, ~G, ~T,
      1,  0,  0,  0,
      0,  1,  0,  0,
      0,  0,  1,  0,
      0,  0,  0,  1,
      1,  1,  1,  1,
    )
  )

  expected <- tidyr::tibble(
    bases1 = c(1, 1, 1, 1, 4),
    bases2 = c(1, 1, 1, 1, 4),
  )
  
  expect_equal(
    .cov(bases),
    expected  
  )
})
