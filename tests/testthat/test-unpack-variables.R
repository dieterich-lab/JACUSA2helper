context("unpack_variables")

test_that("unpack_variables works as expected", {
  data <- tibble::tribble(
    ~contig, ~start,                     ~info,
     "chr1",      1, "var;varx1;vary11;vary21",
     "chr1",      2,  "varz1=123;varz2=123",
  )
  
  expected <- tibble::tribble(
    ~contig, ~start, ~variable, ~sample, ~value,
     "chr1",      1,     "var",      "",     NA,   
     "chr1",      1,    "varx",       1,     NA,   
     "chr1",      1,    "vary",      11,     NA,   
     "chr1",      1,    "vary",      21,     NA,   
     "chr1",      2,    "varz",       1,  "123",  
     "chr1",      2,    "varz",       2,  "123",
  )
  
  expect_equal(
    unpack_variables(data),
    expected
  )
})