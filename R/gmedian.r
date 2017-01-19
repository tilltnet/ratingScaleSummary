#' Estimates Median of a grouped frequency distribution.
#'
#' \code{gmedian} calculates the interpolated median of a grouped
#' frequency distribution.
#' @param x factor or numeric vector to draw the frequency distribution from.
#' @param percentile value between 0 and 1; default = 0.5 (median)
#' @param scale_interval group intervall; default = 1
#' @param w an optional vector of weights
#' @details \code{gmedian} can be used with \code{factor} and \code{numeric}
#' vectors.
#' If the values of \code{x} represent numeric ranges, like 1-10, 11-20, 21-30,
#' values should be \code{numeric} starting values of range and
#' \code{scale_interval} should be used to indicate the range intervall.
#' @return Estimated Median for the given grouped frequency distribution as a
#' numeric vector.
#' @name gmedian
#' @examples
#' lvls <- c("very important", "2", "3", "4", "5", "6", "not important")
#' x <- sample(lvls, size = 100, replace = T)
#' gmedian(x)
#'
#' # 25% Quartile
#' gmedian(x, 0.25)
#' @export
gmedian <- function(x,
                    percentile = 0.5,
                    scale_interval = 1,
                    w = NULL)
                      UseMethod("gmedian")

#' @rdname gmedian
#' @method gmedian factor
#' @export
gmedian.factor <- function(x, percentile = 0.5, scale_interval = 1, w = NULL) {
  table_x <- questionr::wtd.table(x, w = w)
  egs <- Hmisc::wtd.quantile(as.numeric(x), w, probs = percentile, na.rm=T)
  calc_gmedian(table_x,
               egs,
               egs,
               percentile = percentile,
               mode = "factor",
               scale_interval = scale_interval,
               w = w)
}

#' @rdname gmedian
#' @method gmedian numeric
#' @export
gmedian.numeric <- function(x, percentile = 0.5, scale_interval = 1, w = NULL) {
  table_x <- questionr::wtd.table(x, w = w)
  egs_val <- Hmisc::wtd.quantile(as.numeric(x), w, probs = percentile, na.rm=T)

  # Values that are not present in a numeric variable, need special care
  egs <- length(Hmisc::wtd.table(subset(x, x <= egs_val), type = 'table'))
  calc_gmedian(table_x,
               egs_val,
               egs,
               percentile = percentile,
               mode = "numeric",
               scale_interval = scale_interval,
               w = w)
}

calc_gmedian <- function(table_x,
                         egs_val,
                         egs,
                         percentile,
                         mode,
                         scale_interval,
                         w) {
  sum_below_median <- sum(table_x[1 : egs - 1])
  sum_valid_vals <- sum(table_x)
  interpol <- (sum_valid_vals * percentile - sum_below_median) / table_x[egs] * scale_interval

  # if the interpolation term is positive it's substracted of the egs, henceforth...
  algeb_sign <- ifelse(interpol <= 0, -1, 1)

  # calculate the Median value, round and return it
  grp_detect <- ifelse(scale_interval==1, 0.5 , 0)
  table_df <- as.data.frame(table_x)

  if(mode == "numeric") {
    val <- as.numeric(as.character(table_df[egs, 1])) - grp_detect + (interpol * algeb_sign)
  } else {
    val <- as.numeric(rownames(table_df)[egs]) - grp_detect + (interpol * algeb_sign)
  }
  round(val, digits = 3)
}


#' @describeIn intQR Calculates halfed interquartile range
#' [ger. mittlerer Quartilsabstand] of a grouped frequency distribution
#' @param x factor or numeric vector to draw the frequency distribution from.
#' @param ... additional parameters to pass to \code{gmedian()}
#' @export
mQ <- function(x, ...) {
  intQR(x, ...) / 2
}

#' Interquartile range of a grouped frequency distribution.
#'
#' @description  Calculates interquartile range of a grouped frequency
#' distribution.
#' @export
intQR <- function(x, ...) {
  gmedian(x, 0.75, ...) - gmedian(x, 0.25, ...)
}
