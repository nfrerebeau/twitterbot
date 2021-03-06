# ACCESS HAL DOCUMENTS

#' Get Documents From HAL
#'
#' @param id A [`character`] string giving the structure or the author (IdHal)
#'  id.
#' @param type A [`character`] vector giving the type of the documents to be
#'  returned (see HAL API documentation).
#' @param limit An [`integer`] specifying the number of results to be returned.
#' @details
#'  Retrieves documents from HAL published during the last year.
#' @return
#'  A [`list`] of document references. Each element of the `list` is a `list` of
#'  class `hal_document`.
#' @author N. Frerebeau
#' @examples
#' \dontrun{
#' get_hal_team("399901")
#' }
#' @name get_hal
#' @rdname get_hal
NULL

#' @rdname get_hal
#' @export
get_hal_team <- function(id, type = c("ART", "OUV", "DOUV", "SOFTWARE"),
                         limit = 10) {
  id <- paste(as.character(id), collapse = " OR ")
  id <- sprintf("(%s)", id)
  query <- paste0("structId_i:", id)
  get_hal(query, type = type, limit = limit)
}

#' @rdname get_hal
#' @export
get_hal_author <- function(id, type = c("ART", "OUV", "DOUV", "SOFTWARE"),
                           limit = 10) {
  id <- paste(as.character(id), collapse = " OR ")
  id <- sprintf("(%s)", id)
  query <- paste0("authIdHal_s:", id)
  get_hal(query, type = type, limit = limit)
}

get_hal <- function(query, type = c("ART", "OUV", "DOUV", "SOFTWARE"),
                    limit = 10) {
  # Query parameters
  hal_fields <- c(
    "authFullName_s",        # Auteur
    "docType_s",             # Type de document (référentiel HAL)
    "doiId_s",               # DOI
    "fileMain_s ",           # URL du fichier principal
    "halId_s",               # Identifiant HAL
    "journalTitle_s",        # Titre du journal
    "title_s",               # Titre du document
    "producedDate_tdate",    # Date de production
    "publicationDate_tdate", # Date de publication
    "licence_s",             # Licence du document
    "keyword_s",             # Mots clés
    "domainAllCode_s",       # Codes domaines (référentiel HAL)
    "language_s",            # Langue du document
    "uri_s"                  # URL du document
  )
  hal_types <- paste0(type, collapse = " OR ")
  hal_params <- list(
    q = query,
    fl = hal_fields,
    fq = "publicationDate_tdate:[NOW/YEAR-1YEARS TO NOW]",
    fq = sprintf("docType_s:(%s)", hal_types),
    fq = "inPress_bool:false",
    sort = "publicationDate_tdate asc",
    rows = limit,
    wt = "json"
  )
  # Search environment HAL API
  env_search <- solrium::SolrClient$new(host = "api.archives-ouvertes.fr",
                                        path = "search", port = NULL)
  # Get documents from HAL
  hal_docs <- env_search$search(params = hal_params, parsetype = "list")
  hal_docs <- lapply(X = hal_docs, FUN = structure, class = "hal_document")
  structure(hal_docs, class = "hal_documents")
}
