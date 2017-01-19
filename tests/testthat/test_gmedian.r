library(ratingScaleSummary)
# Test gmedian.factor()
lvls <- c("very important", "2", "3", "4", "5", "6", "not important")
x_a <- sample(x = lvls, size = 2000, replace = T, prob = c(.14, .34, .34, .04, .04, .04, .04))
x_b <- sample(x = lvls, size = 2000, replace = T, prob = c(1, .0, .34, .04, .04, .04, .04))
x_c <- sample(x = lvls, size = 2000, replace = T, prob = c(.1, .0, .34, .04, .1, .1, .04))
x_d <- sample(x = lvls, size = 2000, replace = T, prob = c(.0, .0, .0, .0, .0, .0, 1))
x_e <- sample(x = lvls, size = 2000, replace = T, prob = c(1, .0, .0, .0, .0, .0, .0))
#x_f <- sample(x = lvls, size = 20000000, replace = T, prob = c(.14, .34, .34, .04, .04, .04, .04))

xy_a <- factor(x_a, levels = lvls)
xy_b <- factor(x_b, levels = lvls)
xy_c <- factor(x_c, levels = lvls)
xy_d <- factor(x_d, levels = lvls)
xy_e <- factor(x_e, levels = lvls)
#xy_f <- factor(x_f, levels = lvls)

table(xy_c)

# Test gmedian.numeric() and gmedian.factor() produce the same results.
ratingScaleSummary:::gmedian.factor(xy_a, scale_interval = 1) == ratingScaleSummary:::gmedian.numeric(as.numeric(xy_a), scale_interval = 1)
ratingScaleSummary:::gmedian.factor(xy_b, scale_interval = 1) == ratingScaleSummary:::gmedian.numeric(as.numeric(xy_b), scale_interval = 1)
ratingScaleSummary:::gmedian.factor(xy_c, scale_interval = 1) == ratingScaleSummary:::gmedian.numeric(as.numeric(xy_c), scale_interval = 1)
ratingScaleSummary:::gmedian.factor(xy_d, scale_interval = 1) == ratingScaleSummary:::gmedian.numeric(as.numeric(xy_d), scale_interval = 1)
ratingScaleSummary:::gmedian.factor(xy_e, scale_interval = 1) == ratingScaleSummary:::gmedian.numeric(as.numeric(xy_e), scale_interval = 1)


# Test gmedian() method selection
gmedian(xy_e, scale_interval = 1)
gmedian(xy_e)
gmedian(as.numeric(xy_e))

# Speed test :)
#gmedian(xy_f)
