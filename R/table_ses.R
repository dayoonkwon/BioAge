ses_res = function (dat, agevar, exposure, covar, label) {

  covars = paste(covar, collapse = "+")

  out_dat = dat %>%
    select(all_of(agevar)) %>%
    tidyr::pivot_longer(all_of(agevar), names_to = "y", values_to = "yvalue") %>%
    mutate(y = factor(y, levels = agevar, labels = label))

  exp_dat = dat %>%
    select(age,gender,all_of(exposure)) %>%
    tidyr::pivot_longer(all_of(exposure), names_to = "x", values_to = "xvalue")

  res = out_dat %>%
    group_by(y) %>%
    do(data.frame(., exp_dat)) %>%
    group_by(y, x) %>%
    na.omit() %>%
    do(broom::tidy(lm(paste("yvalue~xvalue+", covars), data =.))) %>%
    filter(term == "xvalue") %>%
    mutate(estimate = paste(round(estimate, 3), " (", round(estimate - 1.96 * std.error, 3), ", ", round(estimate + 1.96 * std.error, 3), ")", sep = "")) %>%
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

  out_dat = dat %>%
    select(all_of(agevar)) %>%
    tidyr::pivot_longer(all_of(agevar), names_to = "y", values_to = "yvalue") %>%
    mutate(y = factor(y, levels = agevar, labels = label))

  exp_dat = dat %>%
    select(age,gender,all_of(exposure)) %>%
    tidyr::pivot_longer(all_of(exposure), names_to = "x", values_to = "xvalue")

  n = out_dat %>%
    group_by(y) %>%
    do(data.frame(.,exp_dat)) %>%
    na.omit() %>%
    group_by(y,x)%>%
    summarise(n = length(which(!is.na(yvalue)))) %>%
    tidyr::spread(y,n) %>%
    ungroup()

  match = match(exposure, n$x)

  n = n[match,] %>%
    mutate(x = exposure) %>%
    mutate_at(vars(all_of(label)), list(~replace(., is.na(.), "-")))

  return(n)

}



#' Association with socioeconomic variables, adjusting for chronological age and gender and stratified by gender, race, and age
#'
#' @title table_ses
#' @description Association with socioeconomic variables
#' @param data The dataset for linear regression table
#' @param agevar A character vector indicating the names of the interested biological aging measures
#' @param exposure A character vector indicating the name of the interested socioeconomic variables
#' @note Chronological age and gender variables need to be named "age" and "gender"
#' @examples
#' table3 = table_ses(nhanes,
#'                    agevar = c("bioage_advance0","phenoage_advance0",
#'                                "bioage_advance","phenoage_advance",
#'                                "hd","hd_log"),
#'                    exposure = c("edu","annual_income","poverty_ratio"),
#'                    label = c("KDM\nBiological\nAge",
#'                              "Levine\nPhenotypic\nAge",
#'                              "Modified-KDM\nBiological\nAge",
#'                              "Modified-Levine\nPhenotypic\nAge",
#'                              "Mahalanobis\nDistance",
#'                              "Log\nMahalanobis\nDistance")))
#'
#' table3$table
#' table3$n
#'
#' @export
#' @import dplyr
#' @importFrom tidyr pivot_longer
#' @importFrom tidyr spread
#' @importForm broom tidy
#' @importFrom htmlTable htmlTable

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
                               n.rgroup = c(4,4,4,4,4,4,4,4,4),
                               tspanner = c("b (95% CI)",
                                            "Stratified by Gender",
                                            "Stratified by Race",
                                            "Stratified by Age"),
                               n.tspanner = c(4,8,12,12),
                               css.tspanner = "font-weight: 900; text-align: center;",
                               css.cell = c("width: 200px", "width: 250px", "width: 250px", "width: 250px",
                                            "width: 250px", "width: 250px", "width: 250px"),
                               caption = "Table 3: Linear regression models of all biological aging measures with socioeconomic variables.
                       After accounting for chronological age differences, all biological aging measures were standardized to have mean = 0, SD = 1 by gender.
                       Original KDM Biological Age was computed in the NHANES 2007-2010.
                       Original Levine's Phenotypic Age was computed in the NHANES 1999-2010 and 2015-2018.")

  n = htmlTable::htmlTable(n[,-1],
                           rnames = n$x,
                           align = "llllll",
                           rgroup = c("Full Sample", "Men", "Women", "White", "Black", "Other", "Age 20-40", "Age 40-60", "Age 60-80"),
                           n.rgroup = c(4,4,4,4,4,4,4,4,4),
                           tspanner = c("n",
                                        "Stratified by Gender",
                                        "Stratified by Race",
                                        "Stratified by Age"),
                           n.tspanner = c(4,8,12,12),
                           css.tspanner = "font-weight: 900; text-align: center;",
                           css.cell = c("width: 200px", "width: 250px", "width: 250px", "width: 250px",
                                        "width: 250px", "width: 250px", "width: 250px"),
                           caption = "Table 3.1: Sample size for linear regression models of all biological aging measures with socioeconomic variables.
                       Original KDM Biological Age was computed in the NHANES 2007-2010.
                       Original Levine's Phenotypic Age was computed in the NHANES 1999-2010 and 2015-2018.")

  result = list(table = table, n = n)

  return(result)


}
