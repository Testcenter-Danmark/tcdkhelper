#' Get tcdkhelper mode
#'
#' @name modes
#'
#' @description `set_mode()` sets the mode of operation of `tcdkhelper`, mainly
#' affecting relative paths interpreted by [save_kpi()].
#'
#' @param mode A string giving the mode of operation. When `mode` is omitted,
#' a mode is set automatically. Currently supported values are "RStudio",
#' "batch" and "compile".
#'
#' @details Currently, the following modes of operation is implemented in the
#' `save_kpi()` function, and decide where (and if) a plot is saved:
#'
#' "RStudio" saves to a subfolder of your current working directory called
#' "KPI-PLOTS" (created if not already existing).
#'
#' "batch" saves to the folder KPI-PLOTS on a network destination
#' ("S-drive") shared within the TestCenter Danmark organisation.
#'
#' "compile" does not save the file at all.
#' This is useful if you have manually opened a graphics device (e.g. by [`pdf()`][grDevices::pdf()]
#' and wish to print the plot to given device.
#'
#' When `set_mode()` is called with no `mode` argument, a mode is decided as
#' follows: If `save_kpi()` is called within RStudio, the mode "RStudio" is set.
#' If not, and a graphics device - other than the
#' "[`null device`][grDevices::dev.cur()]" - is set, mode is set to "compile".
#' This mode generates no output, allowing for manually printing plots to
#' set device, minimizing the risk of duplicate plots in your destination.
#' Finally, if run outside RStudio with no graphics device, "batch" mode is set.
#'
#' @return A string giving the current (or new) tcdkhelper mode.
#' @importFrom grDevices dev.cur pdf
#' @importFrom utils getFromNamespace assignInNamespace

#' @export
#' @rdname modes

get_mode <- function() {
  utils::getFromNamespace("mode", "tcdkhelper")
}

#' @export
#' @rdname modes

set_mode <- function(mode) {
  if (!missing(mode)) {
  } else
    # Set default mode
    if (any(grepl("rstudio", Sys.getenv(), ignore.case = T))) {
      mode <- "RStudio"
    } else if (grDevices::dev.cur() == 1) {
      mode <- "batch"
      grDevices::pdf(NULL)
    } else {
      # Non-RStudio graphics device is opened
      mode <- "compile"
    }

  utils::assignInNamespace("mode", mode, "tcdkhelper")
  utils::getFromNamespace("mode", "tcdkhelper")
}

mode <- NA
set_mode()
