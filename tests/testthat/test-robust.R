context("robust")

test_that("robust works on 1 condition", {
  m_true <- matrix(
    c(0, 1,
      0, 1
    ),
    ncol = 2,
    byrow = TRUE
  )
  expect_equal(
    robust(
      rep(1, nrow(m_true)), 
      m_true
    ), 
    TRUE
  )

  m_true <- matrix(
    c(1, 0,
      1, 0
    ),
    ncol = 2,
    byrow = TRUE
  )
  expect_equal(
    robust(
      rep(1, nrow(m_true)), 
      m_true
    ), 
    TRUE
  )
  
  m_true <- matrix(
    c(1, 1,
      1, 1
    ),
    ncol = 2,
    byrow = TRUE
  )
  expect_equal(
    robust(
      rep(1, nrow(m_true)), 
      m_true
    ), 
    TRUE
  )
  
  m_false <- matrix(
    c(0, 1,
      1, 0
    ),
    ncol = 2,
    byrow = TRUE
  )
  expect_equal(
    robust(
      rep(1, nrow(m_false)), 
      m_false
    ), 
    FALSE
  )
})

test_that("robust works on 2 condition", {
  m1 <- matrix(
    c(0, 1,
      0, 1
    ),
    ncol = 2,
    byrow = TRUE
  )
  m2 <- matrix(
    c(1, 0,
      1, 0
    ),
    ncol = 2,
    byrow = TRUE
  )
  expect_equal(
    robust(
      c(rep(1, nrow(m1)), rep(2, nrow(m2))),
      rbind(m1, m2)
    ), 
    TRUE
  )
  
  m1 <- matrix(
    c(1, 1,
      1, 1
    ),
    ncol = 2,
    byrow = TRUE
  )
  m2 <- matrix(
    c(1, 0,
      1, 0
    ),
    ncol = 2,
    byrow = TRUE
  )
  expect_equal(
    robust(
      c(rep(1, nrow(m1)), rep(2, nrow(m2))),
      rbind(m1, m2)
    ), 
    TRUE
  )
  
  m1 <- matrix(
    c(1, 0,
      1, 1
    ),
    ncol = 2,
    byrow = TRUE
  )
  m2 <- matrix(
    c(1, 0,
      1, 0
    ),
    ncol = 2,
    byrow = TRUE
  )
  expect_equal(
    robust(
      c(rep(1, nrow(m1)), rep(2, nrow(m2))),
      rbind(m1, m2)
    ), 
    FALSE
  )
})
