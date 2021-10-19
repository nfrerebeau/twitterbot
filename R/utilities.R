# HELPERS

# Hashtag ======================================================================
#' Hashtag
#'
#' @param x A [`character`] vector of keywords.
#' @return A [`character`] vector of hashtags.
#' @author N. Frerebeau
#' @keywords internal
#' @noRd
hashtag_keyword <- function(x) {
  x <- as.character(x)
  # Title case
  tag <- tools::toTitleCase(x)
  # Remove space and punctuation
  tag <- gsub(pattern = "([[:punct:]]|[[:space:]])", replacement = "", x = tag)
  # Add a "#" at the beginning
  tag <- paste0("#", tag)
  # Remove doublons
  tag <- unique(tag)
  tag
}

hashtag_domain <- function(x, lang = "en") {
  lang <- ifelse(any(c("en", "fr") == lang), lang, "en") # Defaults to English
  index <- which(.hal_domain$domain %in% x)
  tag <- .hal_domain[[lang]][index]
  # Remove doublons
  tag <- as.character(tag)
  tag <- unique(tag)
  tag
}

hashtag_open <- function(x, lang = "en") {
  open_access <- ""
  if (any(is_oa_license(x) | is_oa_doi(x))) {
    open_access <- switch(
      lang,
      fr = "#ScienceOuverte",
      "#OpenAccess" # Defaults to English
    )
  }
  open_access
}

# Open Access ==================================================================
#' Open Access
#'
#' Checks if a document is open access.
#' @param x A [`character`] string (license or DOI).
#' @return A [`logical`] scalar.
#' @author N. Frerebeau
#' @keywords internal
#' @noRd
is_oa_license <- function(x) {
  open_license <- "(artlibre|creativecommons|publicdomain)"
  if (!is.null(x)) {
    grepl(pattern = open_license, x, ignore.case = TRUE)
  } else {
    FALSE
  }
}

is_oa_doi <- function(x) {
  open_doi <- "^(10.5281/zenodo.|10.31223/osf.io/)"
  if (!is.null(x)) {
    grepl(pattern = open_doi, x, ignore.case = TRUE)
  } else {
    FALSE
  }
}
