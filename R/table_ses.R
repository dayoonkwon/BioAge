ses_res = function (dat, agevar, exposure) {

  out_dat = dat %>%
    select(all_of(agevar)) %>%
    tidyr::gather(., y, yvalue)

  exp_dat = dat %>%
    select(age,gender,all_of(exposure)) %>%
    tidyr::gather(., x, xvalue, all_of(exposure))

  res = out_dat %>%
    group_by(y) %>%
    do(data.frame(., exp_dat)) %>%
    group_by(y, x) %>%
    na.omit() %>%
    do(broom::tidy(lm(yvalue ~ xvalue + age + gender, data =.))) %>%
    filter(term == "xvalue") %>%
    mutate(estimate = paste(round(estimate, 3), " (", round(estimate - 1.96 * std.error, 3), ", ", round(estimate + 1.96 * std.error, 3), ")", sep = "")) %>%
    select(y, x, estimate) %>%
    tidyr::spread(y,estimate) %>%
    ungroup()

  match=match(exposure, res$x)
  table=res[match,] %>%
    mutate(x = exposure) %>%
    mutate_at(vars(agevar), funs(replace(., is.na(.), "-")))

  return(table)

}

#' Association with socioeconomic variables, adjusting for chronological age and gender and stratified by age
#'
#' @title table_ses
#' @description Association with socioeconomic variables
#' @param data The dataset for plotting corplot
#' @param agevar A character vector indicating the names of the interested biological age measures
#' @param exposure A character vector indicating the name of the interested socioeconomic variables
#' @note Chronological age and gender variables need to be named "age" and "gender"
#' @examples
#' table3 = table_ses(nhanes,
#'                    agevar = c("bioage_advance0","phenoage_advance0",
#'                                "bioage_advance","phenoage_advance",
#'                                "hd","hd_log"),
#'                    exposure = c("edu","annual_income","poverty_ratio"))
#'
#' table3
#'
#' @export
#' @import dplyr
#' @importFrom tidyr gather
#' @importForm broom tidy
#' @importFrom htmlTable htmlTable

table_ses = function (data, agevar, exposure) {

  dat = data %>%
    mutate_at(vars(all_of(exposure)), funs(scale(.))) %>%
    group_by(gender) %>%
    mutate_at(vars(all_of(agevar)), funs(scale(.))) %>%
    ungroup() %>%
    mutate(gender = as.factor(gender),
           age_cat = ifelse(age>=20&age<40,1,
                            ifelse(age>=40&age<60,2,
                                   ifelse(age>=60&age<=80,3,"NA"))))

  #full sample
  table1 = ses_res(dat, agevar, exposure)

  #gender stratification
  dat_age = split(dat, dat$age_cat)
  dat_age$'NA' = NULL

  table2 = lapply(dat_age, function(x) ses_res(x, agevar, exposure))
  table2 = do.call("rbind", table2)

  #combine tables
  table = rbind(table1,table2)

  #make final table
  label = data.frame("rgroup" = c("Full Sample", "Age 20-40", "Age 40-60", "Age 60-80"))

  label$n.rgroup = nrow(table1)


  htmlTable::htmlTable(table[,-1],
                       rnames = table$x,
                       rgroup = label$rgroup,
                       n.rgroup = as.numeric(label$n.rgroup),
                       tspanner = c("b (95% CI)",
                                    "Stratified by Age"),
                       n.tspanner = c(nrow(table1),
                                      nrow(table2)),
                       css.tspanner = "font-weight: 900; text-align: center;",
                       caption = "Linear regression models of all biological age measures with socioeconomic variables. All biological age measures were standardized to have mean = 0, SD = 1 by gender.")

}
