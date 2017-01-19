create_test_data <- function(){
  create_rand_factor <- function() {
    lvls <- c("very important", "2", "3", "4", "5", "6", "not important")

    probs <- sample(1:100/100, 7)
    x <- sample(c("very important", "2", "3", "4", "5", "6", "not important"), 100, replace = T, prob = probs)
    factor(x, levels = lvls)
  }

  var_names <- lapply(1:6, FUN = function(x) paste(sample(letters, sample(6:13, 1)), collapse = ""))
  vars_l <- lapply(1:6, FUN = function(x) create_rand_factor())
  names(vars_l) <- var_names

  g <- factor(sample(c("Group 1", "Group 2", "Group 3"), 100, replace = T))
  g2 <- sample(c("Group 1", "Group 2", "Group 3"), 100, replace = T)
   data.frame(vars_l, g, g2, stringsAsFactors = F)
}
