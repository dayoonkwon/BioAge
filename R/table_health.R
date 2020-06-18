health_res = function (dat, agevar, outcome, covar, label) {

  covars = paste(covar, collapse = "+")

  res = dat %>%
    select(all_of(agevar), all_of(outcome), all_of(covar))%>%
    tidyr::pivot_longer(all_of(outcome), names_to = "y", values_to = "yvalue") %>%
    tidyr::pivot_longer(all_of(agevar), names_to = "x", values_to = "xvalue") %>%
    mutate(x = factor(x, levels = agevar, labels = label)) %>%
    group_by(y, x) %>%
    na.omit() %>%
    do(broom::tidy(lm(paste("yvalue~xvalue+", covars), data =.))) %>%
    filter(term == "xvalue") %>%
    mutate(estimate = paste(round(estimate, 2), " (", round(estimate - 1.96 * std.error, 2), ", ", round(estimate + 1.96 * std.error, 2), ")", sep = "")) %>%
    select(y, x, estimate) %>%
    tidyr::spread(x,estimate) %>%
    ungroup()

  match = match(outcome, res$y)

  table = res[match,] %>%
    mutate(y = outcome) %>%
    mutate_at(vars(all_of(label)), list(~replace(., is.na(.), "-")))

  return(table)

}

health_n = function (dat, agevar, outcome, covar, label) {

  n = dat %>%
    select(all_of(agevar), all_of(outcome), all_of(covar))%>%
    tidyr::pivot_longer(all_of(outcome), names_to = "y", values_to = "yvalue") %>%
    tidyr::pivot_longer(all_of(agevar), names_to = "x", values_to = "xvalue") %>%
    mutate(x = factor(x, levels = agevar, labels = label)) %>%
    group_by(y, x) %>%
    na.omit() %>%
    summarise(n = length(which(!is.na(yvalue)))) %>%
    tidyr::spread(x,n) %>%
    ungroup()

  match = match(outcome, n$y)

  n = n[match,] %>%
    mutate(y = outcome) %>%
    mutate_at(vars(all_of(label)), list(~replace(., is.na(.), "-")))

  return(n)

}


#' Association with current health status outcomes, adjusting for chronological age and gender and stratified by gender, race, and age
#'
#' @title table_health
#' @description Association with current health status outcomes
#' @param data The dataset for linear regression table
#' @param agevar A character vector indicating the names of the interested biological aging measures
#' @param outcome A character vector indicating the name of the interested current health status outcomes
#' @param label A character vector indicating the labels of the biological aging measures
#' @note Chronological age and gender variables need to be named "age" and "gender"
#' @examples
#' table2 = table_health(data,
#'                       agevar = c("kdm_advance0","phenoage_advance0",
#'                                "kdm_advance","phenoage_advance",
#'                                "hd","hd_log"),
#'                       outcome = c("health","adl","lnwalk","grip_scaled"),
#'                       label = c("KDM\nBiological\nAge",
#'                                 "Levine\nPhenotypic\nAge",
#'                                 "Modified-KDM\nBiological\nAge",
#'                                 "Modified-Levine\nPhenotypic\nAge",
#'                                 "Mahalanobis\nDistance",
#'                                 "Log\nMahalanobis\nDistance"))
#'
#' table2$table
#' table2$n
#'
#' @export
#' @import dplyr
#' @importFrom tidyr pivot_longer
#' @importFrom tidyr spread
#' @importFrom broom tidy
#' @importFrom htmlTable htmlTable

table_health = function (data, agevar, outcome, label) {

  dat = data %>%
    mutate_at(vars(all_of(outcome)), list(~scale(.))) %>%
    group_by(gender) %>%
    mutate_at(vars(all_of(agevar)), list(~scale(.))) %>%
    ungroup() %>%
    mutate(gender = as.factor(gender),
           age_cat = ifelse(age>=20&age<40,1,
                            ifelse(age>=40&age<60,2,
                                   ifelse(age>=60&age<=80,3,"NA"))))

  #full sample
  table1 = health_res(dat, agevar, outcome, covar = c("age", "gender"), label)
  n1 = health_n(dat, agevar, outcome, covar = c("age", "gender"), label)

  #gender stratification
  dat_gender = split(dat, dat$gender)
  table2 = lapply(dat_gender, function(x) health_res(x, agevar, outcome, covar = "age", label))
  table2 = do.call("rbind", table2)

  n2 = lapply(dat_gender, function(x) health_n(x, agevar, outcome, covar = "age", label))
  n2 = do.call("rbind", n2)

  #race stratification
  dat_race = split(dat, dat$race)
  table3 = lapply(dat_race, function(x) health_res(x, agevar, outcome, covar = c("age","gender"), label))
  table3 = do.call("rbind", table3)

  n3 = lapply(dat_race, function(x) health_n(x, agevar, outcome, covar = c("age","gender"), label))
  n3 = do.call("rbind", n3)

  #age stratification
  dat_age = split(dat, dat$age_cat)
  dat_age$'NA' = NULL
  table4 = lapply(dat_age, function(x) health_res(x, agevar, outcome, covar = c("age","gender"), label))
  table4 = do.call("rbind", table4)

  n4 = lapply(dat_age, function(x) health_n(x, agevar, outcome, covar = c("age","gender"), label))
  n4 = do.call("rbind", n4)

  #combine tables
  table = rbind(table1, table2, table3, table4)
  n = rbind(n1, n2, n3, n4)

  #make final table
  table = htmlTable::htmlTable(table[,-1],
                       rnames = table$y,
                       align = "llllll",
                       rgroup = c("Full Sample", "Men", "Women", "White", "Black", "Other", "Age 20-40", "Age 40-60", "Age 60-80"),
                       n.rgroup = rep(length(outcome),9),
                       tspanner = c("b (95% CI)",
                                    "Stratified by Gender",
                                    "Stratified by Race",
                                    "Stratified by Age"),
                       n.tspanner = c(4,8,12,12),
                       css.rgroup = "font-weight: 900; text-align: left; font-size: 0.77em;",
                       css.tspanner = "font-weight: 900; text-align: center; font-size: 0.77em;",
                       css.cell = rbind(rep("width: 600px; font-size: 0.77em;", times=ncol(table)),
                                        matrix("width: 600px; font-size: 0.77em;", ncol=ncol(table), nrow=nrow(table))),
                       caption = "Table 2. Associations of biological aging measures with healthspan-related characteristics.
                       Coefficients are from linear regressions of healthspan-related characteristics on biological aging measures.
                       Outcome variables were standardized to have M=0, SD=1 for analysis.
                       Standardization was performed separately for men and women in the case of grip strength.
                       Walk speed was log transformed prior to standardization to reduce skew.
                       KDM Biological Age and Levine Phenotypic Age measures were differenced from chronological age for analysis (i.e. values = BA-CA).
                       These differenced values were then standardized to have M=0, SD=1 separately for men and women within the analysis sample so that effect-sizes are denominated in terms of a sex-specific 1 SD unit increase in biological age advancement.
                       Models included covariates for chronological age and sex.
                       The original KDM Biological Age algorithm (left-most column) was projected onto data from NHANES 2007-2010 only because other NHANES IV waves did not include spirometry measurements.
                       The original Levine Phenotypic Age algorithm (second column from left) was projected onto data from NHANES 1999-2010 and 2015-2018 only because the intervening waves did not include CRP measurements.
                       Walk speed was measured only in NHANES 1999-2002 and is available only for participants aged 50 and older.
                       Grip strength was measured only in NHANES 2011-2014.")

  n = htmlTable::htmlTable(n[,-1],
                           rnames = n$y,
                           align = "llllll",
                           rgroup = c("Full Sample", "Men", "Women", "White", "Black", "Other", "Age 20-40", "Age 40-60", "Age 60-80"),
                           n.rgroup = rep(length(outcome),9),
                           tspanner = c("n",
                                        "Stratified by Gender",
                                        "Stratified by Race",
                                        "Stratified by Age"),
                           n.tspanner = c(4,8,12,12),
                           css.rgroup = "font-weight: 900; text-align: left; font-size: 0.8em;",
                           css.tspanner = "font-weight: 900; text-align: center; font-size: 0.8em;",
                           css.cell = rbind(rep("width: 600px; font-size: 0.8em;", times=ncol(n)),
                                            matrix("width: 600px; font-size: 0.8em;", ncol=ncol(n), nrow=nrow(n))),
                           caption = "Table 2.1. Sample sizes for regression in Table 2.
                       Coefficients are from linear regressions of healthspan-related characteristics on biological aging measures.")

  result = list(table = table, n = n)

  return(result)


}
