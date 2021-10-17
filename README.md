
<!-- README.md is generated from README.Rmd. Please edit that file -->

# twitterbot

<!-- badges: start -->

[![R-CMD-check](https://github.com/nfrerebeau/twitterbot/workflows/R-CMD-check/badge.svg)](https://github.com/nfrerebeau/twitterbot/actions)

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

This package accesses documents from the [Open Archive
HAL](https://hal.archives-ouvertes.fr/) and tweets the latest scientific
publications of your team (see it in action:
[@CRP2Abib](https://twitter.com/crp2abib)).

## Installation

You you can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("nfrerebeau/twitterbot")
```

## Usage

### Tweet your latest publications

``` r
library(twitterbot)

## Set the path of the log file
## This file ensures that no document is tweeted twice
path <- file.path(Sys.getenv("HOME"), "hal.log")

## Get documents from HAL
hal <- get_hal_team(id = "399901", limit = 100)

## Post the last ten publications
msg <- post(hal, log = path, keep = 1:10)
```

You can schedule a [cron job](https://crontab.guru/) with
[**cronR**](https://github.com/bnosac/cronR) or use GitHub actions to
schedule tweets on a daily basis.
