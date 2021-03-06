% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_query.R
\name{get_query}
\alias{get_query}
\title{Get query from database}
\usage{
get_query(
  query,
  driver = "ODBC Driver 17 for SQL Server",
  server = getOption("tcdkhelper.dbaddr"),
  database = "dnb_covid19",
  trusted_connection = "Yes",
  encoding = "latin1",
  timezone = Sys.timezone(),
  timezone_out = timezone
)
}
\arguments{
\item{query}{Query to execute.}

\item{driver}{Driver to use with database.}

\item{server}{Name of server to query.}

\item{database}{A string giving the name of the database.}

\item{trusted_connection}{"Yes" / "No".}

\item{encoding}{Text encoding to use.
Defaults to "latin1", as this is most often used within the TCDK database.}

\item{timezone}{A string giving a timezone with which to interpret datetime
values returned by query.
If none is given, defaults to the return value of Sys.timezone()}

\item{timezone_out}{Timezone returned by query. Defaults to value of \code{timezone}}
}
\value{
The query result as a \link[tibble:tibble]{tibble}.
}
\description{
Execute an input SQL query and close the database connection
when done.
When given with no argument except query, the TCDK production database
is queried.
}
\examples{
get_query(
"SELECT TOP (10)
  MatrixPlateBC,
  DWPlateBC,
  RTimestampPM
FROM PlateFlow_Biomek

ORDER BY RTimestampPM DESC"
)
}
