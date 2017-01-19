tapply_to_df <- function(var_, groups) {
  comp_array <- tapply(var_, groups, gmedian)
  comp_vec <- as.vector(comp_array)
  names_ <- names(comp_array)
  t(as.data.frame(comp_vec))
}

create_sig_col <- function(df, groups) {
  sig_lvls <- c()
  for(var_ in names(df)) {
    p_value <- kruskal.test(df[[var_]], groups)$p.value
    sig_lvls <- c(sig_lvls, p_value_to_sig_lvl(p_value))
  }
  data.frame(sig = sig_lvls)
}

p_value_to_sig_lvl <- function(p_value) {
  if(p_value <= 0.001) {
    '***'
  } else if(p_value <= 0.01) {
    '**'
  } else if(p_value <= 0.05) {
    '*'
  } else if(p_value <= 0.1) {
    '.'
  } else {
    'n.s.'
  }
}

# Corplot tutorial: http://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html
cor.mtest <- function(mat, conf.level = 0.95) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat <- lowCI.mat <- uppCI.mat <- matrix(NA, n, n)
  diag(p.mat) <- 0
  diag(lowCI.mat) <- diag(uppCI.mat) <- 1
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], conf.level = conf.level)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
      lowCI.mat[i, j] <- lowCI.mat[j, i] <- tmp$conf.int[1]
      uppCI.mat[i, j] <- uppCI.mat[j, i] <- tmp$conf.int[2]
    }
  }
  return(list(p.mat, lowCI.mat, uppCI.mat))
}
