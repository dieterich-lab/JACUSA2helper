context(".find_conditions")

.create_cond_rep <- function(condition, replicates) {
  paste0(condition, 1:replicates)
}

test_that(".find_conditions works as expected", {
  expect_equal(
    .find_conditions(
      .create_cond_rep(1, 2)
    ), 
    1
  )
  expect_equal(
    .find_conditions(
      c(.create_cond_rep(1, 2), .create_cond_rep(2, 2))
    ), 
    2
  )
  expect_equal(
    .find_conditions(
      c(.create_cond_rep(1, 10), .create_cond_rep(2, 20))
    ), 
    2
  )
})