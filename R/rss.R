# ACCESS RSS FEED

#' Get Posts From an RSS Feed
#'
#' @param feed A [`character`] string giving the url for the feed that you want
#'  to get.
#' @param limit An [`integer`] specifying the time limit (in second) back from
#'  today (defaults to \eqn{604800}, i.e. one week).
#' @author N. Frerebeau
#' @examples
#' \dontrun{
#' get_rss("https://www.archeosciences-bordeaux.fr/spip.php?page=backend-breves")
#' }
#' @name get_rss
#' @rdname get_rss
#' @export
get_rss <- function(feed, limit = 7 * 24 * 60 * 60) {
  rss <- suppressMessages(tidyRSS::tidyfeed(feed, parse_dates = FALSE))

  ## Parse dates
  rss$feed_pub_date <- anytime::anytime(rss$feed_pub_date)
  rss$item_pub_date <- anytime::anytime(rss$item_pub_date)

  ## Remove old items
  rss <- rss[rss$item_pub_date > Sys.time() - limit, ]

  rss <- split(rss, f = seq_len(nrow(rss)))
  rss <- lapply(X = rss, FUN = structure, class = "rss_item")
  structure(rss, class = "rss_items")
}
