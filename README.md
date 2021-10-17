
<!-- README.md is generated from README.Rmd. Please edit that file -->

# twitterbot

<!-- badges: start -->

[![R-CMD-check](https://github.com/nfrerebeau/twitterbot/workflows/R-CMD-check/badge.svg)](https://github.com/nfrerebeau/twitterbot/actions)

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

This package accesses documents from open archives and tweets the latest
scientific publications of your team (see it in action:
[@CRP2Abib](https://twitter.com/crp2abib)).

## Installation

You you can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("nfrerebeau/twitterbot")
```

## Usage

**twitterbot** currently supports:

-   [Open Archive HAL](https://hal.archives-ouvertes.fr/):
    `get_hal_team()` (team) or `get_hal_author()` (personnal).

You can schedule a [cron job](https://crontab.guru/) with
[**cronR**](https://github.com/bnosac/cronR) or use GitHub actions to
schedule tweets on a daily basis.

### Tweet your latest publications

``` r
library(twitterbot)

## Set the path of the log file
## This file ensures that no document is tweeted twice
path <- file.path(Sys.getenv("HOME"), "hal.log")

## Get documents from HAL
hal <- get_hal_team(id = "399901", limit = 100)

## Post the last ten publications
## Authenticate via access token
## See vignette("auth", package = "rtweet")
msg <- post(hal, log = path, keep = 1:10)
```

## Code of Conduct

Please note that the **twitterbot** project is released with a
[Contributor Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
