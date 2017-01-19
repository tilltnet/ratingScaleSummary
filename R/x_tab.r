#' Frequency distribution as a data.frame
#'
#' @description Returns a \emph{data.frame} where each row shows the
#' frequencies of unique values in a vector. Weighting is supported.
#'
#' @param x Numeric, character or factor vector, defining the dependent variable.
#' @param y Numeric, character or factor vector, defining groups/ independent variable.
#' @param w Optional weight vector.
#' @examples
#' # Create sample data.
#' df <- data.frame(replicate(2,sample(1:7, 100, replace = T)))
#'
#' x_tab(df[[1]], df[[2]])
#' @export
x_tab <- function(x, y, weight = NULL, p_max = 0.05) {
  print(match.call())
  #print(paste("Cross Table of",as.character(match.call()$x[3]), "and", as.character(match.call()$y[3])))
  chi_sq <- chisq.test(x, y)

    if(is.null(weight)) {
      tab <- round(prop.table(table(x, y), 2), digits = 4)*100
    } else {
      tab <- round(prop.table(xtabs(weight ~ x + y), 2), digits = 4)*100

    }
  tab <- as.data.frame.matrix(tab)
  tab$sig <- c(rep("", NROW(tab) - 1), p_value_to_sig_lvl(chi_sq$p.value))
  tab
}
