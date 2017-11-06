context("get_bc_change")

test_that("get_bc_change works as expected on no replicates in DNA", {
  # create test data
  l <- list(
    bases11 = c("10,0,0,0", "0,0,0,10", "5,0,0,0"),
    bases21 = c("5,5,0,0", "0,0,5,10", "0,1,0,0"),
    bases22 = c("5,10,0,0", "0,0,10,10", "0,1,0,0")
  )
  l <- add_bc_matrix(l)
  l <- add_bc(l)

  expect_equal(
    format_bc_change(c("A", "T", "A"), c("C", "G", "C")), 
    get_bc_change(l$bc1, l$bc2))
})

test_that("get_bc_change works as expected on no replicates in DNA", {
  # create test data
  l <- list(
    bases11 = c("10,0,0,0", "0,0,0,10", "5,0,0,0"),
    bases12 = c("5,0,0,0", "0,0,0,20", "1,0,0,0"),
    bases21 = c("5,5,0,0", "0,0,5,10", "0,1,0,0"),
    bases22 = c("5,10,0,0", "0,0,10,10", "0,1,0,0")
  )
  l <- add_bc_matrix(l)
  l <- add_bc(l)
  
  expect_equal(
    format_bc_change(c("A", "T", "A"), c("C", "G", "C")), 
    get_bc_change(l$bc1, l$bc2))
})