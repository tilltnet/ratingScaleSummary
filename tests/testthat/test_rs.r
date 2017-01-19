source("create_test_datar.R")
df <- create_test_data()
df_ <- df

res_comp <- rs_compare_groups(df = df_[1:6], groups = df_$g)
res_comp2 <- rs_compare_groups(df = df_[1:6], groups = df_$g2)

vert_line_gg(x = res_comp)
vert_line_base(x = res_comp, max_val = 7)

rs_summary(df = df[1:6])
res <- rs_summary(df = df[1:6], item_labels = names(df)[1:6], item_levels = levels(df$kburtqsw))

vert_line_base(x = res["Median"], max_val = 7)
vert_line_gg(x = res["Median"], max_val = 7)

