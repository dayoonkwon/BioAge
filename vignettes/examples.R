library(BioAge)
library(dplyr)

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

# F1: correlation between bioage and age ----------------------------------
all <- merge(hd_data,bioage_data) %>% merge(.,phenoage_data)
nhanes <- all %>% filter(wave>0 & wave<11)
agevar = c("bioage0","phenoage0","bioage","phenoage","hd","hd_log")
plot_ba(nhanes,agevar)

# F2: correlation between BAA and age -------------------------------------
agevar = c("bioage_advance0","phenoage_advance0","bioage_advance","phenoage_advance","hd","hd_log")

# Prepare lables
# Values should be formatted for displaying along diagonal of the plot
# Names should be used to match variables and order is preserved
label = c(
  "bioage_advance0"="KDM\nBiological\nAge",
  "phenoage_advance0"="Levine\nPhenotypic\nAge",
  "bioage_advance"="Modified-KDM\nBiological\nAge",
  "phenoage_advance"="Modified-Levine\nPhenotypic\nAge",
  "hd" = "Mahalanobis\nDistance",
  "hd_log" = "Log\nMahalanobis\nDistance")

# Use variable name to define the axis type ("int" or "float")
axis_type = c(
  "bioage_advance0"="float",
  "phenoage_advance0"="float",
  "bioage_advance"="float",
  "phenoage_advance"="flot",
  "hd"="flot",
  "hd_log"="float")

plot_baa(nhanes,agevar,label,axis_type)

# Table 1: survival analysis ----------------------------------------------
table_surv(nhanes, agevar, time = "permth_exm", status = "mortstat")

# Table 2: association with current health status outcomes  ---------------
table_health(nhanes,agevar,outcome = c("health","adl","lnwalk","grip_scaled"))

# Table 3: association with socioeconomic variables -----------------------
table_ses(nhanes,agevar,exposure = c("edu","annual_income","poverty_ratio"))
