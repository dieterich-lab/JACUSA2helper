context("get_site_count")

# TODO
# lrt-arrest

create_call <- function(conditions, replicates, positions, primary = TRUE, base_type = "total") {
  sites <- length(positions)
  n <- sites * replicates * conditions
  data.frame(
    contig = rep(1, n),
    start = rep(positions, each = replicates),
    end = rep(positions + 1, each = replicates),
    strand = rep("+", n),
    primary = rep(primary, n),
    base_type = rep(base_type, n),
    condition = rep(1:conditions, each = sites * replicates),
    replicate = rep(1:replicates, sites),
    stringsAsFactors = FALSE
  )
}

create_rt_arrest <- function(conditions, replicates, positions) {
  df_total <- create_call(conditions, replicates, positions)
  df_arrest <- create_call(conditions, replicates, positions, primary = FALSE, base_type = "arrest")
  df_through <- create_call(conditions, replicates, positions, primary = FALSE, base_type = "through")
  
  rbind(df_total, df_arrest, df_through)
}

test_that("get_site_count works as expected on call pileup", {
  # no meta condition
  expect_equal(
    get_site_count(
      create_call(1, 1, 1:2)
    ), 2
  )
  expect_equal(
    get_site_count(
      create_call(2, 2, 1:2)
    ), 2
  )
  
  # with meta conditions
  df1 <- create_call(2, 2, 1:2)
  df1$meta_condition <- 1
  #
  df2 <- create_call(2, 2, 3:5)
  df2$meta_condition <- 2
  #
  df <- rbind(df1, df2)
  expect_equal(
    get_site_count(df),
    data.frame(meta_condition = c(1, 2), n = as.integer(c(2, 3)), stringsAsFactors = FALSE)
  )
})

test_that("get_site_count works as expected on rt-arrest", {
  # no meta condition
  expect_equal(
    get_site_count(
      create_rt_arrest(1, 1, 1:2)
    ), 2
  )
  expect_equal(
    get_site_count(
      create_rt_arrest(2, 2, 1:2)
    ), 2
  )
  
  # with meta conditions
  df1 <- create_call(2, 2, 1:2)
  df1$meta_condition <- 1
  #
  df2 <- create_call(2, 2, 3:5)
  df2$meta_condition <- 2
  #
  df <- rbind(df1, df2)
  expect_equal(
    get_site_count(df),
    data.frame(meta_condition = c(1, 2), n = as.integer(c(2, 3)), stringsAsFactors = FALSE)
  )
})
