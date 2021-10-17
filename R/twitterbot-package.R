#' @details
#' \tabular{ll}{
#'  **Package:** \tab twitterbot \cr
#'  **Type:** \tab Package \cr
#'  **Version:** \tab 0.1 \cr
#'  **License:** \tab GPL-3 \cr
#' }
#' @author
#' **Full list of authors and contributors** (alphabetic order)
#'
#' \tabular{ll}{
#'  Nicolas Frerebeau \tab *Université Bordeaux Montaigne, France* \cr
#' }
#'
#' **Package maintainer*
#'
#' Nicolas Frerebeau\cr
#' \email{nicolas.frerebeau@@u-bordeaux-montaigne.fr}
#'
#' IRAMAT-CRP2A (UMR 5060)\cr
#' Maison de l'Archéologie\cr
#' Université Bordeaux Montaigne\cr
#' F-33607 Pessac cedex\cr
#' France
#' @name twitterbot-package
#' @aliases twitterbot
#' @docType package
#' @keywords internal
"_PACKAGE"

# Quiets concerns of R CMD check: the .'s that appear in pipelines
# See https://github.com/tidyverse/magrittr/issues/29
if(getRversion() >= "2.15.1") utils::globalVariables(c("."))

#' @import solrium
#' @import rtweet
NULL
