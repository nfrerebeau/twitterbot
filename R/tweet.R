# COMPOSE AND POST

# Compose ======================================================================
#' Compose Tweet
#'
#' @param x A [`list`] of document references.
#' @param ... Currently not used.
#' @return
#'  Returns a [`character`] string (tweet message).
#' @author N. Frerebeau
#' @name compose
#' @rdname compose
NULL

#' @rdname compose
#' @export
composeTweet <- function(x, ...) UseMethod("composeTweet")

#' @rdname compose
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

# Send =========================================================================
#' Send Tweet
#'
#' @param x A [`list`] of document references.
#' @param log A [`character`] string giving the path of the log file.
#' @param silent A [`logical`] scalar: should the report of error messages be
#'  suppressed?
#' @param test A [`logical`] scalar.
#' @param ... Currently not used.
#' @return
#'  Returns a [`logical`] scalar.
#' @author N. Frerebeau
#' @name send
#' @rdname send
NULL

#' @rdname send
#' @export
sendTweet <- function(x, ...) UseMethod("sendTweet")

#' @rdname send
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
      write_log(file = log, tweet_id, doc_id)

      # Return results
      return(TRUE)
    }
  }
}
