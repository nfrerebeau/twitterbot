test_that("Hashtags from keywods", {
  expect_identical(keyword_to_hashtag("R Packages"), "#RPackages")
  expect_identical(keyword_to_hashtag("R-Packages"), "#RPackages")
})
test_that("Hashtags from HAL domains", {
  expect_identical(domain_to_hashtag("shs.archeo"), "#Archaeology")
  expect_identical(domain_to_hashtag("shs.art"), "#HistoryOfArt")
  expect_identical(domain_to_hashtag("xxx"), character(0))
})
