context(".guess_cond_count")

test_that(".extract_cond_repl fails on unknown method type", {
  expect_error(.guess_cond_count(.UNKNOWN_METHOD, c()), "Unknown type: *")
  expect_error(.guess_cond_count("unknown", c()), "Unknown type: *")
})

create_header_names <- function(prefix, condition, replicates) {
  paste0(prefix, condition, 1:replicates)
}

test_that(".guess_cond_count works as expected on call-1", {
  expect_equal(
    .guess_cond_count(
      .CALL_PILEUP, 
      c(create_header_names(.CALL_PILEUP_COL, 1, 3))
    ),
    1
  )
})

test_that(".guess_cond_count works as expected on call-2, pileup", {
  expect_equal(
    .guess_cond_count(
      .CALL_PILEUP, 
      c(
        create_header_names(.CALL_PILEUP_COL, 1, 3),
        create_header_names(.CALL_PILEUP_COL, 2, 3)
      )
    ),
    2
  )
})

test_that(".guess_cond_count works as expected on rt-arrest", {
  expect_equal(
    .guess_cond_count(
      .RT_ARREST, 
      c(
        create_header_names(.ARREST_COL, 1, 3),
        create_header_names(.THROUGH_COL, 1, 3),
        create_header_names(.ARREST_COL, 2, 3),
        create_header_names(.THROUGH_COL, 2, 3)
      )
    ),
    2
  )
})

test_that(".guess_cond_count works as expected on lrt-arrest", {
  expect_equal(
    .guess_cond_count(
      .LRT_ARREST, 
      c(
        create_header_names(.ARREST_COL, 1, 3),
        create_header_names(.THROUGH_COL, 1, 3),
        create_header_names(.ARREST_COL, 2, 3),
        create_header_names(.THROUGH_COL, 2, 3)
      )
    ),
    2
  )
})
