# Load packages -----------------------------------------------------------
devtools::install_github("dayoonkwon/BioAge")

library(BioAge)
library(dplyr)


# Select biomarkers -------------------------------------------------------
biomarkers = c("albumin","alp","lymph","mcv","lncreat","lncrp","hba1c","wbc","rdw")


# Step 1: train in NHANES 3 and test in NHANES 4 --------------------------
# Homeostatic disregulation
hd = hd_nhanes(biomarkers)
hd_data = hd$data
hd$fit

# KDM bioage
kdm = kdm_nhanes(biomarkers)
kdm_data = kdm$data
kdm$fit

# Phenoage
phenoage = phenoage_nhanes(biomarkers)
phenoage_data = phenoage$data
phenoage$fit


# Step 2: compare NHANES 4 to the original KDM bioage and phenoage --------
# Figure 1: correlation between bioage and age
# Merge all biological age measures together
data = merge(hd_data, kdm_data) %>% merge(., phenoage_data)

# Select biological age names
agevar = c("kdm0","phenoage0","kdm","phenoage","hd","hd_log")

# Prepare labels
label = c("KDM\nBiological\nAge",
          "Levine\nPhenotypic\nAge",
          "Modified-KDM\nBiological\nAge",
          "Modified-Levine\nPhenotypic\nAge",
          "Mahalanobis\nDistance",
          "Log\nMahalanobis\nDistance")

# Plot biological age vs chronological age
plot_ba(data, agevar, label)


# Figure 2: correlation between BAA and age
# Select biological age advancement (BAA) names
agevar = c("kdm_advance0","phenoage_advance0","kdm_advance","phenoage_advance","hd","hd_log")

# Prepare lables
# Values should be formatted for displaying along diagonal of the plot
# Names should be used to match variables and order is preserved
label = c(
  "kdm_advance0"="KDM\nBiological\nAge",
  "phenoage_advance0"="Levine\nPhenotypic\nAge",
  "kdm_advance"="Modified-KDM\nBiological\nAge",
  "phenoage_advance"="Modified-Levine\nPhenotypic\nAge",
  "hd" = "Mahalanobis\nDistance",
  "hd_log" = "Log\nMahalanobis\nDistance")

# Use variable name to define the axis type ("int" or "float")
axis_type = c(
  "kdm_advance0"="float",
  "phenoage_advance0"="float",
  "kdm_advance"="float",
  "phenoage_advance"="flot",
  "hd"="flot",
  "hd_log"="float")

# Plot BAA vs chronological age
plot_baa(data,agevar,label,axis_type)


# Table 1: survival analysis
table_surv(data, agevar, label)

# Table 2: association with current health status outcomes
table2 = table_health(data,agevar,outcome = c("health","adl","lnwalk","grip_scaled"), label)
table2$table
table2$n


# Table 3: association with socioeconomic variables
table3 = table_ses(data,agevar,exposure = c("edu","annual_income","poverty_ratio"), label)
table3$table
table3$n


# Step 3: Score new data --------------------------------------------------
# Open your own dataset and match the column names to nhanes dataset
# In this example, I use the Health and Retirement Study (HRS) as the new data
# Make sure that column names of the new data match to the NHANES data
newdata = HRS %>%
  select(hhidpn, sex, age, raracem, adls, grip, srh, lnwalk,
         albumin, alp, lymphpct, mcv, creat, lncreat, crp, lncrp, hba1c, wbc, rdw) %>%
  rename(sampleID = hhidpn,
         gender = sex,
         race = raracem,
         adl = adls,
         grip_scaled = grip,
         health = srh,
         lymph = lymphpct) %>%
  mutate(gender = ifelse(gender == "Women", 2,
                         ifelse(gender == "Men", 1, NA)),
         albumin_gL = albumin * 10,
         creat_umol = creat * 88.4017,
         lncreat_umol = log(creat_umol),
         crp = crp / 10,
         lncrp = log(crp)) %>%
  group_by(gender) %>%
  mutate_at(vars(albumin:creat,crp,hba1c:rdw),
            list(~ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE)))|
                           (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .))) %>%
  ungroup() %>%
  mutate(lncreat = ifelse(is.na(creat), NA, lncreat),
         lncrp = ifelse(is.na(crp), NA, lncrp),
         albumin_gL = ifelse(is.na(albumin), NA, albumin_gL),
         creat_umol = ifelse(is.na(creat), NA, creat_umol),
         lncreat_umol = ifelse(is.na(creat), NA, lncreat_umol))


# Train in NHANES 3 and test in HRS ---------------------------------------
# Homeostatic disregulation
#train seperately for men and women who are between thes of 20 and 30
#biomarker data within clinically acceptable distributions
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

newhd_data = rbind(hd_fem$data, hd_male$data)

# KDM bioage
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

newkdm_data = rbind(kdm_fem$data, kdm_male$data)

# Phenoage
newphenoage = phenoage_calc(data = newdata %>%
                           mutate(albumin = albumin_gL,
                                  lncreat = lncreat_umol),
                         biomarkers,
                         fit = phenoage$fit)

newphenoage_data = newphenoage$data

