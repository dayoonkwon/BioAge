
# BioAge

<!-- badges: start -->
<!-- badges: end -->

This package measures biological aging using data from the National Health and Nutrition Examination Survey (NHANES). The package uses published biomarker algorithms to calculate three biological aging measures: Klemera-Doubal Method (KDM) Biological Age, Phenotypic Age, and homeostatic dysregulation.

## Installation (via devtools):

You can install the released version of BioAge from (https://github.com/dayoonkwon/BioAge) with:

``` r
devtools::install_github("dayoonkwon/BioAge")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(BioAge)

biomarkers = c("albumin","alp","lymph","mcv","lncreat","lncrp","hba1c","wbc","rdw")

# homeostatic disregulation -----------------------------------------------
hd = hd_nhanes(biomarkers)
hd_data = hd$data

# KDM bioage --------------------------------------------------------------
bioage = bioage_nhanes(biomarkers)
bioage_data = bioage$data

# Phenoage ----------------------------------------------------------------
phenoage = phenoage_nhanes(biomarkers)
phenoage_data = phenoage$data

```

