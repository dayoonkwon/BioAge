surv_res = function (dat, agevar, covar) {

  covars = paste(covar, collapse = "+")

  cox = list()

  for (i in agevar) {

    form = formula(paste("survival::Surv(time,status)~", i, "+", covars, sep = ""))
    cox[[i]] = survival::coxph(form, data = dat)

  }; rm(i)

  res = lapply(cox,summary)

  table = as.data.frame(lapply(res, function(x)paste(round(x$conf.int[1,1],2), " (",round(x$conf.int[1,3],2),", ",round(x$conf.int[1,4],2),")",sep="")))
  table$sample = "BioAge"

  n = as.data.frame(lapply(res,function(x)x$n))
  n$sample = "n"

  table = rbind(n,table)

  return(table)

}

#' BioAge coefficients in the table are hazard ratios estimated from Cox proportional hazard regressions. KDM Biological Age and Levine Phenotypic Age measures were differenced from chronological age for analysis (i.e. values = BA-CA). These differenced values were then standardized to have M=0, SD=1 separately for men and women within the analysis sample so that effect-sizes are  denominated in terms of a sex-specific 1 SD unit increase in biological age advancement. Models included covariates for chronological age and sex.
#'
#' @title table_surv
#' @description Associations of biological aging measures with mortality.
#' @param data A dataset with projected biological aging measures for analysis.
#' @param agevar A character vector indicating the names of the biological aging measures.
#' @param label A character vector indicating the labels of the biological aging measures.
#' @note Chronological age, gender, and race/ethnicity variables need to be named "age", "gender", and "race".
#' @examples
#' table1 = table_surv(data,
#'                     agevar = c("kdm_advance0","phenoage_advance0",
#'                                "kdm_advance","phenoage_advance",
#'                                "hd","hd_log"),
#'                     label = c("KDM\nBiological Age\nAdvancement",
#'                     "Levine\nPhenotypic Age\nAdvancement",
#'                     "Modified-KDM\nBiological Age\nAdvancement",
#'                     "Modified-Levine\nPhenotypic Age\nAdvancement",
#'                     "Homeostatic\nDysregulation",
#'                     "Log\nHomeostatic\nDysregulation"))
#'
#' table1
#'
#' @export
#' @import dplyr
#' @import survival
#' @import htmlTable


table_surv = function (data, agevar, label) {

  dat = data %>%
    group_by(gender) %>%
    mutate_at(vars(all_of(agevar)), list(~scale(.))) %>%
    ungroup() %>%
    mutate(gender = as.factor(gender),
           age_cat = ifelse(age<=65, "yes", "no"))

  #full sample
  table1 = surv_res(dat, agevar, covar = c("age", "gender"))

  #gender stratification
  dat_gender = split(dat, dat$gender)
  table2 = lapply(dat_gender, function(x) surv_res(x, agevar, covar = "age"))
  table2 = do.call("rbind", table2)

  #race stratification
  dat_race = split(dat, dat$race)
  table3 = lapply(dat_race, function(x) surv_res(x, agevar, covar = c("age","gender")))
  table3 = do.call("rbind", table3)

  #age stratification
  dat_age = split(dat, dat$age_cat)
  table4 = surv_res(dat_age$yes, agevar, covar = c("age", "gender"))

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
                       css.rgroup = "font-weight: 900; text-align: left; font-size: .83em;",
                       css.tspanner = "font-weight: 900; text-align: center; font-size: .83em;",
                       css.cell = rbind(rep("width: 300px; font-size: .83em;", times=ncol(table)),
                                        matrix("width: 300px; font-size: .83em;", ncol=ncol(table), nrow=nrow(table))),
                       caption = "Table 1. Associations of biological aging measures with mortality.
                       BioAge coefficients in the table are hazard ratios estimated from Cox proportional hazard regressions.
                       KDM Biological Age and Levine Phenotypic Age measures were differenced from chronological age for analysis (i.e. values = BA-CA).
                       These differenced values were then standardized to have M=0, SD=1 separately for men and women within the analysis sample so that effect-sizes are denominated in terms of a sex-specific 1 SD unit increase in biological age advancement.
                       Models included covariates for chronological age and sex.
                       The original KDM Biological Age algorithm (left-most column) was projected onto data from NHANES 2007-2010 only because other NHANES IV waves did not include spirometry measurements.
                       The original Levine Phenotypic Age algorithm (second column from left) was projected onto data from NHANES 1999-2010 and 2015-2018 only because the intervening waves did not include CRP measurements.")
}
