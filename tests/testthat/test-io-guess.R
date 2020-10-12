context("guess condition count")

create_cond_rep <- function(condition, replicates) {
  paste0(condition, 1:replicates)
}

test_that(".guess_cond_count works as expected", {
  expect_equal(
    .find_cond_count(
      create_cond_rep(1, 2)
    ), 
    1
  )
  expect_equal(
    .find_cond_count(
      c(create_cond_rep(1, 2), create_cond_rep(2, 2))
    ), 
    2
  )
  expect_equal(
    .find_cond_count(
      c(create_cond_rep(1, 10), create_cond_rep(2, 20))
    ), 
    2
  )
})

