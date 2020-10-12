context("unpack_info")

test_that(".unpack_info works as expected", {
  data <- tidyr::tribble(
    ~contig, ~start, ~end, ~strand, ~info,
     "chr1",      1,    2,     ".", "var;varx1;vary11;vary21",
     "chr1",      2,    3,     ".", "varz1=123;varz2=123",
  )
  data$id <- .id(data)
  
  expected <- tidyr::tribble(
    ~contig, ~start, ~end, ~strand,  ~var, ~varx1,  ~vary11,  ~vary21, ~varz1, ~varz2,
     "chr1",      1,    2,     ".", "var", "varx1", "vary11", "vary21",     NA,     NA,
     "chr1",      2,    3,     ".",    NA,     NA,        NA,       NA,    123,    123,
  )
  expected$id <- data$id
  expected$info <- data$info
  for (col in c("var", "varx1", "vary11", "vary21")) {
    expected[[col]] <- as.character(expected[[col]])
  }
  for (col in c("varz1", "varz2")) {
    expected[[col]] <- as.character(expected[[col]])
  }

  expect_equal(
    .unpack_info(data, 2, 1),
    expected
  )
})