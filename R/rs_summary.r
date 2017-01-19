#' Summarize a questionaire battery of equally coded ordinal/ categorial variables
#'
#' @description Returns a \emph{data.frame} where each row
#' represents one variable. It provides categories' frequencies,
#' N, median, and the interquartile range.
#' @param df data.frame containing the variables
#' @param item_labels vector of variable names
#' @param item_levels vector of variable levels
#' @param l_mar numeric value for left margin of plot
#' @examples
#' # Create sample data.
#' df <- data.frame(replicate(6,sample(1:7, 100, replace = T)))
#'
#' res <- rs_summary(df = df)
#' @export
rs_summary <- function(df, item_labels = NULL, item_levels = NULL, l_mar = 12, cor = F, ...) {
  wtd.percent.table <- function(var, ...) {
    res <- round(prop.table(questionr::wtd.table(var, na.show = F, ...))*100, 1)
    res
  }

  wtd.samplesize <- function(var, ...) {
    wtd_table <- Hmisc::wtd.table(var, na.rm = T, ...)
    sum(wtd_table$sum.of.w)
  }

  if(is.null(item_labels)) item_labels <- names(df)
  if(is.null(item_levels)) item_levels <-  levels(df[,1])

  perc_table <- lapply(df, FUN = function(x) wtd.percent.table(x))
  perc_table <- as.data.frame(do.call(rbind, perc_table))

  #perc_table <- as.data.frame(t(lapply(df, FUN = function(x) wtd.percent.table(x, ...))))
  level_sort <- levels(df[[1]])

  cross <- cbind(
    perc_table[level_sort],
    plyr::ldply(df, function(x) wtd.samplesize(x, ...))[-1],
    plyr::ldply(df, function(x) gmedian(x, ...))[-1],
    plyr::ldply(df, function(x) intQR(x, ...))[-1],
    plyr::ldply(df, function(x) sum(is.na(x)))[-1])
  rownames(cross) <- item_labels
  names(cross) <- c(item_levels,"N","Median", "intQR", "NA")

  attr(cross["Median"], "max_val") <- max(as.numeric(df[[1]]))
  attr(cross["Median"], "min_val") <- min(as.numeric(df[[1]]))

  # Sort by median values
  cross[order(cross$Median),]
}

#' Summarize a questionaire battery of equally coded ordinal/ categorial
#' variables - Convenience Function
#'
#' @description \emph{This is a convenience funtion for summary_ordinal()}
#' Returns a \emph{data.frame} where each row #' represents one variable.
#' It provides categories' frequencies, #' N, median, and the interquartile
#' range.
#'
#' @param df data.frame containing the variables (possibly amongst
#' other variables)
#' @param var_start vector of variable names
#' @param var_end vector of variable levels
#' @export
