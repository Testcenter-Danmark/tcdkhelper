#' Get query from database
#'
#' @description Execute an input SQL query and close the database connection after
# 'collection of data
#'
#' @param query string
#'
#' @return data frame
#' @importFrom magrittr %>%
#' @importFrom tibble tibble
#'
#' @export
#' @examples
#' get_query("SELECT TOP (10)
#' MatrixPlateBC,
#' DWPlateBC,
#' RTimestampPM
#' FROM PlateFlow_Biomek
#' ORDER BY RTimestampPM DESC")


get_query <- function(query){
  start_time <- Sys.time()

  conn <- odbc::dbConnect(odbc::odbc(),
                          driver = "ODBC Driver 17 for SQL Server",
                          server = getOption("tcdkhelper.dbaddr"),
                          database = "dnb_covid19",
                          trusted_connection = "Yes",
                          encoding = "latin1",
                          timezone = Sys.timezone(),
                          timezone_out = Sys.timezone())

  d <- odbc::dbGetQuery(conn, query) %>%
    tibble()

  elapsed <- difftime(Sys.time(), start_time, units = "secs")
  message("Collected ", nrow(d), " rows in ",
          ifelse(elapsed > 60,
                 sprintf("%.0f:%2.0f minutes",
                         as.numeric(elapsed) %/% 60,
                         as.numeric(elapsed) %% 60),
                 sprintf("%.2f seconds",
                         elapsed)
          ))

  odbc::dbDisconnect(conn)
  return(d)
}
