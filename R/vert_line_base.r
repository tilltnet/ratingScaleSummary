#' Dotcharts of categorial variables
#'
#' @param x data.frame containing the variables
#' @param max_val Absolute scale end as a numeric value.
#' @param min_val Absolute scale start as a numeric value; default = 1
#' @param l_mar Left margin; default = 10
#' @param b_mar Bottom margin; default = 6
#' @param scale_interval default = 1
#' @examples
#' # Create sample data.
#' df <- data.frame(replicate(6,sample(1:7, 100, replace = T)))
#'
#' # Plot medians of several variables.
#' res <- rs_summary(df = df)
#' # Using base plot.
#' vert_line_base(x = res["Median"])
#' # Using ggplot2.
#' vert_line_gg(x = res["Median"])
#'
#' # Compare medians between groups accross several variables.
#' g <- sample(c("G1", "G2", "G3"), 100, replace = T)
#' res_comp <- rs_compare_groups(df = df, groups = g)
#' # Using base plot.
#' vert_line_base(x = res_comp)
#' # Using ggplot2.
#' vert_line_gg(x = res_comp)
#' @export
vert_line_base <- function(x, max_val = NULL, min_val = 1, l_mar =  10, b_mar = 6, scale_interval = 1, ...) {
  r_mar <- 1
  ncol_df <- NCOL(x)
  if(names(x)[ncol_df] == 'sig') {
    r_mar <- 5 # adjust right margin for sig levs
    sig_lvls <- as.vector(x[, ncol_df])
    x <- x[, -ncol_df]
  }
  # vectors of line_styles, shape_colors, shape_styles to cycle through if more than one group is visualised
  line_styles <- c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash", "solid", "dashed", "dotted", "dotdash", "longdash", "twodash")
  shape_colors <- c("#000000", "#ffffff", "#777777", "#bbbbbb")
  shape_styles <- c(21, 23, 22, 24, 25, 19, 18, 15, 17, 2, 7)

  # adjust margins
  par(mar=c(b_mar, l_mar, 3, r_mar))

  # plot empty canvas
  if(is.null(max_val)) {
    if("max_val" %in% names(attributes(x))) {
        max_val <- attr(x, "max_val")
    } else {
      max_val <- round(max(do.call(c, x[1:NCOL(x)])))
    }
  }
  if(is.null(min_val)) {
    if("min_val" %in% names(attributes(x))) {
      min_val <- attr(x, "min_val")
    } else {
      min_val <- round(max(do.call(c, x[1:NCOL(x)])))
    }
  }


  plot(NA, xlim = c(min_val, max_val), ylim = c(0.75,NROW(x) + 0.25),  type = "n",  yaxt="n", xaxt="n", ylab="", xlab="", bty="L")

  # ad axis and box
  axis(3, at = seq(min_val, max_val, by = scale_interval))
  box()

  # label 'variables'
  labels <- rownames(x)
  text(y = seq(1, NROW(x)), par("usr")[1], labels = labels, srt = 0, pos = 2, xpd = TRUE, adj = 1)
  if(exists("sig_lvls")) {
    text(y = seq(1, NROW(x)), par("usr")[2], labels = sig_lvls, srt = 0, pos = 4, xpd = TRUE, adj = 1)
  }

  # create vector of y coordinates for point placement
  y = c(1:NROW(x))

  # for every group/ column in data.frame, plot points
  color_hlp = 1
  for(i in 1:NCOL(x)) {
    points(x[[i]],y, type="b", pch=shape_styles[i], lty=line_styles[i], cex=2, bg=shape_colors[color_hlp])
    ifelse(color_hlp==4, color_hlp <- 1, color_hlp <- 1 + color_hlp)
  }

  # enable plotting outside margins and add legend
  par(xpd=TRUE)
  leg_x_pos = (max_val-min_val)/2
  legend(x =leg_x_pos, y = 0.1, legend= names(x), lty = line_styles, pt.bg = shape_colors, pt.cex = 1.5,  pch = shape_styles)
  par(mar = c(4,4,2,2))
}
