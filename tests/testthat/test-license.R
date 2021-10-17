test_that("OA from license", {
  expect_true(is_oa_license("creativecommons"))
  expect_false(is_oa_license(""))
})
test_that("OA from DOI", {
  expect_true(is_oa_doi("10.5281/zenodo.123456"))
  expect_true(is_oa_doi("10.31223/osf.io/123456"))
  expect_false(is_oa_doi(""))
})
