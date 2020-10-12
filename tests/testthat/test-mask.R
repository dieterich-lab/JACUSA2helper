context("robust")


test_that(".mask_any works as expected on any 1 condition", {
  input1 <- tidyr::tribble(
    ~A, ~C, ~G, ~T,
     1,  0,  0,  0,
     0,  1,  0,  0, 
     0,  0,  1,  0, 
     0,  0,  0,  1
  )
  input2 <- tidyr::tribble(
    ~A, ~C, ~G, ~T,
     1,  0,  0,  1,
     0,  1,  0,  0, 
     0,  0,  1,  0, 
     1,  0,  0,  1
  )
  input <- tidyr::tibble(
    "cond1" = tidyr::tibble(
      "rep1" = input1,
      "rep2" = input2,
    )
  )
  expected <- tidyr::tribble(
    ~A, ~C, ~G, ~T,
     1,  0,  0,  1,
     0,  1,  0,  0, 
     0,  0,  1,  0, 
     1,  0,  0,  1
  ) %>% apply(c(1, 2), as.logical) %>% 
    tidyr::as_tibble()
  
  expect_equal(.mask_any(input), expected)
})

test_that(".mask_all works as expected on any 1 condition", {
  input1 <- tidyr::tribble(
    ~A, ~C, ~G, ~T,
    1,  0,  0,  0,
    0,  1,  0,  0, 
    0,  0,  1,  0, 
    0,  0,  0,  1
  )
  input2 <- tidyr::tribble(
    ~A, ~C, ~G, ~T,
    1,  0,  0,  1,
    0,  1,  0,  0, 
    0,  0,  1,  0, 
    1,  0,  0,  1
  )
  input <- tidyr::tibble(
    "cond1" = tidyr::tibble(
      "rep1" = input1,
      "rep2" = input2,
    )
  )
  expected <- tidyr::tribble(
    ~A, ~C, ~G, ~T,
    1,  0,  0,  0,
    0,  1,  0,  0, 
    0,  0,  1,  0, 
    0,  0,  0,  1
  ) %>% apply(c(1, 2), as.logical) %>% 
    tidyr::as_tibble()
  
  expect_equal(.mask_all(input), expected)
})
