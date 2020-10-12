context("io")

test_that(".unpack works as expected", {
  s <- c(
    "1,2,3,4",
    "5,6,7,8",
    "9,0,1,2"
  )

  expected <- tidyr::tribble(
    ~A, ~C, ~G, ~T,
    1,   2,  3,  4,
    5,   6,  7,  8,
    9,   0,  1,  2
  )
  
  expect_equal(
    .unpack(s, .BASES),
    expected  
  )  
})


test_that(".fill_empty works as expected", {
  df <- tidyr::tribble(
    ~bases,    ~tmp,      ~arrest,
    .EMPTY,    .EMPTY,    "4,3,2,1",
    "1,2,3,4", "5,6,7,8", .EMPTY,
  )
  expected <- tidyr::tribble(
    ~bases,    ~tmp,      ~arrest,
    "0,0,0,0", .EMPTY,    "4,3,2,1",
    "1,2,3,4", "5,6,7,8", "0,0,0,0"
  )

  expect_equal(
    .fill_empty(df, c("bases", "arrest"), .BASES),
    expected  
  )
})


test_that(".base_call works as expected", {
  bases <- tidyr::tribble(
    ~A, ~C, ~G, ~T,
    1,  0,  0,  0,
    0,  1,  0,  0,
    0,  0,  1,  0,
    0,  0,  0,  1,
    1,  1,  1,  1,
  )
  
  expected <- c(
    "A",
    "C",
    "G",
    "T",
    "ACGT"
  )
  
  expect_equal(
    .base_call(bases),
    expected  
  )
})