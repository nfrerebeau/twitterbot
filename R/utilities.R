# HELPERS

# Hashtag ======================================================================
#' Hashtag
#'
#' @param x A [`character`] vector of keywords.
#' @return A [`character`] vector of hashtags.
#' @author N. Frerebeau
#' @keywords internal
#' @noRd
keyword_to_hashtag <- function(x) {
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

domain_to_hashtag <- function(x) {
  index <- which(.hal_domain$domain %in% x)
  tag <- .hal_domain$tag[index]
  # Remove doublons
  tag <- as.character(tag)
  tag <- unique(tag)
  tag
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
