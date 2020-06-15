
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
# install.packages("devtools")
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
library(dplyr)
library(BioAge) #topic of vignette
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

## Step 2: compare NHANES 4 to the original KDM bioage and phenoage

The projected data and estimated model above are saved as part of the
list structure. These can be drawn by typing `data` and `fit`,
respectively.

``` r
#pull the full dataset
data = merge(hd$data, kdm$data) %>% merge(., phenoage$data)
```

### Figure1: Chronological age vs biological aging measures

``` r
#select biological age variables
agevar = c("kdm0","phenoage0","kdm","phenoage","hd","hd_log")

#prepare labels
label = c("KDM\nBiological Age",
          "Levine\nPhenotypic Age",
          "Modified-KDM\nBiological Age",
          "Modified-Levine\nPhenotypic Age",
          "Mahalanobis\nDistance",
          "Log\nMahalanobis\nDistance")

#plot age vs bioage
plot_ba(data, agevar, label)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

### Figure2: Corplot for biological aging measures

``` r
#select biological age advancement (BAA) variables
agevar = c("kdm_advance0","phenoage_advance0","kdm_advance","phenoage_advance","hd","hd_log")

#prepare lables
#values should be formatted for displaying along diagonal of the plot
#names should be used to match variables and order is preserved
label = c(
  "kdm_advance0"="KDM\nBiological\nAge",
  "phenoage_advance0"="Levine\nPhenotypic\nAge",
  "kdm_advance"="Modified\nKDM\nBiological\nAge",
  "phenoage_advance"="Modified\nLevine\nPhenotypic\nAge",
  "hd" = "Mahalanobis\nDistance",
  "hd_log" = "Log\nMahalanobis\nDistance")

#use variable name to define the axis type ("int" or "float")
axis_type = c(
  "kdm_advance0"="float",
  "phenoage_advance0"="float",
  "kdm_advance"="float",
  "phenoage_advance"="flot",
  "hd"="flot",
  "hd_log"="float")

#plot BAA corplot
plot_baa(data,agevar,label,axis_type)
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

### Table 1: Mortality models with all biological aging measures

``` r
table_surv(data, agevar, label)
```

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">

<thead>

<tr>

<td colspan="7" style="text-align: left;">

Table 1: Mortality models with all biological aging measures. After
accounting for chronological age differences, all biological aging
measures were standardized to have mean = 0, SD = 1 by gender. Original
KDM Biological Age was computed in the NHANES 2007-2010. Original
Levine’s Phenotypic Age was computed in the NHANES 1999-2010 and
2015-2018.

</td>

</tr>

<tr>

<th style="border-bottom: 1px solid grey; border-top: 2px solid grey;">

</th>

<th style="width: 300px; font-size: 1em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

KDM Biological
Age

</th>

<th style="width: 300px; font-size: 1em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Levine Phenotypic
Age

</th>

<th style="width: 300px; font-size: 1em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified KDM Biological
Age

</th>

<th style="width: 300px; font-size: 1em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified Levine Phenotypic
Age

</th>

<th style="width: 300px; font-size: 1em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Mahalanobis
Distance

</th>

<th style="width: 300px; font-size: 1em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Log Mahalanobis
Distance

</th>

</tr>

</thead>

<tbody>

<tr>

<td colspan="7" style="width: 300px; font-size: 1em; font-weight: 900; text-align: center;">

Hazard Ratio (95%
CI)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: 1em; font-weight: 900; text-align: left;">

Full Sample

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

8234

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

27837

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

27793

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

27793

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

27793

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

27793

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.43 (1.3, 1.57)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.5 (1.46, 1.53)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.43 (1.4, 1.47)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.57 (1.53, 1.62)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.36 (1.33, 1.39)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.44 (1.39,
1.48)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: 1em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Gender

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: 1em; font-weight: 900; text-align: left;">

Men

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

4114

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

13421

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

13396

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

13396

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

13396

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

13396

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.44 (1.28, 1.62)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.48 (1.43, 1.52)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.53 (1.47, 1.58)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.57 (1.51, 1.62)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.35 (1.31, 1.4)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.41 (1.35,
1.47)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: 1em; font-weight: 900; text-align: left;">

Women

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

4120

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

14416

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

14397

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

14397

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

14397

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

14397

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.42 (1.23, 1.64)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.54 (1.48, 1.6)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.35 (1.3, 1.4)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.6 (1.54, 1.67)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.37 (1.33, 1.42)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.47 (1.4,
1.53)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: 1em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Race

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: 1em; font-weight: 900; text-align: left;">

White

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

3937

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

13958

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

13966

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

13966

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

13966

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

13966

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.53 (1.35, 1.74)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.57 (1.52, 1.62)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.53 (1.48, 1.59)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.63 (1.57, 1.69)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.46 (1.41, 1.51)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.51 (1.45,
1.57)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: 1em; font-weight: 900; text-align: left;">

Black

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1467

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

5176

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

5153

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

5153

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

5153

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

5153

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.55 (1.27, 1.88)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.42 (1.34, 1.49)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.37 (1.29, 1.46)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.5 (1.41, 1.6)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.31 (1.24, 1.39)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.41 (1.31,
1.53)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: 1em; font-weight: 900; text-align: left;">

Other

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

2830

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

8703

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

8674

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

8674

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

8674

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

8674

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.24 (1, 1.53)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.41 (1.34, 1.49)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.33 (1.25, 1.4)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.49 (1.4, 1.58)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.28 (1.22, 1.34)

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

1.35 (1.27,
1.43)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: 1em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

People Aged 65 and
Younger

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: 1em; font-weight: 900; text-align: left;">

Aged 65 and
Younger

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

6915

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

21252

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

21210

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

21210

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

21210

</td>

<td style="width: 300px; font-size: 1em; text-align: left;">

21210

</td>

</tr>

<tr>

<td style="width: 300px; font-size: 1em; border-bottom: 2px solid grey; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: 1em; border-bottom: 2px solid grey; text-align: left;">

1.45 (1.28,
1.64)

</td>

<td style="width: 300px; font-size: 1em; border-bottom: 2px solid grey; text-align: left;">

1.65 (1.58,
1.72)

</td>

<td style="width: 300px; font-size: 1em; border-bottom: 2px solid grey; text-align: left;">

1.58 (1.51,
1.65)

</td>

<td style="width: 300px; font-size: 1em; border-bottom: 2px solid grey; text-align: left;">

1.74 (1.66,
1.83)

</td>

<td style="width: 300px; font-size: 1em; border-bottom: 2px solid grey; text-align: left;">

1.41 (1.36,
1.47)

</td>

<td style="width: 300px; font-size: 1em; border-bottom: 2px solid grey; text-align: left;">

1.5 (1.43, 1.58)

</td>

</tr>

</tbody>

</table>
