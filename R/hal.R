# ACCESS HAL DOCUMENTS

#' Get Documents From HAL
#'
#' @param x A [`list`] of document references.
#' @param id A [`character`] string giving the structure id.
#' @param limit An [`integer`] specifying the number of results to be returned.
#' @param log A [`data.frame`].
#' @param keep An [`integer`] vector giving the indices of the documents to be
#'  kept.
#' @return
#'  A [`list`] of document references. Each element of the list is a list of
#'  class `hal_document`.
#' @author N. Frerebeau
#' @name hal
#' @rdname hal
NULL

#' @rdname hal
#' @export
getDocuments <- function(id, limit = 10) {
  # Query parameters
  hal_fields <- c(
    "authFullName_s",      # Auteur
    "docType_s",           # Type de document (référentiel HAL)
    "doiId_s",             # DOI
    "fileMain_s ",         # URL du fichier principal
    "halId_s",             # Identifiant HAL
    "journalTitle_s",      # Titre du journal
    "title_s",             # Titre du document
    "producedDate_tdate",  # Date de production
    "licence_s",           # Licence du document
    "keyword_s",           # Mots clés
    "domainAllCode_s",     # Codes domaines (référentiel HAL)
    "language_s",          # Langue du document
    "uri_s"                # URL du document
  )
  hal_params <- list(
    q = paste0("structId_i:", id),
    fl = hal_fields,
    fq = "producedDate_tdate:[NOW/YEAR-1YEARS TO NOW]",
    fq = "docType_s:(ART OR OUV OR COUV OR DOUV OR SOFTWARE)",
    fq = "inPress_bool:false",
    sort = "producedDate_tdate asc",
    rows = limit,
    wt = "json"
  )
  # Search environment HAL API
  env_search <- solrium::SolrClient$new(host = "api.archives-ouvertes.fr",
                                        path = "search", port = NULL)
  # Get documents from HAL
  hal_docs <- env_search$search(params = hal_params, parsetype = "list")
  hal_docs <- lapply(X = hal_docs, FUN = structure, class = "hal_document")
  hal_docs
}

#' @rdname hal
#' @export
cleanDocuments <- function(x, log, keep = 1:10) {
  if (is.data.frame(log)) {
    hal_id <- vapply(
      X = x,
      FUN = `[[`,
      FUN.VALUE = character(1),
      i = "halId_s"
    )
    index <- !(hal_id %in% log[[4]])
  } else {
    index <- seq_along(x)
  }

  ## Remove documents if alread tweeted
  ## Keep only the 10 first documents
  docs <- x[index][keep]
  docs <- Filter(Negate(is.null), docs)
  return(docs)
}
