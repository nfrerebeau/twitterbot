#' @include AllGenerics.R
NULL

#' @rdname tweet
#' @export
composeTweet.hal_document <- function(x, ...) {
  title_s <- x[["title_s"]][[1]]
  licence_s <- x[["licence_s"]]
  domain_s <- x[["domainAllCode_s"]]
  doiId_s <- x[["doiId_s"]]
  uri_s <- x[["uri_s"]]

  if (length(title_s) == 0)
    return(NULL)

  # Title: 125 to 128 char
  title <- trimws(strtrim(title_s, 125))
  if (nchar(title_s) > 125) title <- paste0(title, "...")
  # Hashtags
  ## Open Access: 0 to 11 char
  open_access <- isOpenAcessLicense(licence_s) | isOpenAcessDOI(doiId_s)
  license <- ifelse(open_access, "#OpenAccess", "")
  ## Domains: 0 to 80 char
  if (!is.null(domain_s)) {
    tag <- makeHashTag_domain(domain_s)
    hashtag <- paste0(tag, collapse = " ")
    while(nchar(hashtag) > 80) {
      tag <- utils::head(tag, -1)
      hashtag <- paste0(tag, collapse = " ")
    }
  } else {
    hashtag <- ""
  }

  # URL: 23 char (will be altered by Twitter)
  if (!is.null(doiId_s)) {
      url <- paste0("https://dx.doi.org/", doiId_s)
  } else {
    url <- uri_s
  }

  # Text: 29 + 128 + 11 + 80 + 23 = 271 char
  text <- sprintf("New publication @CRP2A: \"%s\" %s %s %s",
                  title, license, hashtag, url)
  # Remove extra spaces
  tweet <- gsub("\\s+", " ", text)
  # Check tweet length
  tweet_clean <- gsub("https?://[[:graph:]]+\\s?", "", tweet)
  if (nchar(tweet_clean) + 23 > 280)
    stop("Tweet needs to be less than 280 characters.", call. = FALSE)

  return(tweet)
}

#' @rdname tweet
#' @export
sendTweet.hal_document <- function(x, log, silent = TRUE, test = FALSE, ...) {
  # Compose message
  tweet_msg <- composeTweet(x)
  if (test) {
    return(tweet_msg)
  } else {
    # Send tweet
    tweet <- try(
      expr = rtweet::post_tweet(status = tweet_msg),
      silent = silent
    )
    if (inherits(tweet, "try-error")) {
      return(FALSE)
    } else {
      # Lookup status_id
      timeline <- rtweet::get_timeline("CRP2Abib")
      # ID for reply
      tweet_id <- timeline$status_id[1]
      doc_id <- x[["halId_s"]]
      # Write to log
      writeLog(file = log, tweet_id, doc_id)
      # Return results
      return(TRUE)
    }
  }
}

#' @rdname log
#' @export
readLog <- function(file, silent = TRUE, ...) {
  if (file.exists(file)) {
    tweet_log <- try(
      expr = utils::read.table(file, header = FALSE, sep = " ", ...),
      silent = silent
    )
    if (!inherits(tweet_log, "try-error")) {
      return(tweet_log)
    }
  }
  return(FALSE)
}

#' @rdname log
#' @export
writeLog <- function(file, tweet_id, doc_id) {
  time_stamp <- strftime(Sys.time(), format = "%F %T")
  log_info <- sprintf("%s %s %s\n", time_stamp, tweet_id, doc_id)
  cat(log_info, file = file, sep = "", append = TRUE)
}

#' Make Hashtag
#'
#' @param x A \code{\link{character}} vector.
#' @return A \code{\link{character}} vector.
#' @author N. Frerebeau
#' @keywords internal
#' @noRd
makeHashTag_keyword <- function(x) {
  # Title case
  tag <- tools::toTitleCase(x)
  # Remove space and punctuation
  tag <- gsub(pattern = "([[:punct:]]|[[:space:]])", replacement = "", x = tag)
  # Add a "#" at the beginning
  tag <- paste0("#", tag)
  # Remove doublons
  tag <- droplevels(tag)
  tag <- unique(tag)
  tag
}
makeHashTag_domain <- function(x) {
  index <- which(.hal_domain$domain %in% x)
  tag <- .hal_domain[index, "tag", drop = TRUE]
  # Remove doublons
  tag <- droplevels(tag)
  tag <- unique(tag)
  tag
}

#' Open Access
#'
#' Checks if a document is open access.
#' @param x A \code{\link{character}} string (license or DOI).
#' @return A \code{\link{logical}} scalar.
#' @author N. Frerebeau
#' @keywords internal
#' @noRd
isOpenAcessLicense <- function(x) {
  open_license <- "(artlibre|creativecommons|publicdomain)"
  if (!is.null(x)) {
    grepl(pattern = open_license, x, ignore.case = TRUE)
  } else {
    FALSE
  }
}
isOpenAcessDOI <- function(x) {
  open_doi <- "^(10.5281/zenodo.|10.31223/osf.io/)"
  if (!is.null(x)) {
    grepl(pattern = open_doi, x, ignore.case = TRUE)
  } else {
    FALSE
  }
}
