#' Compare Medians of a questionnaire battery of equally coded ordinal/
#' categorial variables
#'
#' @description Returns a \emph{data.frame} where each row represents one variable
#' and the columns show the median values of the comparison groups. An additional
#' colum shows the significance levels, based on the \emph{Kruskal-Wallis Rank
#' Sum Test}.
#'
#' @param df dataframe containing the rating scale variables
#' @param groups vector defining groups/ independent variable
#' @param item_labels optional character vector of variable labels
#' @param w Optional weight vector.
#' @param ... additional options for gmedian(), e.g. percentile, scale_intervall or w(eight).
#' @examples
#' # Create sample data.
#' df <- data.frame(replicate(6,sample(1:7, 100, replace = T)))
#'
#' # Compare medians between groups accross several variables.
#' g <- sample(c("G1", "G2", "G3"), 100, replace = T)
#' res_comp <- rs_compare_groups(df = df, groups = g)
#' @export
rs_compare_groups <- function(df, groups, item_labels = NULL, w = NULL, ...) {

  if(!is.factor(groups)) {
    warning("'groups' is not a factor. Converting to factor.")
    groups <- factor(groups)
  }
  av_names <- names(df)

  #   comp_df <- data.frame()
  #   for(var_ in av_names) {
  #     temp_df <- tapply_to_df(df[[var_]], groups)
  #     comp_df <- rbind(comp_df, temp_df)
  #   }

  subsets_ <-  list()
  i <- 1
  for(lev_ in levels(groups)) {
    subsets_[[lev_]] <- subset(df, groups == lev_)
    i <- i + 1
  }

  if(is.null(w)) {
    comp_df <- do.call(cbind, lapply(subsets_,
                                     FUN = function(x) plyr::ldply(x[av_names],
                                                                   function(y) gmedian(y, ...))[-1]))
  } else {
    comp_df <- do.call(cbind, lapply(subsets_,
                                     FUN = function(x) plyr::ldply(x[av_names],
                                                                   function(y) gmedian(y, w = x[[w]], ...))[-1]))
  }
  names(comp_df) <- levels(groups)
  rownames(comp_df) <- av_names
  if(!is.null(item_labels)) {
    rownames(comp_df) <- item_labels[low_:high_]
  }
  comp_df <- cbind(comp_df, create_sig_col(df[av_names], groups))
  comp_df[order(comp_df[1]),]
}
