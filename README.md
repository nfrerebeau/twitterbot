
<!-- README.md is generated from README.Rmd. Please edit that file -->

# twitterbot

This package accesses documents from the [Open Archive
HAL](https://hal.archives-ouvertes.fr/) and tweets the last scientific
publications from the CRP2A lab on a daily basis.

See [@CRP2Abib](https://twitter.com/crp2abib).

## Installation

You you can install this R package from GitHub with:

``` r
# install.packages("devtools")
remotes::install_github("crp2a/twitterbot")
```

## Example

``` r
library(twitterbot)

## Read the log file
tweet_log <- twitterbot::readLog(file = "./log")
## Get documents from HAL
hal_docs <- twitterbot::getDocuments(id = "399901", limit = 100)
## Keep only the first ten new documents
keep_docs <- twitterbot::cleanDocuments(hal_docs, log = tweet_log, keep = 1:10)

## Compose and send
if (length(keep_docs) > 0) {
  ## Authenticate via access token
  ## Tweet 
  tweet <- vapply(
    X = keep_docs, 
    FUN = twitterbot::sendTweet,
    FUN.VALUE = logical(1),
    log = "./log",
    silent = TRUE
  )
  
  ## Summary
  n_doc <- length(keep_docs)
  n_tweet <- sum(tweet)
  n_error <- sum(!tweet)
  
  msg <- sprintf(
    "%s - %d out of %d %s tweeted.", 
    strftime(Sys.time(), format = "%F %T"),
    n_tweet,
    n_doc,
    ngettext(n_doc, "document was", "documents were")
  )
} else {
  msg <- "Nothing new to tweet."
}
message(msg)
```
