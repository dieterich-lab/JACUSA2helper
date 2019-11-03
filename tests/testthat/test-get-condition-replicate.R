context("get_condition_replicate")

test_that("get_condition_replicate fails on unknown method type", {
  expect_error(get_condition_replicate(UNKNOWN_METHOD_TYPE, c()), "Unknown type: *")
  expect_error(get_condition_replicate("unknown", c()), "Unknown type: *")
})

create_header_names <- function(prefix, condition, replicates) {
  paste0(prefix, condition, 1:replicates)
}

test_that("get_condition_replicate works as expected on call-1", {
  expect_equal(
    get_condition_replicate(
      CALL_PILEUP_METHOD_TYPE, 
      c(create_header_names(BASES_COLUMN, 1, 3))
    ),
    c(11, 12, 13) %>% as.character()
  )
})

test_that("get_condition_replicate works as expected on call-2, pileup", {
  expect_equal(
    get_condition_replicate(
      CALL_PILEUP_METHOD_TYPE, 
      c(
        create_header_names(BASES_COLUMN, 1, 3),
        create_header_names(BASES_COLUMN, 2, 3)
      )
    ),
    c(11, 12, 13, 21, 22, 23) %>% as.character()
  )
})

test_that("get_condition_replicate works as expected on rt-arrest", {
  expect_equal(
    get_condition_replicate(
      RT_ARREST_METHOD_TYPE, 
      c(
        create_header_names(ARREST_COLUMN, 1, 3),
        create_header_names(THROUGH_COLUMN, 1, 3),
        create_header_names(ARREST_COLUMN, 2, 3),
        create_header_names(THROUGH_COLUMN, 2, 3)
      )
    ),
    c(11, 12, 13, 21, 22, 23) %>% as.character()
  )
})

test_that("get_condition_replicate works as expected on lrt-arrest", {
  expect_equal(
    get_condition_replicate(
      LRT_ARREST_METHOD_TYPE, 
      c(
        create_header_names(ARREST_COLUMN, 1, 3),
        create_header_names(THROUGH_COLUMN, 1, 3),
        create_header_names(ARREST_COLUMN, 2, 3),
        create_header_names(THROUGH_COLUMN, 2, 3)
      )
    ),
    c(11, 12, 13, 21, 22, 23) %>% as.character()
  )
})
