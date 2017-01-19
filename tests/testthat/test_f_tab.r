# Numeric
x_num <- sample(1:20, 2000, replace = T)
f_tab(x_num)

x_num[sample(1:2000, 300)] <- NA
f_tab(x_num)



# Logical
x_logical <- sample(c(TRUE, FALSE), 2000, replace = T)
is.logical(x_logical)
f_tab(x_logical)

x_logical[sample(1:2000, 300)] <- NA
f_tab(x_logical)

# Factor
create_rand_factor <- function() {
  lvls <- c("very important", "2", "3", "4", "5", "6", "not important")
  probs <- sample(1:100/100, 7)
  x <- sample(c("very important", "2", "3", "4", "5", "6", "not important"), 2000, replace = T, prob = probs)
  factor(x, levels = lvls)
}

x_fac <- create_rand_factor()
f_tab(x_fac)

x_fac[sample(1:2000, 300)] <- NA
knitr::kable(f_tab(x_fac))

# Weights
weights_ <- sample(1:100/100, 2000, replace = T)
f_tab(x_fac, w = weights_)

