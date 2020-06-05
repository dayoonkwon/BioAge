surv_res = function (dat, time, status, agevar, covar) {

  covars = paste(covar, collapse = "+")

  cox = list()

  for (i in agevar) {

    form = formula(paste("survival::Surv(", time, ",", status, ")~", i, "+", covars, sep = ""))
    cox[[i]] = survival::coxph(form, data = dat)

  }; rm(i)

  res = lapply(cox,summary)

  table = as.data.frame(lapply(res, function(x)paste(round(x$conf.int[1,1],3), " (",round(x$conf.int[1,3],3),", ",round(x$conf.int[1,4],3),")",sep="")))
  table$sample = "BioAge"

  n = as.data.frame(lapply(res,function(x)x$n))
  n$sample = "n"

  table = rbind(n,table)

  return(table)

}

#' Mortality validation for biological age measures, adjusting for chronological age and gender and stratified by gender, race, and age
#'
#' @title table_surv
#' @description Mortality validation for biological aging measures
#' @param data The dataset for mortality table
#' @param agevar A character vector indicating the names of the interested biological aging measures
#' @param time A character vector (length=1) indicating the name of the variable for survival time
#' @param status A character vector (length=1) indicating the name of the variable for survival status
#' @param label A character vector indicating the labels of the biological aging measures
#' @note Chronological age, gender, and race/ethnicity variables need to be named "age", "gender", and "race"
#' @examples
#' table1 = table_surv(nhanes,
#'                     agevar = c("bioage_advance0","phenoage_advance0",
#'                                "bioage_advance","phenoage_advance",
#'                                "hd","hd_log"),
#'                     time = "permth_exm",
#'                     status = "mortstat",
#'                     label = c("KDM\nBiological\nAge",
#'                               "Levine\nPhenotypic\nAge",
#'                               "Modified-KDM\nBiological\nAge",
#'                               "Modified-Levine\nPhenotypic\nAge",
#'                               "Mahalanobis\nDistance",
#'                               "Log\nMahalanobis\nDistance"))
#'
#' table1
#'
#' @export
#' @import dplyr
#' @importFrom survival Surv
#' @importForm survival coxph
#' @importFrom htmlTable htmlTable

table_surv = function (data, agevar, time, status, label) {

  dat = nhanes %>%
    group_by(gender) %>%
    mutate_at(vars(all_of(agevar)), list(~scale(.))) %>%
    ungroup() %>%
    mutate(gender = as.factor(gender),
           age_cat = ifelse(age<=65, "yes", "no"))

  #full sample
  table1 = surv_res(dat, time, status, agevar, covar = c("age", "gender"))

  #gender stratification
  dat_gender = split(dat, dat$gender)
  table2 = lapply(dat_gender, function(x) surv_res(x, time, status, agevar, covar = "age"))
  table2 = do.call("rbind", table2)

  #race stratification
  dat_race = split(dat, dat$race)
  table3 = lapply(dat_race, function(x) surv_res(x, time, status, agevar, covar = c("age","gender")))
  table3 = do.call("rbind", table3)

  #age stratification
  dat_age = split(dat, dat$age_cat)
  table4 = surv_res(dat_age$yes, time, status, agevar, covar = c("age", "gender"))

  #combine tables
  table = rbind(table1,table2,table3,table4) %>%
    select(sample, everything())

  colnames(table) = c("sample",label)

  #make final table
  htmlTable::htmlTable(table[,-1],
                       rnames = table$sample,
                       align = "llllll",
                       rgroup = c("Full Sample", "Men", "Women", "White", "Black", "Other", "Aged 65 and Younger"),
                       n.rgroup = c(2,2,2,2,2,2,2),
                       tspanner = c("Hazard Ratio (95% CI)",
                                    "Stratified by Gender",
                                    "Stratified by Race",
                                    "People Aged 65 and Younger"),
                       n.tspanner = c(2,4,6,2),
                       cnames = colnames(table),
                       css.tspanner = "font-weight: 900; text-align: center;",
                       css.cell = c("width: 200px", "width: 250px", "width: 250px", "width: 250px",
                                    "width: 250px", "width: 250px", "width: 250px"),
                       caption = "Table 1: Mortality models with all biological aging measures.
                       After accounting for chronological age differences, all biological aging measures were standardized to have mean = 0, SD = 1 by gender.
                       Original KDM Biological Age was computed in the NHANES 2007-2010.
                       Original Levine's Phenotypic Age was computed in the NHANES 1999-2010 and 2015-2018.")

}
