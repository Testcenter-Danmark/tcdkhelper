#' Save KPI plot
#'
#' @description Save a plot to a number of friendly formats
#'
#' @param path File path
#' @param format A string giving output format ("a3", "a4", or "screen")
#' @param mode Mode of operation. See [modes] for more.
#' @param margin Margin of plot (in inches). Default of 0.17 matches most printers.
#' @param plot ggplot2 plot
#' @param dpi A number giving DPI
#' @param force_path bool
#' @param portrait bool
#' @param debug bool
#'
#' @importFrom ggplot2 last_plot
#' @importFrom grDevices pdf
#' @importFrom grid unit
#' @importFrom tibble tibble
#'
#' @export

save_kpi <-
  function(path,
           format = "screen",
           mode = get_mode(),
           margin = 0.17,
           plot = ggplot2::last_plot(),
           dpi = 300,
           force_path = F,
           portrait = F,
           debug = F) {

    dir_path <- file.path(getOption("tcdkhelper.sdrive"),
                          "svl",
                          "TestCenter",
                          "KPI",
                          "KPI-PLOTS")

    if (format == "screen") {
      dpi = 100
      margin = 0
      plot = plot + ggplot2::theme(plot.margin = grid::unit(rep(0.02, 4), "npc"))
    }

    if (force_path) {
      # Don't assign new path
    } else if (mode == "RStudio") {
      dir_path <- "KPI-PLOTS"
    } else {
      path <- file.path(dir_path, path)
    }

    dir.create(dir_path, recursive = T)

    print_dims <- tibble(
      meas = c("height", "width"),
      a3 = c(11.7, 16.5),
      a4 = c(8.3, 11.7),
      screen = c(1080 / dpi, 1920 / dpi)
    )
    if (portrait) print_dims[format] <- rev(print_dims[[format]])
    # Default margin of 0.17 fits printable area

    if (!(mode == "compile" | debug)) {
      ggplot2::ggsave(
        path,
        height = as.numeric(print_dims[1, format]) - 2 * margin,
        width = as.numeric(print_dims[2, format]) - 2 * margin,
        plot = plot,
        dpi = dpi
      )
    } else {
      if (debug) {
        print(plot)
        message("Will save as ", path)
      }
    }
  }
