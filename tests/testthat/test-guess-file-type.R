context("guess_file_type")


TEST_HEADER_COORD <- "#contig\tstart\tend\tname\t*\tstrand"
TEST_HEADER_INFO <- paste(INFO_COLUMN, FILTER_INFO_COLUMN, sep = "\t")

test_that("guess_file_type fails on missing header line", {
  line <- paste(substring(TEST_HEADER_COORD, 2), TEST_HEADER_INFO, sep = "\t")
  expect_error(guess_file_type(line), "Invalid header line: *")
})

test_that("guess_file_type fails on wrong header line", {
  line <- paste(TEST_HEADER_COORD, TEST_HEADER_INFO, sep = "\t")
  expect_error(
    guess_file_type(line), 
    "Result type could not be guessed from header: *"
  )
})

test_that("guess_file_type recognizes call-1", {
  line <- paste(
    TEST_HEADER_COORD,
    paste0(CALL_PILEUP_COLUMN, "1", 1:3, collapse = "\t"),
    TEST_HEADER_INFO,
    sep = "\t"
  )
  print(line)
  expect_equal(guess_file_type(line), CALL_PILEUP_METHOD_TYPE)
})

test_that("guess_file_type recognizes call-2 and pileup", {
  line <- paste0(
    TEST_HEADER_COORD,
    paste0(CALL_PILEUP_COLUMN, "1", 1:3, collapse = "\t"),
    paste0(CALL_PILEUP_COLUMN, "2", 1:3, collapse = "\t"),
    TEST_HEADER_INFO,
    sep = "\t"
  )
  expect_equal(guess_file_type(line), CALL_PILEUP_METHOD_TYPE)
})

create_condition <-function(condition, replicates, arrest, through) {
  lapply(
    1:replicates, 
    function(replicate) { 
      condition_columns <- paste0(c(arrest, through), condition)
      paste0(condition_columns, replicate, collapse = "\t")
    })%>% paste0(collapse = "\t")
}

test_that("guess_file_type recognizes rt-arrest", {
  line <- paste(
    TEST_HEADER_COORD,
    create_condition(1, 3, RT_ARREST_COLUMN, RT_THROUGH_COLUMN),
    create_condition(2, 3, RT_ARREST_COLUMN, RT_THROUGH_COLUMN),
    TEST_HEADER_INFO,
    sep = "\t", collapse = ""
  )
  expect_equal(guess_file_type(line), RT_ARREST_METHOD_TYPE)
})

test_that("guess_file_type recognizes lrt-arrest", {
  line <- paste(
    TEST_HEADER_COORD,
    LRT_ARREST_POS_COLUMN,
    create_condition(1, 3, LRT_ARREST_COLUMN, LRT_THROUGH_COLUMN),
    create_condition(2, 3, LRT_ARREST_COLUMN, LRT_THROUGH_COLUMN),
    TEST_HEADER_INFO,
    sep = "\t", collapse = ""
  )
  expect_equal(guess_file_type(line), LRT_ARREST_METHOD_TYPE)
})
