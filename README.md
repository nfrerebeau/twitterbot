
<!-- README.md is generated from README.Rmd. Please edit that file -->

# twitterbot

This package accesses documents from the [Open Archive
HAL](https://hal.archives-ouvertes.fr/) and tweets the last scientific
publications from the CRP2A laboratory. It can be used with a cron job
to schedule tweets on a daily/weekly basis.

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

## Set the path of the log file
log_path <- "./log"
## Read the log file
log_tweet <- twitterbot::readLog(file = log_path)

## Get documents from HAL
doc_hal <- twitterbot::getDocuments(id = "399901", limit = 100)
## Keep only the first ten new documents
doc_keep <- twitterbot::cleanDocuments(doc_hal, log = log_tweet, keep = 1:10)

## Compose and send
## Authenticate via access token
## See vignette("auth", package = "rtweet")
if (length(doc_keep) > 0) {
  ## Tweet 
  tweet <- vapply(
    X = doc_keep, 
    FUN = twitterbot::sendTweet,
    FUN.VALUE = logical(1),
    log = log_path,
    silent = TRUE
  )
}
```
