
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
documentation for fit parameters contained in the `BioAge` package. The
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
function of the `BioAge` package.

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

<img src="vignettes/figure1.png" width="100%" />

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

<img src="vignettes/figure2.png" width="100%" />

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

<th style="width: 300px; font-size: .83em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

KDM Biological
Age

</th>

<th style="width: 300px; font-size: .83em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Levine Phenotypic
Age

</th>

<th style="width: 300px; font-size: .83em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified KDM Biological
Age

</th>

<th style="width: 300px; font-size: .83em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified Levine Phenotypic
Age

</th>

<th style="width: 300px; font-size: .83em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Mahalanobis
Distance

</th>

<th style="width: 300px; font-size: .83em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Log Mahalanobis
Distance

</th>

</tr>

</thead>

<tbody>

<tr>

<td colspan="7" style="width: 300px; font-size: .83em; font-weight: 900; text-align: center;">

Hazard Ratio (95%
CI)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: .83em; font-weight: 900; text-align: left;">

Full Sample

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

8234

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

27837

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

27793

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

27793

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

27793

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

27793

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.43 (1.3, 1.57)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.5 (1.46, 1.53)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.43 (1.4, 1.47)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.57 (1.53, 1.62)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.36 (1.33, 1.39)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.44 (1.39,
1.48)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: .83em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Gender

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: .83em; font-weight: 900; text-align: left;">

Men

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

4114

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

13421

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

13396

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

13396

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

13396

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

13396

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.44 (1.28, 1.62)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.48 (1.43, 1.52)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.53 (1.47, 1.58)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.57 (1.51, 1.62)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.35 (1.31, 1.4)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.41 (1.35,
1.47)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: .83em; font-weight: 900; text-align: left;">

Women

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

4120

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

14416

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

14397

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

14397

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

14397

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

14397

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.42 (1.23, 1.64)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.54 (1.48, 1.6)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.35 (1.3, 1.4)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.6 (1.54, 1.67)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.37 (1.33, 1.42)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.47 (1.4,
1.53)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: .83em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Race

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: .83em; font-weight: 900; text-align: left;">

White

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

3937

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

13958

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

13966

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

13966

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

13966

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

13966

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.53 (1.35, 1.74)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.57 (1.52, 1.62)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.53 (1.48, 1.59)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.63 (1.57, 1.69)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.46 (1.41, 1.51)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.51 (1.45,
1.57)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: .83em; font-weight: 900; text-align: left;">

Black

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1467

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

5176

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

5153

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

5153

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

5153

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

5153

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.55 (1.27, 1.88)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.42 (1.34, 1.49)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.37 (1.29, 1.46)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.5 (1.41, 1.6)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.31 (1.24, 1.39)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.41 (1.31,
1.53)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: .83em; font-weight: 900; text-align: left;">

Other

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

2830

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

8703

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

8674

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

8674

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

8674

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

8674

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.24 (1, 1.53)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.41 (1.34, 1.49)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.33 (1.25, 1.4)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.49 (1.4, 1.58)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.28 (1.22, 1.34)

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

1.35 (1.27,
1.43)

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: .83em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

People Aged 65 and
Younger

</td>

</tr>

<tr>

<td colspan="7" style="width: 300px; font-size: .83em; font-weight: 900; text-align: left;">

Aged 65 and
Younger

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; text-align: left;">

  n

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

6915

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

21252

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

21210

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

21210

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

21210

</td>

<td style="width: 300px; font-size: .83em; text-align: left;">

21210

</td>

</tr>

<tr>

<td style="width: 300px; font-size: .83em; border-bottom: 2px solid grey; text-align: left;">

  BioAge

</td>

<td style="width: 300px; font-size: .83em; border-bottom: 2px solid grey; text-align: left;">

1.45 (1.28,
1.64)

</td>

<td style="width: 300px; font-size: .83em; border-bottom: 2px solid grey; text-align: left;">

1.65 (1.58,
1.72)

</td>

<td style="width: 300px; font-size: .83em; border-bottom: 2px solid grey; text-align: left;">

1.58 (1.51,
1.65)

</td>

<td style="width: 300px; font-size: .83em; border-bottom: 2px solid grey; text-align: left;">

1.74 (1.66,
1.83)

</td>

<td style="width: 300px; font-size: .83em; border-bottom: 2px solid grey; text-align: left;">

1.41 (1.36,
1.47)

</td>

<td style="width: 300px; font-size: .83em; border-bottom: 2px solid grey; text-align: left;">

1.5 (1.43,
1.58)

</td>

</tr>

</tbody>

</table>

### Table 2: Linear regression models with current health status outcomes

The linear regression models and number of observations in “Table 2” and
“Table 3” below are saved as part of the list structure. These can be
drawn by typing `table` and `n`,
respectively.

``` r
table2 = table_health(data,agevar,outcome = c("health","adl","lnwalk","grip_scaled"), label)

#pull table
table2$table
```

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">

<thead>

<tr>

<td colspan="7" style="text-align: left;">

Table 2: Linear regression models of all biological aging measures with
current health status outcomes. After accounting for chronological age
differences, all biological aging measures were standardized to have
mean = 0, SD = 1 by gender. Original KDM Biological Age was computed in
the NHANES 2007-2010. Original Levine’s Phenotypic Age was computed in
the NHANES 1999-2010 and 2015-2018. Walk speed was measured only for
people aged 50 and older in the NHANES 1999-2002. Grip strength was only
measured in the NHANES
2011-2014.

</td>

</tr>

<tr>

<th style="border-bottom: 1px solid grey; border-top: 2px solid grey;">

</th>

<th style="width: 600px; font-size: 0.77em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

KDM Biological
Age

</th>

<th style="width: 600px; font-size: 0.77em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Levine Phenotypic
Age

</th>

<th style="width: 600px; font-size: 0.77em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified KDM Biological
Age

</th>

<th style="width: 600px; font-size: 0.77em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified Levine Phenotypic
Age

</th>

<th style="width: 600px; font-size: 0.77em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Mahalanobis
Distance

</th>

<th style="width: 600px; font-size: 0.77em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Log Mahalanobis
Distance

</th>

</tr>

</thead>

<tbody>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: center;">

b (95%
CI)

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: left;">

Full Sample

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.26 (0.24, 0.28)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.23 (0.22, 0.24)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.21 (0.2, 0.23)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.21 (0.2, 0.22)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.15, 0.17)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.15 (0.14, 0.16)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.11, 0.17)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.18 (0.16, 0.2)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.15, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.18 (0.17, 0.2)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.11 (0.1, 0.13)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.12 (0.1, 0.13)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.22 (0.19, 0.25)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.19 (0.16, 0.22)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.22 (0.19, 0.25)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.14, 0.19)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.14,
0.2)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Gender

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: left;">

Men

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.23 (0.2, 0.26)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.23 (0.22, 0.25)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.22 (0.2, 0.24)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.22 (0.2, 0.24)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.12 (0.11, 0.14)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.11 (0.09, 0.13)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.12 (0.08, 0.16)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.14, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.15, 0.19)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.14, 0.19)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.09 (0.07, 0.11)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.09 (0.07, 0.11)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.13, 0.21)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.13, 0.2)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.13, 0.21)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.1, 0.17)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.1,
0.17)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: left;">

Women

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.28 (0.25, 0.31)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.23 (0.21, 0.24)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.21 (0.2, 0.23)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.21 (0.19, 0.22)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.19 (0.18, 0.21)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.18 (0.17, 0.2)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.1, 0.19)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.2 (0.18, 0.23)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.13, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.21 (0.18, 0.23)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.12, 0.16)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.15 (0.12, 0.17)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.28 (0.23, 0.32)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.22 (0.18, 0.26)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.28 (0.23, 0.33)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.19 (0.15, 0.23)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.2 (0.16,
0.25)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Race

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: left;">

White

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.3 (0.27, 0.33)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.28 (0.27, 0.3)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.27 (0.25, 0.29)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.28 (0.26, 0.29)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.14, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.12, 0.15)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.12, 0.2)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.21 (0.19, 0.23)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.19 (0.17, 0.21)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.21 (0.19, 0.23)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.12, 0.16)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.13 (0.11, 0.16)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.25 (0.21, 0.29)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.2 (0.16, 0.24)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.26 (0.22, 0.3)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.12, 0.2)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.11,
0.18)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: left;">

Black

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.12, 0.22)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.15, 0.19)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.15, 0.19)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.15, 0.19)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.12, 0.16)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.15 (0.12, 0.17)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.08 (0, 0.16)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.1, 0.17)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.1, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.11, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.12 (0.08, 0.16)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.13 (0.09, 0.18)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.07, 0.21)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.07, 0.21)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.09, 0.24)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.07, 0.21)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.18 (0.1,
0.26)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: left;">

Other

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.15 (0.11, 0.19)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.14, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.14, 0.17)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.15 (0.13, 0.17)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.11 (0.1, 0.13)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.1 (0.08, 0.12)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.09, 0.22)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.14, 0.2)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.15 (0.12, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.14, 0.21)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.08 (0.05, 0.11)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.09 (0.06, 0.12)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.09, 0.22)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.11 (0.05, 0.16)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.14 (0.08, 0.2)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.09 (0.05, 0.14)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.1 (0.05,
0.15)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Age

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: left;">

Age 20-40

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.22 (0.18, 0.25)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.2 (0.18, 0.22)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.14, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.14, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.04 (0.02, 0.06)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.02 (0, 0.04)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.03 (-0.08, 0.14)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.12 (0.06, 0.17)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.06 (0.01, 0.11)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.09 (0.03, 0.14)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.03 (-0.02, 0.08)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.02 (-0.03,
0.07)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: left;">

Age 40-60

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.29 (0.25, 0.32)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.27 (0.25, 0.29)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.26 (0.24, 0.28)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.25 (0.23, 0.27)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.18 (0.16, 0.2)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.15, 0.19)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.19 (0.09, 0.28)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.18 (0.13, 0.22)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.11, 0.2)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.12, 0.21)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.1 (0.05, 0.14)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.11 (0.06, 0.16)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.23 (0.19, 0.28)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.2 (0.15, 0.24)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.21 (0.17, 0.26)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.11, 0.2)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.15 (0.11,
0.19)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.77em; font-weight: 900; text-align: left;">

Age 60-80

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.26 (0.22, 0.3)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.22 (0.2, 0.24)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.22 (0.2, 0.23)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.22 (0.21, 0.24)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.23 (0.21, 0.25)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.26 (0.24, 0.28)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.12 (0.09, 0.15)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.15, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.16 (0.14, 0.18)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.18 (0.16, 0.19)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.12 (0.11, 0.14)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.13 (0.11, 0.15)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.22 (0.18, 0.26)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.2 (0.16, 0.24)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.23 (0.19, 0.27)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.17 (0.14, 0.21)

</td>

<td style="width: 600px; font-size: 0.77em; text-align: left;">

0.18 (0.14,
0.21)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.77em; border-bottom: 2px solid grey; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.77em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.77em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

</tr>

</tbody>

</table>

``` r
#pull number of observations
table2$n
```

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">

<thead>

<tr>

<td colspan="7" style="text-align: left;">

Table 2.1: Sample size for linear regression models of all biological
aging measures with current health status outcomes. Original KDM
Biological Age was computed in the NHANES 2007-2010. Original Levine’s
Phenotypic Age was computed in the NHANES 1999-2010 and 2015-2018. Walk
speed was measured only for people aged 50 and older in the NHANES
1999-2002. Grip strength was only measured in the NHANES
2011-2014.

</td>

</tr>

<tr>

<th style="border-bottom: 1px solid grey; border-top: 2px solid grey;">

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

KDM Biological
Age

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Levine Phenotypic
Age

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified KDM Biological
Age

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified Levine Phenotypic
Age

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Mahalanobis
Distance

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Log Mahalanobis
Distance

</th>

</tr>

</thead>

<tbody>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: center;">

n

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Full
Sample

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7886

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

31077

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

31029

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

31029

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

31029

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

31029

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2812

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

14005

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

14011

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

14011

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

14011

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

14011

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3607

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3604

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3604

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3604

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3604

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Gender

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Men

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3974

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

15213

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

15185

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

15185

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

15185

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

15185

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1407

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6921

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6922

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6922

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6922

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6922

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1795

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1801

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1801

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1801

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1801

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Women

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3912

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

15864

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

15844

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

15844

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

15844

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

15844

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1405

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7084

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7089

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7089

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7089

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7089

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1812

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1803

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1803

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1803

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1803

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Race

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

White

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3802

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

14634

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

14644

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

14644

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

14644

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

14644

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1537

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7464

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7473

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7473

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7473

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7473

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2122

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2126

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2126

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2126

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2126

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Black

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1397

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

5938

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

5903

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

5903

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

5903

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

5903

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

501

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2486

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2484

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2484

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2484

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2484

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

547

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

547

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

547

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

547

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

547

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Other

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2687

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10505

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10482

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10482

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10482

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10482

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

774

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

4055

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

4054

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

4054

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

4054

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

4054

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

938

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

931

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

931

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

931

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

931

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Age

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Age
20-40

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2864

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10445

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10425

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10425

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10425

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10425

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

298

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1337

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1337

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1337

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1337

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1337

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Age
40-60

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2830

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9866

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9838

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9838

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9838

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9838

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

497

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2180

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2180

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2180

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2180

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2180

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1017

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1010

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1010

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1010

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1010

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Age
60-80

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  health

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2192

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9916

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9915

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9915

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9915

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9915

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  adl

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2017

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9622

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9626

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9626

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9626

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

9626

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  lnwalk

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2133

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2135

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2135

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2135

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2135

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

  grip\_scaled

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

\-

</td>

</tr>

</tbody>

</table>

### Table 3: Linear regresion models with socioeconomic variables

``` r
table3 = table_ses(data,agevar,exposure = c("edu","annual_income","poverty_ratio"), label)

#pull table
table3$table
```

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">

<thead>

<tr>

<td colspan="7" style="text-align: left;">

Table 3: Linear regression models of all biological aging measures with
socioeconomic variables. After accounting for chronological age
differences, all biological aging measures were standardized to have
mean = 0, SD = 1 by gender. Original KDM Biological Age was computed in
the NHANES 2007-2010. Original Levine’s Phenotypic Age was computed in
the NHANES 1999-2010 and
2015-2018.

</td>

</tr>

<tr>

<th style="border-bottom: 1px solid grey; border-top: 2px solid grey;">

</th>

<th style="width: 600px; font-size: 0.69em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

KDM Biological
Age

</th>

<th style="width: 600px; font-size: 0.69em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Levine Phenotypic
Age

</th>

<th style="width: 600px; font-size: 0.69em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified KDM Biological
Age

</th>

<th style="width: 600px; font-size: 0.69em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified Levine Phenotypic
Age

</th>

<th style="width: 600px; font-size: 0.69em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Mahalanobis
Distance

</th>

<th style="width: 600px; font-size: 0.69em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Log Mahalanobis
Distance

</th>

</tr>

</thead>

<tbody>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: center;">

b (95%
CI)

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: left;">

Full Sample

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.2 (-0.22, -0.18)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.09, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.09, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.08, -0.06)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.08, -0.06)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.08, -0.06)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.17 (-0.19, -0.15)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.11 (-0.12, -0.1)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.11 (-0.12, -0.1)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.12 (-0.13, -0.11)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.1, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.1, -0.08)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.19 (-0.21, -0.16)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.14 (-0.15, -0.13)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.12 (-0.13, -0.11)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.14 (-0.15, -0.13)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.11, -0.09)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.11,
-0.09)

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Gender

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: left;">

Men

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.22 (-0.25, -0.19)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.1, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.11, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.1, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.04 (-0.05, -0.03)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.03 (-0.05, -0.02)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.15 (-0.18, -0.12)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.11, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.11, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.11 (-0.12, -0.09)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.08, -0.05)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.09, -0.06)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.18 (-0.21, -0.15)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.12 (-0.14, -0.11)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.12 (-0.13, -0.1)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.13 (-0.14, -0.11)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.09, -0.06)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.09,
-0.06)

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: left;">

Women

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.18 (-0.21, -0.15)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.11, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.1, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.09, -0.06)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.11, -0.09)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.11, -0.08)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.18 (-0.21, -0.15)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.13 (-0.14, -0.11)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.12 (-0.13, -0.11)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.13 (-0.14, -0.11)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.12, -0.09)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.12, -0.09)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.2 (-0.23, -0.17)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.16 (-0.18, -0.15)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.12 (-0.13, -0.11)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.15 (-0.16, -0.13)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.13 (-0.14, -0.11)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.13 (-0.14,
-0.11)

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Race

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: left;">

White

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.25 (-0.28, -0.22)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.15 (-0.16, -0.13)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.14 (-0.16, -0.13)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.16 (-0.17, -0.14)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.06 (-0.08, -0.05)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.06 (-0.08, -0.05)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.18 (-0.21, -0.16)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.15 (-0.16, -0.13)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.13 (-0.15, -0.12)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.16 (-0.18, -0.15)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.1, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.1, -0.07)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.19 (-0.22, -0.16)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.18 (-0.19, -0.16)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.15 (-0.17, -0.14)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.19 (-0.2, -0.17)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.1, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.1,
-0.07)

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: left;">

Black

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.11 (-0.16, -0.06)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.04 (-0.07, -0.01)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.03 (-0.06, 0)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.04 (-0.07, -0.01)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.04 (-0.07, -0.02)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.03 (-0.06, -0.01)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.11 (-0.17, -0.06)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.12, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.1, -0.05)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.12, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.09, -0.04)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.06 (-0.08, -0.03)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.11 (-0.16, -0.05)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.13 (-0.16, -0.1)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.12, -0.06)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.14 (-0.16, -0.11)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.13, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.11,
-0.06)

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: left;">

Other

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.14, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.03 (-0.05, -0.01)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.04 (-0.06, -0.02)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.02 (-0.03, 0)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.04 (-0.05, -0.02)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.03 (-0.05, -0.02)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.13, -0.05)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.05 (-0.06, -0.03)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.06 (-0.07, -0.04)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.05 (-0.07, -0.03)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.06 (-0.08, -0.04)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.06 (-0.08, -0.04)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.12 (-0.15, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.09, -0.06)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.06 (-0.08, -0.04)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.09, -0.05)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.09, -0.05)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.09,
-0.05)

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Age

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: left;">

Age 20-40

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.15 (-0.18, -0.12)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.11, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.08, -0.05)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.1, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.03 (-0.05, -0.02)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.04 (-0.05, -0.02)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.12, -0.06)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.08, -0.05)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.05 (-0.07, -0.04)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.09, -0.05)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.03 (-0.04, -0.01)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.03 (-0.05, -0.01)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.13 (-0.17, -0.1)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.11 (-0.12, -0.09)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.09, -0.06)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.11, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.04 (-0.05, -0.02)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.04 (-0.06,
-0.02)

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: left;">

Age 40-60

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.21 (-0.25, -0.18)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.12, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.11, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.1, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.07 (-0.09, -0.05)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.06 (-0.08, -0.05)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.19 (-0.23, -0.16)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.16 (-0.18, -0.14)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.16 (-0.17, -0.14)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.17 (-0.19, -0.15)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.11 (-0.13, -0.09)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.11 (-0.13, -0.09)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.2 (-0.23, -0.16)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.17 (-0.19, -0.16)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.15 (-0.17, -0.13)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.17 (-0.19, -0.15)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.12 (-0.14, -0.1)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.12 (-0.14,
-0.1)

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.69em; font-weight: 900; text-align: left;">

Age 60-80

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.24 (-0.29, -0.2)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.1, -0.06)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.11, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.06 (-0.08, -0.04)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.11, -0.07)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.08 (-0.1, -0.06)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.24 (-0.29, -0.19)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.11 (-0.14, -0.09)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.13 (-0.15, -0.1)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.12, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.1 (-0.13, -0.08)

</td>

<td style="width: 600px; font-size: 0.69em; text-align: left;">

\-0.09 (-0.11,
-0.07)

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.69em; border-bottom: 2px solid grey; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.69em; border-bottom: 2px solid grey; text-align: left;">

\-0.25 (-0.3,
-0.21)

</td>

<td style="width: 600px; font-size: 0.69em; border-bottom: 2px solid grey; text-align: left;">

\-0.15 (-0.17,
-0.13)

</td>

<td style="width: 600px; font-size: 0.69em; border-bottom: 2px solid grey; text-align: left;">

\-0.16 (-0.18,
-0.13)

</td>

<td style="width: 600px; font-size: 0.69em; border-bottom: 2px solid grey; text-align: left;">

\-0.14 (-0.16,
-0.11)

</td>

<td style="width: 600px; font-size: 0.69em; border-bottom: 2px solid grey; text-align: left;">

\-0.14 (-0.16,
-0.12)

</td>

<td style="width: 600px; font-size: 0.69em; border-bottom: 2px solid grey; text-align: left;">

\-0.13 (-0.15, -0.11)

</td>

</tr>

</tbody>

</table>

``` r
#pull number of observations
table3$n
```

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">

<thead>

<tr>

<td colspan="7" style="text-align: left;">

Table 3.1: Sample size for linear regression models of all biological
aging measures with socioeconomic variables. Original KDM Biological Age
was computed in the NHANES 2007-2010. Original Levine’s Phenotypic Age
was computed in the NHANES 1999-2010 and
2015-2018.

</td>

</tr>

<tr>

<th style="border-bottom: 1px solid grey; border-top: 2px solid grey;">

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

KDM Biological
Age

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Levine Phenotypic
Age

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified KDM Biological
Age

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Modified Levine Phenotypic
Age

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Mahalanobis
Distance

</th>

<th style="width: 600px; font-size: 0.8em; border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">

Log Mahalanobis
Distance

</th>

</tr>

</thead>

<tbody>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: center;">

n

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Full
Sample

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

8234

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

37526

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

37475

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

37475

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

37475

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

37475

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7553

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

34245

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

34190

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

34190

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

34190

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

34190

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7553

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

34245

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

34190

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

34190

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

34190

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

34190

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Gender

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Men

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

4116

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

18072

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

18046

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

18046

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

18046

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

18046

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3785

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16563

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16535

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16535

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16535

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16535

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3785

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16563

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16535

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16535

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16535

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16535

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Women

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

4118

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

19454

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

19429

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

19429

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

19429

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

19429

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3768

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17682

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17655

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17655

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17655

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17655

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3768

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17682

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17655

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17655

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17655

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17655

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Race

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

White

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3937

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17297

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17309

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17309

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17309

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

17309

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3728

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16194

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16206

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16206

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16206

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16206

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3728

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16194

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16206

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16206

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16206

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

16206

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Black

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1468

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7218

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7186

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7186

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7186

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

7186

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1336

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6525

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6495

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6495

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6495

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6495

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

1336

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6525

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6495

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6495

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6495

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

6495

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Other

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2829

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

13011

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

12980

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

12980

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

12980

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

12980

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2489

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11526

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11489

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11489

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11489

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11489

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2489

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11526

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11489

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11489

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11489

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11489

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: center; border-top: 1px solid #BEBEBE;">

Stratified by
Age

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Age
20-40

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

3014

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

12944

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

12921

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

12921

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

12921

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

12921

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2791

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11947

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11923

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11923

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11923

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11923

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2791

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11947

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11923

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11923

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11923

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11923

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Age
40-60

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2961

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11798

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11765

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11765

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11765

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11765

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2714

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10827

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10794

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10794

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10794

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10794

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2714

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10827

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10794

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10794

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10794

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10794

</td>

</tr>

<tr>

<td colspan="7" style="width: 600px; font-size: 0.8em; font-weight: 900; text-align: left;">

Age
60-80

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  edu

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2259

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11641

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11643

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11643

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11643

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

11643

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

  annual\_income

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

2048

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10447

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10445

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10445

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10445

</td>

<td style="width: 600px; font-size: 0.8em; text-align: left;">

10445

</td>

</tr>

<tr>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

  poverty\_ratio

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

2048

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

10447

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

10445

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

10445

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

10445

</td>

<td style="width: 600px; font-size: 0.8em; border-bottom: 2px solid grey; text-align: left;">

10445

</td>

</tr>

</tbody>

</table>
