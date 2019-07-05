context("add_data_desc")

test_that("add_data_desc fails on wrong format", {
  error_msg <- "Invalid format for data description: *"
  
  expect_error(
    add_data_desc(c(), c(), ""),
    error_msg
  )
  
  expect_error(
    add_data_desc(c(), c(), "unknown"),
    error_msg
  )
  
  expect_error(
    add_data_desc(c(), c(), "%CONDITION%"),
    error_msg
  )
  
  expect_error(
    add_data_desc(c(), c(), "%REPLICATE%"),
    error_msg
  )
})

test_that("add_data_desc_default fails on wrong number of conditions", {
  error_msg <- "condition_desc does not match number of conditions: *"
  
  # actual 1 vs. expected 2 conditions
  expect_error(
    add_data_desc_default(
      result <- data.frame(
        condition <- c(1, 1),
        stringsAsFactors = FALSE
      ), 
      condition_desc <- c("Cond1", "Cond2")
    ),
    error_msg
  )
  
  # actual 2 vs. expected 1 conditions
  expect_error(
    add_data_desc_default(
      result <- data.frame(
        condition <- c(1, 2),
        stringsAsFactors = FALSE
      ), 
      condition_desc <- c("Cond1")
    ),
    error_msg
  )
})

test_that("add_data_desc_meta_condition works as expected", {
  condition_desc <- list()
  condition_desc[["meta1"]] <- c("Cond1", "Cond2")
  condition_desc[["meta2"]] <- c("CondA", "CondB")
  
  result <- data.frame(
    contig = rep(1, 4),
    start = rep(1, 4),
    end = rep(2, 4),
    strand = rep("+", 4),
    meta_condition = as.factor(rep(c("meta1", "meta2"), each = 2)),
    condition = rep(c(1, 2), 2),
    replicate = rep(1, 4),
    stringsAsFactors = FALSE
  )
  
  actual <- add_data_desc_meta_condition(result, condition_desc, "%CONDITION%_%REPLICATE%") %>%
    dplyr::select(!!DATA_DESC) %>% dplyr::pull()
  expected <- c("Cond1_1", "Cond2_1", "CondA_1", "CondB_1")
  expect_equal(actual, expected)
})

test_that("format_data_desc works as expected", {
  format <- "%CONDITION%_%REPLICATE%"
  condition_desc <- c("Cond1", "Cond2")
  condition <- c(1, 1, 2, 2)
  replicate <- c(1, 2, 1, 2)
  expected <- c(
    "Cond1_1", "Cond1_2",
    "Cond2_1", "Cond2_2"
  )
  
  expect_equal(
    format_data_desc(condition_desc, condition, replicate, format),
    expected
  )
})
