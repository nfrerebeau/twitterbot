test_that("Hashtags from keywods", {
  expect_identical(hashtag_keyword("R Packages"), "#RPackages")
  expect_identical(hashtag_keyword("R-Packages"), "#RPackages")
})
test_that("Hashtags from HAL domains", {
  expect_identical(hashtag_domain("shs.archeo", "xx"), "#Archaeology")
  expect_identical(hashtag_domain("shs.archeo", "en"), "#Archaeology")
  expect_identical(hashtag_domain("shs.archeo", "fr"), "#Archéologie")
  expect_identical(hashtag_domain("shs.art", "en"), "#HistoryOfArt")
  expect_identical(hashtag_domain("shs.art", "fr"), "#HistoireDeLArt")
  expect_identical(hashtag_domain("xxx"), character(0))
})

test_that("Hashtags from DOI or license", {
  expect_identical(hashtag_open("10.5281/zenodo.123456", "xx"), "#OpenAccess")
  expect_identical(hashtag_open("10.5281/zenodo.123456", "en"), "#OpenAccess")
  expect_identical(hashtag_open("10.5281/zenodo.123456", "fr"), "#ScienceOuverte")

  expect_identical(hashtag_open("creativecommons", "fr"), "#ScienceOuverte")
  expect_identical(hashtag_open("creativecommons", "en"), "#OpenAccess")

  expect_identical(hashtag_open(c("10.5281/zenodo.123456", "xxx")), "#OpenAccess")
  expect_identical(hashtag_open(c("xxx", "creativecommons")), "#OpenAccess")

  expect_identical(hashtag_open("xxx"), "")
  expect_identical(hashtag_open("xxx"), "")
})
