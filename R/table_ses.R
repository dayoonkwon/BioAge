ses_res = function (dat, agevar, exposure, covar, label) {

  covars = paste(covar, collapse = "+")

  res = dat %>%
    select(all_of(agevar), all_of(exposure), all_of(covar)) %>%
    tidyr::pivot_longer(all_of(agevar), names_to = "y", values_to = "yvalue") %>%
    mutate(y = factor(y, levels = agevar, labels = label)) %>%
    tidyr::pivot_longer(all_of(exposure), names_to = "x", values_to = "xvalue") %>%
    group_by(y, x) %>%
    na.omit() %>%
    do(broom::tidy(lm(paste("yvalue~xvalue+", covars), data =.))) %>%
    filter(term == "xvalue") %>%
    mutate(estimate = paste(round(estimate, 2), " (", round(estimate - 1.96 * std.error, 2), ", ", round(estimate + 1.96 * std.error, 2), ")", sep = "")) %>%
    select(y, x, estimate) %>%
    tidyr::spread(y,estimate) %>%
    ungroup()

  match=match(exposure, res$x)

  table=res[match,] %>%
    mutate(x = exposure) %>%
    mutate_at(vars(all_of(label)), list(~replace(., is.na(.), "-")))

  return(table)

}

ses_n = function (dat, agevar, exposure, covar, label) {

  n = dat %>%
    select(all_of(agevar), all_of(exposure), all_of(covar)) %>%
    tidyr::pivot_longer(all_of(agevar), names_to = "y", values_to = "yvalue") %>%
    mutate(y = factor(y, levels = agevar, labels = label)) %>%
    tidyr::pivot_longer(all_of(exposure), names_to = "x", values_to = "xvalue") %>%
    group_by(y, x) %>%
    na.omit() %>%
    summarise(n = length(which(!is.na(yvalue)))) %>%
    tidyr::spread(y,n) %>%
    ungroup()

  match = match(exposure, n$x)

  n = n[match,] %>%
    mutate(x = exposure) %>%
    mutate_at(vars(all_of(label)), list(~replace(., is.na(.), "-")))

  return(n)

}



#' Coefficients are from linear regressions of biological aging measures on measures of socioeconomic circumstances. KDM Biological Age and Levine Phenotypic Age measures were differenced from chronological age for analysis (i.e. values = BA-CA). These differenced values were then standardized to have M=0, SD=1 separately for men and women within the analysis sample. Socioeconomic circumstances measures were standardized to M=0, SD=1 for analysis so that effect-sizes are denominated in terms of a 1 SD unit improvement in socioeconomic circumstances.
#'
#' @title table_ses
#' @description Associations of socioeconomic circumstances measures with measures of biological aging.
#' @param data A dataset with projected biological aging measures for analysis.
#' @param agevar A character vector indicating the names of the biological aging measures.
#' @param exposure A character vector indicating the name of the socioeconomic circumstances.
#' @param label A character vector indicating the labels of the biological aging measures.
#' @return The result is a list with two elements (table and  n). The regression table can be drawn by typing 'table'. The sample size table can be drawn by typing 'n'.
#' @note Chronological age, gender, and race/ethnicity variables need to be named "age", "gender", and "race".
#' @examples
#' table3 = table_ses(data,
#'                    agevar = c("kdm_advance0","phenoage_advance0",
#'                                "kdm_advance","phenoage_advance",
#'                                "hd","hd_log"),
#'                    exposure = c("edu","annual_income","poverty_ratio"),
#'                    label = c("KDM\nBiological Age\nAdvancement",
#'                              "Levine\nPhenotypic Age\nAdvancement",
#'                              "Modified-KDM\nBiological Age\nAdvancement",
#'                              "Modified-Levine\nPhenotypic Age\nAdvancement",
#'                              "Homeostatic\nDysregulation",
#'                              "Log\nHomeostatic\nDysregulation"))
#'
#' table3$table
#' table3$n
#'
#' @export
#' @import dplyr
#' @import tidyr
#' @import broom
#' @import htmlTable

table_ses = function (data, agevar, exposure, label) {

  dat = data %>%
    mutate_at(vars(all_of(exposure)), list(~scale(.))) %>%
    group_by(gender) %>%
    mutate_at(vars(all_of(agevar)), list(~scale(.))) %>%
    ungroup() %>%
    mutate(gender = as.factor(gender),
           age_cat = ifelse(age>=20&age<40,1,
                            ifelse(age>=40&age<60,2,
                                   ifelse(age>=60&age<=80,3,"NA"))))

  #full sample
  table1 = ses_res(dat, agevar, exposure, covar = c("age", "gender"), label)
  n1 = ses_n(dat, agevar, exposure, covar = c("age", "gender"), label)

  #gender stratification
  dat_gender = split(dat, dat$gender)
  table2 = lapply(dat_gender, function(x) ses_res(x, agevar, exposure, covar = "age", label))
  table2 = do.call("rbind", table2)

  n2 = lapply(dat_gender, function(x) ses_n(x, agevar, exposure, covar = "age", label))
  n2 = do.call("rbind", n2)

  #race stratification
  dat_race = split(dat, dat$race)
  table3 = lapply(dat_race, function(x) ses_res(x, agevar, exposure, covar = c("age","gender"), label))
  table3 = do.call("rbind", table3)

  n3 = lapply(dat_race, function(x) ses_n(x, agevar, exposure, covar = c("age","gender"), label))
  n3 = do.call("rbind", n3)

  #age stratification
  dat_age = split(dat, dat$age_cat)
  dat_age$'NA' = NULL
  table4 = lapply(dat_age, function(x) ses_res(x, agevar, exposure, covar = c("age","gender"), label))
  table4 = do.call("rbind", table4)

  n4 = lapply(dat_age, function(x) ses_n(x, agevar, exposure, covar = c("age","gender"), label))
  n4 = do.call("rbind", n4)

  #combine tables
  table = rbind(table1, table2, table3, table4)
  n = rbind(n1, n2, n3, n4)

  #make final table
  table = htmlTable::htmlTable(table[,-1],
                               rnames = table$x,
                               align = "llllll",
                               rgroup = c("Full Sample", "Men", "Women", "White", "Black", "Other", "Age 20-40", "Age 40-60", "Age 60-80"),
                               n.rgroup = rep(length(exposure),9),
                               tspanner = c("b (95% CI)",
                                            "Stratified by Gender",
                                            "Stratified by Race",
                                            "Stratified by Age"),
                               n.tspanner = c(3,6,9,9),
                               css.rgroup = "font-weight: 900; text-align: left; font-size: 0.69em;",
                               css.tspanner = "font-weight: 900; text-align: center; font-size: 0.69em;",
                               css.cell = rbind(rep("width: 600px; font-size: 0.69em;", times=ncol(table)),
                                                matrix("width: 600px; font-size: 0.69em;", ncol=ncol(table), nrow=nrow(table))),
                               caption = "Table 3. Associations of socioeconomic circumstances measures with measures of biological aging.
                               Coefficients are from linear regressions of biological aging measures on measures of socioeconomic circumstances.
                               KDM Biological Age and Levine Phenotypic Age measures were differenced from chronological age for analysis (i.e. values = BA-CA).
                               These differenced values were then standardized to have M=0, SD=1 separately for men and women within the analysis sample.
                               Socioeconomic circumstances measures were standardized to M=0, SD=1 for analysis so that effect-sizes are denominated in terms of a 1 SD unit improvement in socioeconomic circumstances.
                               Models included covariates for chronological age and sex. The original KDM Biological Age algorithm (left-most column) was projected onto data from NHANES 2007-2010 only because other NHANES IV waves did not include spirometry measurements.
                               The original Levine Phenotypic Age algorithm (second column from left) was projected onto data from NHANES 1999-2010 and 2015-2018 only because the intervening waves did not include CRP measurements.")

  n = htmlTable::htmlTable(n[,-1],
                           rnames = n$x,
                           align = "llllll",
                           rgroup = c("Full Sample", "Men", "Women", "White", "Black", "Other", "Age 20-40", "Age 40-60", "Age 60-80"),
                           n.rgroup = rep(length(exposure),9),
                           tspanner = c("n",
                                        "Stratified by Gender",
                                        "Stratified by Race",
                                        "Stratified by Age"),
                           n.tspanner = c(3,6,9,9),css.rgroup = "font-weight: 900; text-align: left; font-size: 0.8em;",
                           css.tspanner = "font-weight: 900; text-align: center; font-size: 0.8em;",
                           css.cell = rbind(rep("width: 600px; font-size: 0.8em;", times=ncol(n)),
                                            matrix("width: 600px; font-size: 0.8em;", ncol=ncol(n), nrow=nrow(n))),
                           caption = "Table 3.1: Sample sizes for regression in Table 3.
                           Coefficients are from linear regressions of biological aging measures on measures of socioeconomic circumstances.")

  result = list(table = table, n = n)

  return(result)


}
