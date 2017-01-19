#' Frequency distribution as a data.frame
#'
#' @description Returns a \emph{data.frame} where each row shows the
#' frequencies of unique values in a vector. Weighting is supported.
#'
#' @param x Numeric, character or factor.
#' @param w Optional weight vector.
#' @examples
#' x <- sample(1:20, 100, replace = T)
#' f_tab(x)
#' @export
f_tab <- function(x, w = NULL) {
  freq_x <- questionr::wtd.table(x, na.show = T, weights = w)
  N <- sum(freq_x)
  N_no_NA <- N - freq_x[length(freq_x)]
  freq_perc <- round(freq_x * 100 / N, 1)
  freq_perc_no_na <- round(freq_x[1:(length(freq_x) - 1)] * 100 / N_no_NA, 1)

  x <- factor(x)
  data.frame(row.names = c(levels(x), '<NA>'),
             Freq = c(freq_x),
             Percent = c(freq_perc),
             Valid = c(freq_perc_no_na, NA))
}
