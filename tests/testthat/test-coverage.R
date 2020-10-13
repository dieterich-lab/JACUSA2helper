context("coverage")

test_that("coverageworks as expected", {
  cond1 <- tidyr::tibble(
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
    cond1=tidyr::tibble(
      bases1 = c(1, 1, 1, 1, 4),
      bases2 = c(1, 1, 1, 1, 4),
    )
  )
  
  actual <- tidyr::tibble(cond1=cond1)
  
  expect_equal(
    as.matrix(coverage(actual)),
    as.matrix(expected)
  )
})
