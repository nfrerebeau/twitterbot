# READ/WRITE LOG

#' Log
#'
#' @param file A [`character`] string giving the name of the file
#'  which the data are to be read from. Each row of the table appears as one
#'  line of the file (see [utils::read.table()]).
#' @param silent A [`logical`] scalar: should the report
#'  of error messages be suppressed?
#' @param tweet_id A [`character`] string giving the id of the tweet.
#' @param doc_id A [`character`] string giving the id of the HAL document.
#' @param ... Extra parameters to be passed to [utils::read.table()].
#' @details
#'  The log file must have four columns separated by a single white space:
#'
#'  * Date (YYYY-MM-DD);
#'  * Time (HH-MM-SS);
#'  * Tweet id;
#'  * HAL id.
#'
#' @return
#'  * `read_log()` returns a [`data.frame`] if the log file exists and
#'    contains at least one row, else returns `FALSE`.
#'  * `write_log()` returns `NULL`.
#' @seealso [cat()]
#' @author N. Frerebeau
#' @name log
#' @rdname log
NULL

#' @rdname log
#' @export
read_log <- function(file, silent = TRUE, ...) {
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
write_log <- function(file, tweet_id, doc_id) {
  time_stamp <- strftime(Sys.time(), format = "%F %T")
  log_info <- sprintf("%s %s %s\n", time_stamp, tweet_id, doc_id)
  cat(log_info, file = file, sep = "", append = TRUE)
}
