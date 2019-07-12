context("robust_arrest_events_helper")

create_helper <- function(condition, mat) {
  n <- nrow(mat)
  coverage <- c(t(cbind(rowSums(mat), mat[, 1], mat[, 2])))
  data.frame(
    primary = TRUE,
    base_type = rep(c("total", ARREST_COLUMN, THROUGH_COLUMN), n),
    condition = condition,
    replicate = rep(1:n, each = 3),
    coverage = coverage,
    stringsAsFactors = FALSE
  )
}

create <- function(condition1, condition2) {
  condition1 <- matrix(condition1, byrow = T, ncol = 2)
  condition2 <- matrix(condition2, byrow = T, ncol = 2)
  
  df <- create_helper(1, condition1)
  df <- rbind(df, create_helper(2, condition2))

  df
}

test_that("robust_arrest_events_helper works on 2 condition", {
  df <- create(
    c(
      0, 1,
      0, 1
    ),
    c(
      1, 1,
      1, 1
    )
  )
  expect_equal(
    robust_arrest_events_helper(
      df$primary,
      df$base_type,
      df$condition,
      df$replicate,
      df$coverage
    ),
    TRUE
  )
  
  df <- create(
    c(
      0, 1,
      0, 1
    ),
    c(
      1, 0,
      1, 0
    )
  )
  expect_equal(
    robust_arrest_events_helper(
      df$primary,
      df$base_type,
      df$condition,
      df$replicate,
      df$coverage
    ),
    TRUE
  )
  
  df <- create(
    c(
      0, 1,
      0, 1
    ),
    c(
      0, 1,
      1, 1
    )
  )
  expect_equal(
    robust_arrest_events_helper(
      df$primary,
      df$base_type,
      df$condition,
      df$replicate,
      df$coverage
    ),
    FALSE
  )
})
