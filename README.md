
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
NHANES III (1988 - 1994) and testing in NHANES IV (1999 - 2018) dataset.
It also provides documentation for fit parameters contained in the
`BioAge` package. The cleaned NHANES dataset is loaded as the dataset
`NHANES3` and `NHANES4`. The original KDM bioage and phenoage values are
saved as `kdm0` and `phenoage0` as part of NHANES dataset.

``` r
library(BioAge) #topic of example
library(dplyr)
```

## Step 1: train algorithms in NHANES III and project biological aging measures in NHANES IV

I train in the NHANES III and project biological aging measures into the
NHANES IV by using the `hd_nhanes`, `kdm_nhanes`, and `phenoage_nhanes`
function of the `BioAge` package.

``` r
#specify bioamarkers included in the algorithms 
biomarkers = c("albumin","alp","lymph","mcv","lncreat","lncrp","hba1c","wbc","rdw")

#HD using NHANES (separate training for men and women)
hd = hd_nhanes(biomarkers)

#KDM bioage using NHANES (separate training for men and women)
kdm = kdm_nhanes(biomarkers)

#phenoage uinsg NHANES
phenoage = phenoage_nhanes(biomarkers)
```

## Step 2: compare original KDM bioage and phenoage algorithms with algorithms composed with new biomarker set

The projected data and estimated models are saved as part of the list
structure. The dataset can be drawn by typing `data`. The model can be
drawn by typing `fit`.

``` r
#assemble NHANES IV dataset with projected biological aging measures for analysis
data = merge(hd$data, kdm$data) %>% merge(., phenoage$data)
```

### Figure1. Association of biological aging measures with chronological age in NAHNES IV dataset

In the figure below, the graphs titled “KDM Biological Age” and “Levine
Phenotypic Age” show measures based on the original biomarker sets
published in Levine 2013 J Geron A and Levine et al. 2018 AGING. The
remaining graphs shows the new measures computed with the biomarker set
specified within this code.

``` r
#select biological age variables
agevar = c("kdm0","phenoage0","kdm","phenoage","hd","hd_log")

#prepare labels
label = c("KDM\nBiological Age",
          "Levine\nPhenotypic Age",
          "Modified-KDM\nBiological Age",
          "Modified-Levine\nPhenotypic Age",
          "Homeostatic\nDysregulation",
          "Log\nHomeostatic\nDysregulation")

#plot age vs bioage
plot_ba(data, agevar, label)
```

<img src="vignettes/figure1.png" width="100%" />

### Figure2. Correlations among biological aging measures

The figure plots associations among the different biological aging
measures. Cells below the diagonal show scatter plots of the measures
listed above the cell (x-axis) and to the right (y-axis). Cells above
the diagonal show the Pearson correlations for the measures listed below
the cell and to the left. For this analysis, KDM Biological Age and
Levine Phenotypic Age measures are differenced from chronological age
(i.e. plotted values = BA-CA).

``` r
#select biological age variables
agevar = c("kdm_advance0","phenoage_advance0","kdm_advance","phenoage_advance","hd","hd_log")

#prepare lables
#values should be formatted for displaying along diagonal of the plot
#names should be used to match variables and order is preserved
label = c(
  "kdm_advance0"="KDM\nBiological Age\nAdvancement",
  "phenoage_advance0"="Levine\nPhenotypic Age\nAdvancement",
  "kdm_advance"="Modified-KDM\nBiological Age\nAdvancement",
  "phenoage_advance"="Modified-Levine\nPhenotypic Age\nAdvancement",
  "hd" = "Homeostatic\nDysregulation",
  "hd_log" = "Log\nHomeostatic\nDysregulation")

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

### Table 1. Associations of biological aging measures with mortality

``` r
table_surv(data, agevar, label)
```

<img src="vignettes/table1.png" width="100%" />

### Table 2. Associations of biological aging measures with healthspan-related characteristics

The linear regression models and sample sizes in “Table 2” and “Table 3”
below are saved as part of the list structure. Regression model can be
drawn by typing `table`. Sample size can be drawn by typing `n`.

``` r
table2 = table_health(data,agevar,outcome = c("health","adl","lnwalk","grip_scaled"), label)

#pull table
table2$table
```

<img src="vignettes/table2.png" width="100%" />

``` r
#pull number of observations
table2$n
```

<img src="vignettes/table2.1.png" width="100%" />

### Table 3. Associations of socioeconomic circumstances measures with measures of biological aging

``` r
table3 = table_ses(data,agevar,exposure = c("edu","annual_income","poverty_ratio"), label)

#pull table
table3$table
```

<img src="vignettes/table3.png" width="100%" />

``` r
#pull number of observations
table3$n
```

<img src="vignettes/table3.1.png" width="100%" />

## Step 3: Project biological aging measures onto new data

In this example, the projection dataset is the 2016 Venous Blood Study
dataset from the US Health and Retirement Study (data are not included
in the package but are available from the HRS). For this analysis, HRS
data were previously cleaned and units of measure and variable names
were harmonized to match the NHANES data included with the package. All
algorithms were trained using the NHANES III data and projected into the
HRS using the `hd_calc`, `kdm_calc`, and `phenoage_calc` functions of
the `BioAge` package.

``` r
#The HRS dataset is loaded from my local drive that has previously been downloaded and cleaned
newdata = HRS %>%
  select(hhidpn, sex, age, raracem, albumin, alp, lymphpct, mcv, creat, lncreat, crp, lncrp, hba1c, wbc, rdw, glucose) %>%
  rename(sampleID = hhidpn,
         gender = sex,
         race = raracem,
         lymph = lymphpct) %>%
  mutate(gender = ifelse(gender == "Women", 2,
                         ifelse(gender == "Men", 1, NA)),
         albumin_gL = albumin * 10,
         creat_umol = creat * 88.4017,
         lncreat_umol = log(creat_umol),
         crp = crp / 10,
         lncrp = log(crp),
         glucose_mmol = glucose*0.0555) %>%
  group_by(gender) %>%
  mutate_at(vars(albumin:creat,crp,hba1c:glucose),
            list(~ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE)))|
                           (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .))) %>%
  ungroup() %>%
  mutate(lncreat = ifelse(is.na(creat), NA, lncreat),
         lncrp = ifelse(is.na(crp), NA, lncrp),
         albumin_gL = ifelse(is.na(albumin), NA, albumin_gL),
         creat_umol = ifelse(is.na(creat), NA, creat_umol),
         lncreat_umol = ifelse(is.na(creat), NA, lncreat_umol),
         glucose_mmol = ifelse(is.na(glucose), NA, glucose_mmol))
```

### Projecting HD into the HRS using NHANES III

For HD, the constructed varialbe is based on a malhanobis distance
statistic, which is theoretically the distance between observations and
a hypothetically healthy, young cohort. In this example, I train
separately for men and women who are between the ages of 20 and 30 and
not pregnant, and have observe biomarker data within clinically
accpetable distributions.

``` r
#projecting HD into the HRS using NHANES III (seperate training for gender)
hd_fem = hd_calc(data = newdata %>%
                   filter(gender == 2),
                 reference = NHANES3 %>%
                   filter(gender == 2 & age >= 20 & age <= 30 & pregnant == 0) %>%
                   mutate(albumin = ifelse(albumin >= 3.5 & albumin <= 5, albumin, NA),
                          alp = ifelse(alp >= 37 & alp <= 98, alp, NA),
                          lymph = ifelse(lymph >= 20 & lymph <= 40, lymph, NA),
                          mcv = ifelse(mcv >= 78 & mcv <= 101, mcv, NA),
                          creat = ifelse(creat >= 0.6 & creat <= 1.1, creat, NA),
                          lncreat = ifelse(is.na(creat), NA, lncreat),
                          crp = ifelse(crp < 2, crp, NA),
                          lncrp = ifelse(is.na(crp), NA, lncrp),
                          hba1c = ifelse(hba1c >= 4 & hba1c <= 5.6, hba1c, NA),
                          wbc = ifelse(wbc >= 4.5 & wbc <= 11, wbc, NA),
                          rdw = ifelse(rdw >= 11.5 & rdw <= 14.5, rdw, NA)),
                 biomarkers)

hd_male = hd_calc(data = newdata %>%
                   filter(gender == 1),
                 reference = NHANES3 %>%
                   filter(gender == 1 & age >= 20 & age <= 30 & pregnant == 0) %>%
                   mutate(albumin = ifelse(albumin >= 3.5 & albumin <= 5, albumin, NA),
                          alp = ifelse(alp >= 45 & alp <= 115, alp, NA),
                          lymph = ifelse(lymph >= 20 & lymph <= 40, lymph, NA),
                          mcv = ifelse(mcv >= 82 & mcv <= 102, mcv, NA),
                          creat = ifelse(creat >= 0.8 & creat <= 1.3, creat, NA),
                          lncreat = ifelse(is.na(creat), NA, lncreat),
                          crp = ifelse(crp < 2, crp, NA),
                          lncrp = ifelse(is.na(crp), NA, lncrp),
                          hba1c = ifelse(hba1c >= 4 & hba1c <= 5.6, hba1c, NA),
                          wbc = ifelse(wbc >= 4.5 & wbc <= 11, wbc, NA),
                          rdw = ifelse(rdw >= 11.5 & rdw <= 14.5, rdw, NA)),
                 biomarkers)

#pull the HD dataset
hd_data = rbind(hd_fem$data, hd_male$data)
```

### Projecting KDM bioage into the HRS using NHANES III

Having estimated biological aging models using NHANES III in “Step 1”, I
can project KDM bioage and phenoage into the HRS data by running
`kdm_calc` and `phenoage_calc` and supplying a `fit` argument.

``` r
#projecting KDM bioage into the HRS using NHANES III (seperate training for gender)
kdm_fem = kdm_calc(data = newdata %>%
                     filter (gender ==2),
                   biomarkers,
                   fit = kdm$fit$female,
                   s_ba2 = kdm$fit$female$s_b2)

kdm_male = kdm_calc(data = newdata %>%
                     filter (gender ==1),
                   biomarkers,
                   fit = kdm$fit$male,
                   s_ba2 = kdm$fit$male$s_b2)

#pull the KDM dataset
kdm_data = rbind(kdm_fem$data, kdm_male$data)
```

### Projecting phenoage into the HRS using NHANES III

``` r
phenoage_hrs = phenoage_calc(data = newdata %>%
                           mutate(albumin = albumin_gL,
                                  lncreat = lncreat_umol),
                         biomarkers,
                         fit = phenoage$fit,
                         orig = TRUE) #this calculate original phenoage 

phenoage_data = phenoage_hrs$data

#pull the full dataset
newdata = left_join(newdata, hd_data[, c("sampleID", "hd", "hd_log")], by = "sampleID") %>%
  left_join(., kdm_data[, c("sampleID", "kdm", "kdm_advance")], by = "sampleID") %>%
  left_join(., phenoage_data[, c("sampleID","phenoage0","phenoage_advance0",
                                 "phenoage","phenoage_advance")], by = "sampleID") 
```

### Summary statistics of calculated biological aging measures for the HRS

``` r
summary(newdata %>% select(phenoage0, kdm, phenoage, hd, hd_log))
#>    phenoage0           kdm            phenoage            hd       
#>  Min.   : 12.69   Min.   : 22.19   Min.   : 13.54   Min.   : 2.68  
#>  1st Qu.: 56.33   1st Qu.: 65.04   1st Qu.: 57.25   1st Qu.: 5.06  
#>  Median : 65.34   Median : 74.83   Median : 65.67   Median : 5.62  
#>  Mean   : 66.62   Mean   : 75.10   Mean   : 66.83   Mean   : 5.72  
#>  3rd Qu.: 75.93   3rd Qu.: 84.76   3rd Qu.: 75.72   3rd Qu.: 6.22  
#>  Max.   :123.40   Max.   :172.49   Max.   :112.85   Max.   :12.07  
#>  NA's   :33308    NA's   :33308    NA's   :33308    NA's   :33308  
#>      hd_log     
#>  Min.   :10.59  
#>  1st Qu.:14.36  
#>  Median :15.63  
#>  Mean   :15.48  
#>  3rd Qu.:16.53  
#>  Max.   :21.05  
#>  NA's   :33308
```
