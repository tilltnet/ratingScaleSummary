source("create_test_datar.R")

df <- create_test_data()

x_tab_res <- x_tab(df[[1]], df[[2]])

levels_x <- levels(df[[1]])
levels_y <- levels(df[[2]])

expect_equal(rownames(x_tab_res), levels_x)
expect_equal(colnames(x_tab_res)[-length(colnames(x_tab_res))], levels_y)

expect_is(x_tab_res, "data.frame")
