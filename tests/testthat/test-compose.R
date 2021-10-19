test_that("Compose from HAL document", {
  art <- list(
    domainAllCode_s = c("shs.archeo", "sdu.stu.pg", "spi.mat"),
    title_s = c("Ceci est un titre d'article vraiment très très très très très très très très très très très très très très très très très très très très très très long, vraiment particulièrement long",
                "This is a particularly long, very long, very long, very long, very long, very long, very long, very long, very long, very long, very long, very long, very long, very long article title."),
    journalTitle_s = "Archeosciences, revue d'Archéométrie",
    authFullName_s = c("John Lennon", "Paul McCartney",
                       "George Harrison", "Ringo Starr"),
    halId_s = "hal-12345678",
    uri_s = "https://hal.archives-ouvertes.fr/hal-12345678",
    docType_s = "ART",
    doiId_s = "10.5281/zenodo.123456",
    producedDate_tdate = "2020-01-01T00:00:00Z"
  )
  art <- structure(art, class = "hal_document")

  art$language_s <- "fr"
  expect_snapshot(compose(art))

  art$language_s <- "en"
  expect_snapshot(compose(art))
})
