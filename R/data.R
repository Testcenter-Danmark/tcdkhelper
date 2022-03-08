#' @title Labels for TCDK locations
#'
#' @description A dataset for interpreting LocationID values (integers) as human- and
#' UTF-8 filename-friendly labels.
#'
#' @format A [`tibble`][tibble::tibble()] with 2 rows and 3 variables:
#' \describe{
#'   \item{LocationID}{An integer for joining with database query results}
#'   \item{LocationName}{A human-friendly label (e.g. in plots) for locations}
#'   \item{LocatioNFilename}{Lowercase, UTF-8-friendly string for use in filenames}
#' }
#'
#' @examples
#' d <- get_query(
#'   "SELECT TOP 10
#'   MatrixPlateBC,
#'   LocationID
#' FROM PlateFlow_Biomek
#'
#' ORDER BY RTimestampPM DESC"
#' )
#'
#' d$LocName <- location_labels$LocationName[d$LocationID]
#'
#' d
#'
"location_labels"

#' @title Labels for timestamps
#'
#' @description A dataset for arranging timestamps from PlateFlow tables such as PlateFlow_Biomek
#' with rows ordered by order of step in processing.
#' This allows factoring a "long-format" dataframe (timestamp names and values given
#' in two columns) so that downstream plotting maintains correct processing order.
#' @description Also gives (suggested) labels, describing what has been done since
#' previous timestamp.
#'
#' @details It is (potentially) important to note that the column `Level` is
#' *not* a factor.
#' This is due to how joins work in [`dplyr`][dplyr::mutate-joins]; joining a
#' (e.g. `chr`) vector with a `factor` removes levels from the resulting column
#' despite the join method used.
#'
#' To circumvent this, a target column (existing or new) can be made a factor by
#' using the `Level` column for levels.
#'
#' @examples
#' timestamps <- tibble::tibble(
#'   Timestamp = c(
#'     "RTimestampBKi7",
#'     "RTimestampPCR",
#'     "RTimestampPCRVV",
#'     "RTimestampPCRDV",
#'     "RTimestampPCRRes"
#'   ),
#'   Time = c(
#'     "1999",
#'     "Sunday Bloody Sunday",
#'     "9 to 5",
#'     "Yesterday",
#'     "Right Here Right Now"
#'   )
#' )
#'
#' timestamps$Timestamp <- factor(timestamps$Timestamp,
#'                                levels = rtimestamp_levels$Level,
#'                                labels = rtimestamp_levels$Label)
#'
#' timestamps
#'
#' @format A [`tibble`][tibble::tibble()] with 5 rows and 3 variables:
#' \describe{
#'   \item{Level}{Name of the corresponding RTimestamp column.
#'   Note that this column is not a factor (see details).}
#'   \item{Label}{An easily interpretable string describing what has happened
#'   since previous `Level`.}
#'   \item{Hex}{A hex color code (derived from a previously used palette).
#'   Colors of processing steps that are similar in nature (e.g. RNA extraction
#'   with liquid handling robots as opposed to rt-PCR and human interpretation
#'   of these results), and any potential future timestamp should most likely
#'   adhere to these "rules".}
#' }
#'
"rtimestamp_levels"

#' @keywords internal
#' Update configuration files on package load

.onLoad <- function(libname, pkgname) {
  # Load configuration from local library, COVID19_SHARED folder or manually
  local_path <- file.path(.libPaths()[1], pkgname, "tcdkhelper.json")
  c19shared_path <-
    file.path("S:", "COVID19_SHARED", "tcdkhelper", "tcdkhelper.json")

  if (file.exists(local_path)) {
    cfg_path <- local_path
  } else if (file.exists(c19shared_path)) {
    cfg_path <- c19shared_path
  } else {
    # If still not found, prompt user
    prompt <- utils::winDialog(type = "okcancel",
                        "tcdkhelper.json kunne ikke findes.\nVil du finde den manuelt?")
    if (prompt == "OK") {
      cfg_path <- file.choose()
    } else {
      stop("Kunne ikke finde konfigurationsfil!")
    }
  }

  # Read config
  cfgs <- jsonlite::fromJSON(cfg_path)
  op.tcdkhelper <- list(
    tcdkhelper.dbaddr = cfgs$dbaddr,
    tcdkhelper.sdrive = cfgs$sdrive
  )

  version_old <- ifelse(!is.null(cfgs$version), cfgs$version, "0.0.0")
  version_cur <- utils::packageVersion(pkgname)

  if (is.na(version_old) | version_old < version_cur & !is.na(local_path)) {
    packageStartupMessage("Opdaterer konfiguration til version ", version_cur)
    cfgs$version <- as.character(version_cur)
    jsonlite::write_json(x = cfgs,
                         path = local_path,
                         auto_unbox = T,
                         pretty = T)
  }

  # Update missing options
  {
    op <- options()
    toset <- !(names(op.tcdkhelper) %in% names(op))
    if (any(toset[toset])) options(op.tcdkhelper[toset])
  }

  invisible()
}
