
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fars

<!-- badges: start -->

<!-- badges: end -->

`fars` package provides easy exploration analysis of FARS (Fatality
Analysis Reporting System) accidents dataset with summary and plot
functions. This dataset is provides fatal crash reports within the 50 US
States, Puerto Rico and British Columbia since 1975.

## Required set-up for this package

Currently, this package exists in a development version on GitHub. To
use the package, you need to install it directly from GitHub using the
`install_github` function from `devtools`.

The actual `fars` package reads accidents datasets with the naming
convention “accidents-yyyy.csv.bz2”, with an integer column value
`STATE` represented as alphabetical order (i.e. Alabama=0, Alaska=1,
Arizona=3, … ), for plotting, location of the traffic crash, with
columns coordinates `LONGITUDE` and `LATITUDE`.

## Example

This is an example which shows how to get summaries:

``` r
library(fars)
## to see a summary of accidents, we can specify a single value:
fars::fars_summarize_years(2013)
#> Warning: `tbl_df()` is deprecated as of dplyr 1.0.0.
#> Please use `tibble::as_tibble()` instead.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_warnings()` to see where this warning was generated.
#> # A tibble: 12 x 2
#>    MONTH `2013`
#>    <dbl>  <int>
#>  1     1   2230
#>  2     2   1952
#>  3     3   2356
#>  4     4   2300
#>  5     5   2532
#>  6     6   2692
#>  7     7   2660
#>  8     8   2899
#>  9     9   2741
#> 10    10   2768
#> 11    11   2615
#> 12    12   2457
# or a list of values,
fars::fars_summarize_years(2013:2015)
#> # A tibble: 12 x 4
#>    MONTH `2013` `2014` `2015`
#>    <dbl>  <int>  <int>  <int>
#>  1     1   2230   2168   2368
#>  2     2   1952   1893   1968
#>  3     3   2356   2245   2385
#>  4     4   2300   2308   2430
#>  5     5   2532   2596   2847
#>  6     6   2692   2583   2765
#>  7     7   2660   2696   2998
#>  8     8   2899   2800   3016
#>  9     9   2741   2618   2865
#> 10    10   2768   2831   3019
#> 11    11   2615   2714   2724
#> 12    12   2457   2604   2781
# or a set of values,
fars::fars_summarize_years(c(2013,2015))
#> # A tibble: 12 x 3
#>    MONTH `2013` `2015`
#>    <dbl>  <int>  <int>
#>  1     1   2230   2368
#>  2     2   1952   1968
#>  3     3   2356   2385
#>  4     4   2300   2430
#>  5     5   2532   2847
#>  6     6   2692   2765
#>  7     7   2660   2998
#>  8     8   2899   3016
#>  9     9   2741   2865
#> 10    10   2768   3019
#> 11    11   2615   2724
#> 12    12   2457   2781
```

This other example shows how to plot accidents location in a state:

``` r
library(fars)
## Alabama state crashes occured in 2013
fars::fars_map_state(1, 2013)
```

<img src="man/figures/README-example_plot-1.png" width="100%" />
