American Samoa Model Checks
================
Meg Oshima
2022-07-20

**This is a summary report for the APVI base model run.**

    ## warning.sso file is missing the string 'N warnings'

# Model Output

## Input Data

![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

## Convergence Check

    ##   Converged     MaxGrad
    ## 1     FALSE 6.28186e-05

    ## character(0)

## Fit to Model

### CPUE

    ##      Fleet Link Link+ ExtraStd BiasAdj Float       Q Num=0/Bio=1 Err_type  N Npos     RMSE
    ## 1186     1    1     0        0       0     0 2.46484           1        0 34   34 0.380421
    ## 1187     2    1     0        0       0     0 1.32288           1        0 21   21 0.419754
    ##      mean_input_SE Input+VarAdj Input+VarAdj+extra VarAdj New_VarAdj penalty_mean_Qdev rmse_Qdev
    ## 1186      0.283801     0.283801           0.283801      0  0.0966208                 0         0
    ## 1187      0.337726     0.337726           0.337726      0  0.0820274                 0         0
    ##      fleetname
    ## 1186   FISHERY
    ## 1187   SURVEY2

    ## Running Runs Test Diagnostics w/ plots forIndex

    ## Plotting Residual Runs Tests

![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

    ## Residual Runs Test (/w plot) stats by Index:

    ## Running Runs Test Diagnostics w/ plots forIndex
    ## Plotting Residual Runs Tests

![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->

    ## Residual Runs Test (/w plot) stats by Index:

    ## Plotting JABBA residual plot

![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-4-3.png)<!-- -->

    ## RMSE stats by Index:

### Length Comp

    ##      Factor Fleet Recommend_var_adj #  N Npos min_Nsamp max_Nsamp mean_Nsamp_in mean_Nsamp_adj
    ## 1216      4     1          0.308132 # 14   14   27.5261   237.356        153.42        82.4172
    ##      mean_Nsamp_DM DM_theta mean_effN HarMean_effN Curr_Var_Adj Fleet_name
    ## 1216            NA       NA    62.899      47.2737       0.5372    FISHERY

    ## Running Runs Test Diagnostics w/ plots forMean length

    ## Plotting Residual Runs Tests

    ## Residual Runs Test (/w plot) stats by Mean length:

    ##     Index runs.p   test   sigma3.lo  sigma3.hi type
    ## 1 FISHERY  0.145 Passed -0.08744021 0.08744021  len

    ## Plotting JABBA residual plot

![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

    ## RMSE stats by Index:

    ## # A tibble: 2 x 3
    ##   Fleet    RMSE.perc  Nobs
    ##   <chr>        <dbl> <int>
    ## 1 FISHERY        3.4    14
    ## 2 Combined       3.4    14

![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-5-3.png)<!-- -->![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-5-4.png)<!-- -->

## Retrospective and Hindcasting

### Retrospective

    ## [1] "No retrospective runs were found"

### Hindcasting

    ## [1] "No information for hindcast was found"

## Recruitment Deviations

![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-8-2.png)<!-- -->

## Likelihood Profile

    ## [1] "No likelihood runs were found"

## Management Quantities

    ## 
    ##  starter.sso with Bratio: SSB/SSBMSY and F: _abs_F 
    ## 

![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

    ## Warning: The `pdf` argument of `SSplotEnsemble()` is deprecated as of ss3diags 2.0.0.
    ## Please use the `use_pdf` argument instead.
    ## This warning is displayed once every 8 hours.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was generated.

    ## Plot Comparison of stock

    ## Plot Comparison of harvest

![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-10-2.png)<!-- -->

    ## Plot Comparison of SSB

![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-10-3.png)<!-- -->

    ## Plot Comparison of F

![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-10-4.png)<!-- -->![](C:\Users\Megumi.Oshima\Documents\AmSam-Bottomfish-2023\SS3%20models\APVI\test\APVI_test_SS3_Diags_Report_files/figure-gfm/unnamed-chunk-10-5.png)<!-- -->

    ## null device 
    ##           1

## Jitter

    ## [1] "No jitter runs were found."

## 
