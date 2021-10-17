# COMPOSE AND POST

# Compose ======================================================================
#' Compose Tweet
#'
#' @param x A [`list`] of document references
#'  (typically a list of class [`hal_documents`][get_hal_team]).
#' @param ... Currently not used.
#' @return
#'  Returns a [`character`] string (tweet message) or a [`list`] of `character`
#'  strings.
#' @author N. Frerebeau
#' @name compose
#' @rdname compose
NULL

#' @rdname compose
#' @export
compose <- function(x, ...) UseMethod("compose")

#' @rdname compose
#' @export
compose.hal_documents <- function(x, ...) {
  tweets <- lapply(
    X = x,
    FUN = compose
  )
  structure(tweets, class = "messages")
}

#' @rdname compose
#' @export
compose.hal_document <- function(x, ...) {

  halId_s <- x[["halId_s"]]
  title_s <- x[["title_s"]][[1]]
  licence_s <- x[["licence_s"]]
  domain_s <- x[["domainAllCode_s"]]
  doiId_s <- x[["doiId_s"]]
  uri_s <- x[["uri_s"]]

  if (length(title_s) == 0) return(NULL)

  # Title: 125 to 128 char
  title <- trimws(strtrim(title_s, 125))
  if (nchar(title_s) > 125) title <- paste0(title, "...")

  # Hashtags
  ## Open Access: 0 to 11 char
  open_access <- is_oa_license(licence_s) | is_oa_doi(doiId_s)
  license <- ifelse(open_access, "#OpenAccess", "")

  ## Domains: 0 to 80 char
  if (!is.null(domain_s)) {
    tag <- domain_to_hashtag(domain_s)
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

  structure(tweet, class = "message", id = halId_s)
}

# Clean ========================================================================
#' Clean Tweet
#'
#' @param x A [`list`] of class `messages`.
#' @param log A [`character`] string giving the path of the log file
#'  (see below).
#' @param keep An [`integer`] vector giving the indices of the messages to be
#'  kept.
#' @param ... Currently not used.
#' @return
#'  A [`list`] of [`character`] string (tweet message).
#' @author N. Frerebeau
#' @name clean
#' @rdname clean
NULL

#' @rdname clean
#' @export
clean <- function(x, ...) UseMethod("clean")

#' @rdname clean
#' @export
clean.messages <- function(x, log = NULL, keep = 1:10, ...) {
  ## Check that no document is tweeted twice
  if (!is.null(log)) {
    tweet_log <- read_log(log)
    if (is.data.frame(tweet_log)) {
      msg_id <- vapply(X = x, FUN = attr, FUN.VALUE = character(1), which = "id")
      index <- !(msg_id %in% tweet_log[[4]])
      x <- x[index] # Remove documents if already tweeted
    }
  }

  ## Keep only the selected documents
  x <- x[keep]

  ## Remove empty documents
  x <- Filter(Negate(is.null), x)

  structure(x, class = "messages")
}

# Post =========================================================================
#' Post Tweet
#'
#' @param x A [`list`] of messages.
#' @param log A [`character`] string giving the path of the log file.
#' @param keep An [`integer`] vector giving the indices of the messages to be
#'  kept.
#' @param silent A [`logical`] scalar: should the report of error messages be
#'  suppressed?
#' @param test A [`logical`] scalar.
#' @param ... Currently not used.
#' @return
#'  Returns a [`logical`] scalar.
#' @author N. Frerebeau
#' @name post
#' @rdname post
NULL

#' @rdname post
#' @export
post <- function(x, ...) UseMethod("post")

#' @rdname post
#' @export
post.hal_documents <- function(x, log = NULL, keep = 1:10,
                               silent = TRUE, test = FALSE, ...) {
  ## Compose message
  txt <- compose(x)

  ## Clean messages
  msg <- clean(txt, log = log, keep = keep)

  ## Post message
  post_log <- logger(post, file = log)
  tweet <- post_log(msg, silent = silent, test = test, ...)

  invisible(tweet)
}

#' @rdname post
#' @export
post.messages <- function(x, silent = TRUE, test = FALSE, ...) {
  ## Check that there is something to tweet
  if (length(x) == 0) {
    message("There is nothing to tweet about!")
    return(character(0))
  }

  ## Tweet
  tweet <- lapply(
    X = x,
    FUN = post,
    silent = silent,
    test = test
  )

  tweet <- do.call(rbind, tweet)
  invisible(tweet)
}

#' @rdname post
#' @export
post.message <- function(x, silent = TRUE, test = FALSE, ...) {
  # Get IDs
  doc_id <- attr(x, "id")
  tweet_date <- strftime(Sys.time(), format = "%F %T")
  tweet_id <- ""

  if (!test) {
    # Send tweet
    tweet <- try(
      expr = rtweet::post_tweet(status = x),
      silent = silent
    )

    if (!inherits(tweet, "try-error")) {
      # Lookup status_id
      timeline <- rtweet::get_my_timeline()

      # Date and time
      tweet_date <- timeline$created_at[[1]]

      # ID for reply
      tweet_id <- timeline$status_id[[1]]
    }
  }

  # Return results
  out <- sprintf("%s %s %s\n", tweet_date, tweet_id, doc_id)
  invisible(out)
}
