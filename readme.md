# Analysing and visualising rating scales in R using ratingScaleSummary
Till Krenz  
`r Sys.Date()`  




# ratingScaleSummary

This package is supposed to give a fast and useful summary and visualisation
of a rating scale, consisting of several variables using the same categories/
codings. These procedures might be useful for social scientists and psychologists
and everyone else working with data collected via surveys making use of the the
concept of multiple indicators for the measurment of dimensions of abstract or
complex social concepts and terms. 

In addition there are functions for calculating the interpolated median
and percentiles of a grouped frequency distribution, the inter quartile range,
and relative frequency and cross tables. The latter functions produce data
frames, the output is therefore modified and reused much easier, than the
outputs created by, e.g. the functions of the package 'descr'. The functions in
this package produce output that is supposed to be easily integrated into
RMarkdown and knitr files.

# Install Package

For now the ratingSclaeSummary package is not available on CRAN, but it can be
installed driectly from github from within R using the devtools package

    devtools::install_github('ratingScaleSummary/tilltnet')

or by using the source package for a local install.

# Let's get started: creating sample data

We start with creating some sample data, that will be used throughout this
vignette. We'll need a *data.frame* consisting of several variables, all using the
same categories. In addition we create a grouping variable, that is used for
the examples that incorporate group comparisson.


```r
df <- data.frame(replicate(6,sample(as.character(1:7), 2000, replace = T, prob = sample(1:100/100, 7))))
var_names <- lapply(1:6, FUN = function(x) paste(sample(letters, sample(6:13, 1)), collapse = ""))
names(df) <- var_names

g <- sample(c("G1", "G2", "G3"), 2000, replace = T)
```


# Summarise a rating scale

rs_summary() returns a **data.frame** where each row
represents one variable. It provides categories' frequencies (in %),
N, median, and the interquartile range.

```r
library(ratingScaleSummary)
res <- rs_summary(df = df)
knitr::kable(res)
```

                    1      2      3      4      5      6      7      N   Median   intQR   NA
--------------  -----  -----  -----  -----  -----  -----  -----  -----  -------  ------  ---
xymeuhqzlfi      13.4   20.9   16.7   17.2    5.1   23.5    3.2   2000    3.443   3.517    0
bqlmeao          11.1   12.5   23.4   20.4   16.4    2.8   13.4   2000    3.647   2.398    0
pchweaimlr       10.7   12.3   18.4   14.7   18.6    9.4   16.0   2000    4.088   2.933    0
qjpevfkh         17.9   12.4    0.4   20.1   18.2   16.2   14.8   2000    4.458   3.797    0
tjsvoxnighdpc    11.7   20.9    3.8   14.0   17.1   32.2    0.4   2000    4.482   3.600    0
zjfxdslph         1.0    6.2   18.8   14.2   16.6   21.7   21.6   2000    5.092   2.892    0

The rs_summary() command gives a summary of the

## Visualise medians of a rating scale

vert_line_base() and vert_line_gg() plots a vertical line dot plot using base plotting or ggplot2.


```r
# Using base plot.
vert_line_base(x = res["Median"], max_val = 7)
```

![](readme_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

```r
# Using ggplot2.
vert_line_gg(x = res["Median"], max_val = 7)
```

![](readme_files/figure-html/unnamed-chunk-3-2.png)<!-- -->

# Compare the responses to a rating scale by groups

Returns a **data.frame** where each row represents one variable
and the columns show the median values of the comparison groups. An additional
colum shows the significance levels, based on the **Kruskal-Wallis** **Rank**
**Sum** **Test**.



```r
# Compare medians between groups accross several variables.
res_comp <- rs_compare_groups(df = df, groups = g)
```

```
## Warning in rs_compare_groups(df = df, groups = g): 'groups' is not a
## factor. Converting to factor.
```

```r
knitr::kable(res_comp)
```

                    G1      G2      G3  sig  
--------------  ------  ------  ------  -----
xymeuhqzlfi      3.462   3.451   3.416  n.s. 
bqlmeao          3.564   3.721   3.661  n.s. 
pchweaimlr       4.186   4.073   4.000  n.s. 
qjpevfkh         4.429   4.470   4.476  n.s. 
tjsvoxnighdpc    4.517   4.429   4.500  n.s. 
zjfxdslph        5.163   4.989   5.167  n.s. 

## Visualise the comparisson

vert_line_base() and vert_line_gg() also produce plots for group comparisson.


```r
# Using base plot.
vert_line_base(x = res_comp, max_val = 7)
```

![](readme_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

```r
# Using ggplot2.
vert_line_gg(x = res_comp, max_val = 7)
```

![](readme_files/figure-html/unnamed-chunk-5-2.png)<!-- -->

# Using ggplot2 theming


```r
library(ggthemes)
vert_line_gg(x = res["Median"], max_val = 7) +  theme_hc()
```

![](readme_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

```r
vert_line_gg(x = res_comp, max_val = 7) + theme_wsj()
```

![](readme_files/figure-html/unnamed-chunk-6-2.png)<!-- -->


# Miscellaneous functions within the package

 - gmedian() calculates the interpolated median of a grouped
   frequency distribution.
 - intQR() calculates interquartile range of a grouped frequency
   distribution.
 - mQ() Calculates halfed interquartile range [german: mittlerer 
   Quartilsabstand] of a grouped frequency distribution
 - f_tab() returns a \emph{data.frame} where each row shows the
   frequencies of unique values in a vector. Weighting is supported.
 - x_tab() returns a \emph{data.frame} as a crosstable with indication of 
   statistic significance using chi-square. Weighting is supported.
