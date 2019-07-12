context("guess_conditions")

test_that("guess_conditions fails on unknown method type", {
  expect_error(guess_conditions(UNKNOWN_METHOD_TYPE, c()), "Unknown type: *")
  expect_error(guess_conditions("unknown", c()), "Unknown type: *")
})

create_header_names <- function(prefix, condition, replicates) {
  paste0(prefix, condition, 1:replicates)
}

test_that("guess_conditions works as expected on call-1", {
  expect_equal(
    guess_conditions(
      CALL_PILEUP_METHOD_TYPE, 
      c(create_header_names(BASES_COLUMN, 1, 3))
    ),
    1
  )
})

test_that("guess_conditions works as expected on call-2, pileup", {
  expect_equal(
    guess_conditions(
      CALL_PILEUP_METHOD_TYPE, 
      c(
        create_header_names(BASES_COLUMN, 1, 3),
        create_header_names(BASES_COLUMN, 2, 3)
      )
    ),
    2
  )
})

test_that("guess_conditions works as expected on rt-arrest", {
  expect_equal(
    guess_conditions(
      RT_ARREST_METHOD_TYPE, 
      c(
        create_header_names(ARREST_COLUMN, 1, 3),
        create_header_names(THROUGH_COLUMN, 1, 3),
        create_header_names(ARREST_COLUMN, 2, 3),
        create_header_names(THROUGH_COLUMN, 2, 3)
      )
    ),
    2
  )
})

test_that("guess_conditions works as expected on lrt-arrest", {
  expect_equal(
    guess_conditions(
      LRT_ARREST_METHOD_TYPE, 
      c(
        create_header_names(ARREST_COLUMN, 1, 3),
        create_header_names(THROUGH_COLUMN, 1, 3),
        create_header_names(ARREST_COLUMN, 2, 3),
        create_header_names(THROUGH_COLUMN, 2, 3)
      )
    ),
    2
  )
})
