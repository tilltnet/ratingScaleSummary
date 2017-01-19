#' @describeIn vert_line_base Uses ggplot2 for vertical line plot. Allows
#' for usage of ggplot2's theming.
#' @export
vert_line_gg <- function(x, max_val = NULL, min_val = 1) {
  if(is.null(max_val) & NCOL(x) > 1) {
    max_val <- round(max(do.call(c, x[1:NCOL(x)-1])))
  } else if(is.null(max_val)) {
    max_val <- round(max(x[1]))
  }

  sig <- FALSE
  if(names(x)[NCOL(x)] == 'sig') {
    sig_text <- x[[NCOL(x)]]
    x <- x[, -NCOL(x)]
    ix <- NCOL(x)
    yps <- NROW(x)
    sig_text_ <- c(as.character(sig_text), rep("", (ix - 1)*yps))
    sig <- TRUE
  }

  comp_gg <- data.frame(names = rownames(x), x)

  comp_gg <- reshape2::melt(comp_gg, "names")
  #comp_gg <- dplyr::arrange(comp_gg, names) # implement other orders
  comp_gg$names <- factor(comp_gg$names, levels = rownames(x))

  gg <- ggplot2::ggplot(comp_gg, ggplot2::aes(names, value, group = 1)) +
    ggplot2::geom_path(ggplot2::aes(group = variable, linetype = variable), size = 0.7) +
    ggplot2::scale_linetype_manual(values = rep(c(1,1,2,3,4,1,1), 20), name = "Groups") +
    ggplot2::geom_point(ggplot2::aes(group = variable, shape = variable, fill = variable), size = 5) +
    ggplot2::scale_fill_manual(values=rep(c("Black", "White", "grey", "white"),20), name = "Groups") +
    ggplot2::scale_shape_manual(values=rep(c(21,22,23,21,24), 20), name = "Groups") +
    ggplot2::coord_flip(ylim = c(min_val, max_val + 1))
    #ggplot2::scale_y_continuous(breaks = min_val:max_val) +
    #ggplot2::scale_x_continuous(sec.axis = sec_axis(~ . * 1, name = "mpg (UK)")) +
    #ggplot2::scale_x_discrete(position = "top", label = sig_text)

  if(sig) {
    gg <- gg + ggplot2::geom_text(label = sig_text_, x = rep(1:yps, ix), y = max_val + 1)
  }
  gg
}
