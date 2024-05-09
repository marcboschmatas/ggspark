#' @rdname stat_sparklabels
#' @usage NULL
#' @format NULL
#' @importFrom ggplot2 Stat
#' @importFrom ggplot2 ggproto
#' @export
SparkLabels <- ggplot2::ggproto("SparkLabels", ggplot2::Stat, # nolint: object_name_linter
                                required_aes = c("x", "y"),
                                compute_group = function(data, scales,
                                                         label_fun) {
                                  transform_label <- function(x,
                                                              f = label_fun) {
                                    if (is.null(f) || !is.function(f)) {
                                      return(x)
                                    } else {
                                      result <- tryCatch(f(x),
                                                         error = function(e) {
                                                           warning("error")
                                                           return(x)
                                                         })
                                      return(result)
                                    }
                                  }
                                  minim <- data[data$y == min(data$y),]
                                  if(nrow(minim) > 1) minim <- minim[1,]
                                  minim$label <- lapply(minim$y,
                                                        transform_label)
                                  minim$colour <- "min"
                                  
                                  maxim <- data[data$y == max(data$y), ]
                                  if (nrow(maxim) > 1) maxim <- maxim[1, ]
                                  maxim$label <- lapply(maxim$y,
                                                        transform_label)
                                  maxim$colour <- "max"
                                  start <- data[data$x == min(data$x), ]
                                  if (nrow(start) > 1) start <- start[1, ]
                                  start$label <- lapply(start$y,
                                                        transform_label)
                                  start$colour <- "start/finish"
                                  
                                  finish <- data[data$x == max(data$x),]
                                  if (nrow(finish) > 1) finish <- finish[1,]
                                  finish$label <- lapply(finish$y,
                                                         transform_label)
                                  finish$colour <- "start/finish"
                                  
                                  grid <- rbind(start, minim, maxim, finish)
                                  grid$colour <- factor(grid$colour,
                                                        levels = c("start/finish",
                                                                   "max",
                                                                   "min"))
                                  grid
                                }
)

#' Interquartile range
#'
#' stat for points or labels at the start, end, max, and min values of a line.
#' will automatically compute them from x and y aesthetics.
#' can use either geom = "point"
#' @section Aesthetics:
#' \itemize{
#' \item x
#' \item y
#' }
#'
#' @inheritParams ggplot2::stat_identity
#' @param label_fun function to adapt labels (p. ex. round or add suffixs)
#' @param geom either "point", "text", or "label"
#' @export
#'
#' @details This should be used in combination with `geom_line()` in order to
#'   draw sparklines.
#'
#' @references Tufte, Edward R. (n.d.) Sparkline theory and practice
#' https://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=0001OR&topic_id=1

#' @importFrom ggplot2 layer
#' @example inst/examples/ex-stat_interquartilerange.R
stat_sparklabels <- function(mapping = NULL, data = NULL, geom = "label",
                             label_fun = NULL,
                             position = "identity", show.legend = TRUE,
                             inherit.aes = TRUE){
  ggplot2::layer(stat = SparkLabels, data = data, mapping = mapping,
                 geom = geom, 
                 params = list(label_fun = label_fun),
                 position = position, show.legend = show.legend,
                 inherit.aes = inherit.aes)
}