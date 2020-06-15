
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BioAge

This package measures biological aging using data from the National
Health and Nutrition Examination Survey (NHANES). The package uses
published biomarker algorithms to calculate three biological aging
measures: Klemera-Doubal Method (KDM) biological age, phenotypic age,
and homeostatic dysregulation.

## Installation (via devtools):

You can install the released version of BioAge from
(<https://github.com/dayoonkwon/BioAge>) with:

``` r
install.packages("devtools")
devtools::install_github("dayoonkwon/BioAge")
```

## Example

This serves as an example of training biologial aging measures using the
NHANES 3 (1991) and NHANES 4 (1999 - 2018) dataset. It also provides
documentation for fit parameters contained in the BioAge package. The
cleaned NHANES dataset is loaded as the dataset `NHANES3` and `NHANES4`.
The original KDM bioage and phenoage values are saved as `kdm0` and
`phenoage0` as part of NHANES dataset.

``` r
library(BioAge) #topic of example
library(dplyr)
```

## Step 1: train in NHANES 3 and project in NHANES 4

I train in the NHANES 3 and project biological aging measures into the
NHANES 4 by using the `hd_nhanes`, `kdm_nhanes`, and `phenoage_nhanes`
function of the BioAge package.

``` r
#particular biomarkers
biomarkers = c("albumin","alp","lymph","mcv","lncreat","lncrp","hba1c","wbc","rdw")

#projecting HD using NHANES (seperate training for gender)
hd = hd_nhanes(biomarkers)

#projecting KDM bioage using NHANES (seperate training for gender)
kdm = kdm_nhanes(biomarkers)

#projecting phenoage uinsg NHANES
phenoage = phenoage_nhanes(biomarkers)
```
