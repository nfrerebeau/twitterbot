# READ/WRITE LOG

#' Log
#'
#' Logs the output of any function.
#' @param f A [`function`].
#' @param file A [`character`] string naming the file to print the output
#'  of `f`.
#' @details
#'  The log file must have four columns separated by a single white space:
#'
#'  * Date (YYYY-MM-DD);
#'  * Time (HH-MM-SS);
#'  * Tweet (status) id;
#'  * Message unique id.
#'
#' @return
#'  `logger()` is a decorator function called for its side-effect. Returns
#'  the output of `f`.
#' @author N. Frerebeau
#' @keywords internal
logger <- function(f, file) {
  wrapper <- function(...) {
    # Before execution

    # Do nothing
    res <- f(...)

    # After execution
    cat(res, file = file, sep = "", append = TRUE)

    return(res)
  }
  return(wrapper)
}

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
  return(NULL)
}
