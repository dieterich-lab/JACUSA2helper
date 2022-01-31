context("unpack_info")

# adjust to GenomicRanges
test_that("unpack_info works as expected", {
  data <- tidyr::tribble(
    ~contig, ~start, ~end, ~strand, ~info,
     "chr1",      1,    2,     ".", "var;varx1;vary11;vary21",
     "chr1",      2,    3,     ".", "varz1=123;varz2=123",
  )

  expected <- tidyr::tribble(
    ~contig, ~start, ~end, ~strand,  ~var, ~varx1,  ~vary11,  ~vary21, ~varz1, ~varz2,
     "chr1",      1,    2,     ".", "var", "varx1", "vary11", "vary21",     NA,     NA,
     "chr1",      2,    3,     ".",    NA,     NA,        NA,       NA,    123,    123,
  )
  expected$info <- data$info
  for (col in c("var", "varx1", "vary11", "vary21")) {
    expected[[col]] <- as.character(expected[[col]])
  }
  for (col in c("varz1", "varz2")) {
    expected[[col]] <- as.character(expected[[col]])
  }
  expected <- expected[c("contig", "start", "end", "strand", "info", "var", "varx1", "vary11", "vary21", "varz1", "varz2")]

  expect_equal(
    unpack_info(data, 2, c("var", "vary11", "vary21", "varz1", "varz2"), 1),
    expected
  )
})