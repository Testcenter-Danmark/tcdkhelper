#' Get query from database
#'
#' @description Execute an input SQL query and close the database connection
#' when done.
#' When given with no argument except query, the TCDK production database
#' is queried.
#'
#' @param query Query to execute.
#' @param server Name of server to query.
#' @param driver Driver to use with database.
#' @param database A string giving the name of the database.
#' @param trusted_connection "Yes" / "No".
#' @param encoding Text encoding to use.
#' Defaults to "latin1", as this is most often used within the TCDK database.
#' @param timezone A string giving a timezone with which to interpret datetime
#' values returned by query.
#' If none is given, defaults to the return value of Sys.timezone()
#' @param timezone_out Timezone returned by query. Defaults to value of `timezone`
#'
#' @return The query result as a [tibble][tibble::tibble()].
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#'
#' @export
#' @examples
#' get_query(
#' "SELECT TOP (10)
#'   MatrixPlateBC,
#'   DWPlateBC,
#'   RTimestampPM
#' FROM PlateFlow_Biomek
#'
#' ORDER BY RTimestampPM DESC"
#' )


get_query <- function(query,
                      driver = "ODBC Driver 17 for SQL Server",
                      server = "s-dnbdb02-p",
                      database = "dnb_covid19",
                      trusted_connection = "Yes",
                      encoding = "latin1",
                      timezone = Sys.timezone(),
                      timezone_out = timezone){

  start_time <- Sys.time()

  conn <- odbc::dbConnect(odbc::odbc(),
                          driver = driver,
                          server = server,
                          database = database,
                          trusted_connection = trusted_connection,
                          encoding = encoding,
                          timezone = timezone,
                          timezone_out = timezone_out)

  d <- odbc::dbGetQuery(conn, query) %>%
    tibble::tibble()

  elapsed <- difftime(Sys.time(), start_time, units = "secs")
  message("Collected ", nrow(d), " rows in ",
          ifelse(elapsed > 60,
                 sprintf("%.0f:%02.0f minutes",
                         as.numeric(elapsed) %/% 60,
                         as.numeric(elapsed) %% 60),
                 sprintf("%.2f seconds",
                         elapsed)
          ))

  odbc::dbDisconnect(conn)
  return(d)
}
