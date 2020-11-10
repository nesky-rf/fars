testthat::test_that("Test 1: read_csv file", {
  out <- fars::fars_summarize_years(2013)
  expect_that(sum(out$"2013"), equals(30202))
  expect_that(as.integer(out[1,2]), equals(2230))
})
