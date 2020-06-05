# Load packages -----------------------------------------------------------
library(BioAge)
library(dplyr)



# Select biomarkers -------------------------------------------------------
biomarkers = c("albumin","alp","lymph","mcv","lncreat","lncrp","hba1c","wbc","rdw")



# Step 1: train in NHANES 3 and test in NHANES 4 --------------------------
# Homeostatic disregulation
hd = hd_nhanes(biomarkers)
hd_data = hd$data

# KDM bioage
bioage = bioage_nhanes(biomarkers)
bioage_data = bioage$data

# Phenoage
phenoage = phenoage_nhanes(biomarkers)
phenoage_data = phenoage$data



# Step 2: compare NHANES 4 to the original KDM bioage and phenoage --------
# Figure 1: correlation between bioage and age
# Merge all biological age measures together
all = merge(hd_data, bioage_data) %>% merge(., phenoage_data)

# Subset NHANES 4 dataset
nhanes = all %>% filter(wave>0 & wave<11)

# Select biological age names
agevar = c("bioage0","phenoage0","bioage","phenoage","hd","hd_log")

# Prepare labels
label = c("KDM\nBiological\nAge",
          "Levine\nPhenotypic\nAge",
          "Modified-KDM\nBiological\nAge",
          "Modified-Levine\nPhenotypic\nAge",
          "Mahalanobis\nDistance",
          "Log\nMahalanobis\nDistance")

# Plot biological age vs chronological age
plot_ba(nhanes, agevar, label)


# Figure 2: correlation between BAA and age
# Select biological age advancement (BAA) names
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

# Plot BAA vs chronological age
plot_baa(nhanes,agevar,label,axis_type)


# Table 1: survival analysis
table_surv(nhanes, agevar, time = "permth_exm", status = "mortstat", label)

# Table 2: association with current health status outcomes
table2 = table_health(nhanes,agevar,outcome = c("health","adl","lnwalk","grip_scaled"), label)
table2$table


# Table 3: association with socioeconomic variables
table3 = table_ses(nhanes,agevar,exposure = c("edu","annual_income","poverty_ratio"), label)
table3$table


# Step 3: Score new data --------------------------------------------------


