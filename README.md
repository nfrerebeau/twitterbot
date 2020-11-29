
<!-- README.md is generated from README.Rmd. Please edit that file -->

# twitterbot

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

This package accesses documents from the [Open Archive
HAL](https://hal.archives-ouvertes.fr/) and tweets the last scientific
publications from the CRP2A laboratory
([@CRP2Abib](https://twitter.com/crp2abib)).

## Installation

You you can install this R package from GitHub with:

``` r
# install.packages("remotes")
remotes::install_github("crp2a/twitterbot")
```

## Example

``` r
library(twitterbot)

## Set the path of the log file
## This file ensures that no document is tweeted twice
log_path <- file.path(Sys.getenv("HOME"), "twitter_hal.log")
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

Make a cron job to schedule tweets on a daily basis with
[**cronR**](https://github.com/bnosac/cronR):

``` r
library(cronR)

cmd <- cronR::cron_rscript(
  rscript = file.path(Sys.getenv("HOME"), "twitter.R"),
  rscript_log = file.path(Sys.getenv("HOME"), "twitter_cron.log"),
  cmd = file.path(Sys.getenv("R_HOME"), "bin", "Rscript"),
  log_append = TRUE
)

cronR::cron_add(
  command = cmd,
  frequency = "daily",
  at = "12:00",
  id = "CRP2Abib",
  tags = c("R", "HAL", "Twitter"),
  description = "CRP2A Twitter Bot",
  user = ""
)

# cronR::cron_njobs()
# cronR::cron_ls(id = "CRP2Abib")
# cronR::cron_clear(ask = FALSE)
```
