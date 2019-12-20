#' Get Documents From HAL
#'
#' @param x A \code{\link{list}} of document references.
#' @param id A \code{\link{character}} string giving the structure id.
#' @param limit An \code{\link{integer}} specifying the number of results to be
#'  returned.
#' @param log A \code{\link{data.frame}}.
#' @param keep An \code{\link{integer}} vector giving the indices of the
#'  documents to be kept.
#' @return
#'  A \code{\link{list}} of document references. Each element of the list
#'  is a list of class \code{hal_document}.
#' @author N. Frerebeau
#' @name hal
#' @rdname hal
NULL

#' Compose Tweet
#'
#' @param x A \code{\link{list}} of document references.
#' @param log A \code{\link{character}} string giving the path of the log file.
#' @param silent A \code{\link{logical}} scalar: should the report
#'  of error messages be suppressed?
#' @param test A \code{\link{logical}} scalar.
#' @param ... Currently not used.
#' @return
#'  \code{composeTweet} returns a \code{\link{list}} of character strings
#'  (tweet messages).
#'
#'  \code{sendTweet} returns a \code{\link{logical}} scalar.
#' @author N. Frerebeau
#' @name tweet
#' @rdname tweet
NULL

#' @rdname tweet
composeTweet <- function(x, ...) UseMethod("composeTweet")

#' @rdname tweet
sendTweet <- function(x, ...) UseMethod("sendTweet")

#' Log
#'
#' @param file A \code{\link{character}} string giving the name of the file
#'  which the data are to be read from. Each row of the table appears as one
#'  line of the file (see \code{\link[utils]{read.table}}).
#' @param silent A \code{\link{logical}} scalar: should the report
#'  of error messages be suppressed?
#' @param tweet_id A \code{\link{character}} string giving the id of the tweet.
#' @param doc_id A \code{\link{character}} string giving the id of the HAL
#'  document.
#' @param ... Extra parameters to be passed to \code{\link[utils]{read.table}}.
#' @details
#'  The log file must have four columns separated by a single white space:
#'  \itemize{
#'   \item{Date (YYYY-MM-DD).}
#'   \item{Time (HH-MM-SS).}
#'   \item{Tweet id.}
#'   \item{HAL id.}
#'  }
#' @return
#'  \code{readLog} returns a \code{\link{data.frame}} if the log file exists and
#'  contains at least one row, else returns \code{FALSE}.
#'
#'  \code{writeLog} returns \code{NULL}.
#' @seealso \link{cat}
#' @author N. Frerebeau
#' @name log
#' @rdname log
NULL
