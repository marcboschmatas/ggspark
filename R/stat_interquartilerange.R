#' Interquartile range
#'
#' stat for geom_ribbon that shows the range between the 1st and 3rd quartile.
#' will automatically compute them from x and y aesthetics.
#' @section Aesthetics:
#' \itemize{
#' \item x
#' \item y
#' }
#'
#' @inheritParams ggplot2::stat_identity
#' @param fill fill colour of ribbon
#' @export
#'
#' @details This should be used in combination with `geom_line()` in order to
#'   draw sparklines.
#'
#' @references Tufte, Edward R. (n.d.) Sparkline theory and practice
#' https://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=0001OR&topic_id=1

#' @importFrom ggplot2 layer
#' @example inst/examples/ex-stat_interquartilerange.R

stat_interquartilerange <- function(mapping = NULL, data = NULL,
                                    geom = "ribbon",
                                    position = "identity", show.legend = FALSE,
                                    inherit.aes = TRUE, fill = "gray90"){
  ggplot2::layer(stat = InterquartileRange, data = data, mapping = mapping,
                 geom = geom,
                 position = position, show.legend = show.legend,
                 inherit.aes = inherit.aes, params = list(fill = fill))
}


#' @rdname stat_interquartilerange
#' @usage NULL
#' @format NULL
#' @importFrom ggplot2 Stat
#' @importFrom ggplot2 ggproto
#' @export
InterquartileRange <- ggplot2::ggproto("InterquartileRange", ggplot2::Stat, # nolint: object_name_linter
                                       compute_group = function(data, scales,
                                                                fill = "gray90") 
                                         {
                                         grid <- data.frame("ymin" = numeric(1),
                                                            "ymax" = numeric(1))
                                         grid$ymin <- quantile(data$y, 0.25)
                                         grid$ymax <- quantile(data$y, 0.75)
                                         grid$fill <- fill
                                         grid <- merge(grid, data, all.y = TRUE)
                                         grid
                                       }
)

