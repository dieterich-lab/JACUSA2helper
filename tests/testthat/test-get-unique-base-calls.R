context(".get_unique_base_calls")

test_that(".get_unique_base_calls works as expected", {
  expect_equal(
    .get_unique_base_calls(c("A", "AC")),
    c("A", "C")
  )
  expect_equal(
    .get_unique_base_calls(c("A", "A")),
    c("A")
  )
  expect_equal(
    .get_unique_base_calls(c("AC", "AG")),
    c("A", "C", "G")
  )
})