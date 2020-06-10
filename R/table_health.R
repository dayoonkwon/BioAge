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
    mutate(estimate = paste(round(estimate, 3), " (", round(estimate - 1.96 * std.error, 3), ", ", round(estimate + 1.96 * std.error, 3), ")", sep = "")) %>%
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
#' table2 = table_health(nhanes,
#'                       agevar = c("bioage_advance0","phenoage_advance0",
#'                                "bioage_advance","phenoage_advance",
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
#' @importForm broom tidy
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
                       css.tspanner = "font-weight: 900; text-align: center;",
                       css.cell = c("width: 200px", "width: 250px", "width: 250px", "width: 250px",
                                    "width: 250px", "width: 250px", "width: 250px"),
                       caption = "Table 2: Linear regression models of all biological aging measures with current health status outcomes.
                       After accounting for chronological age differences, all biological aging measures were standardized to have mean = 0, SD = 1 by gender.
                       Original KDM Biological Age was computed in the NHANES 2007-2010.
                       Original Levine's Phenotypic Age was computed in the NHANES 1999-2010 and 2015-2018.
                       Walk speed was measured only for people aged 50 and older in the NHANES 1999-2002.
                       Grip strength was only measured in the NHANES 2011-2014.")

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
                           css.tspanner = "font-weight: 900; text-align: center;",
                           css.cell = c("width: 200px", "width: 250px", "width: 250px", "width: 250px",
                                        "width: 250px", "width: 250px", "width: 250px"),
                           caption = "Table 2.1: Sample size for linear regression models of all biological aging measures with current health status outcomes.
                       Original KDM Biological Age was computed in the NHANES 2007-2010.
                       Original Levine's Phenotypic Age was computed in the NHANES 1999-2010 and 2015-2018.
                       Walk speed was measured only for people aged 50 and older in the NHANES 1999-2002.
                       Grip strength was only measured in the NHANES 2011-2014.")

  result = list(table = table, n = n)

  return(result)


}
