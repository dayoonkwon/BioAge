#' Calculate Homeostatic Dysregulation Using NHANES Dataset
#'
#' @title hd_nhanes
#' @description Calculate Homeostatic Dysregulation (HD) Using NHANES Dataset
#' @param biomarkers A character vector indicating the names of the variables for the biomarkers to use in calculating HD
#' @return An object of class "hd". This object is a list with two elements (data and fit)
#' @examples
#' #Calculate HD
#' hd = hd_nhanes(biomarkers=c("albumin","lymph","mcv","glucose","rdw","creat","lncrp","alp","wbc"))
#'
#' #Extract HD dataset
#' data = hd$data
#'
#'
#' @export
#' @import dplyr


hd_nhanes = function(biomarkers) {

  load("./R/sysdata.rda")

  #develop training dataset for HD
  train = NHANES_ALL %>%
    filter(wave == 0 & age >= 20 & age <= 30 & pregnant == 0) %>%
    mutate(albumin = ifelse(albumin >= 3.5 & albumin <= 5, albumin, NA),
           alp = ifelse(gender == 2, ifelse(alp >= 37 & alp <= 98, alp, NA), ifelse(alp >= 45 & alp <= 115, alp, NA)),
           bun = ifelse(gender == 2, ifelse(bun >= 6 & bun <= 21, bun, NA), ifelse(bun >= 8 & bun <= 24, bun, NA)),
           creat = ifelse(gender == 2, ifelse(creat >= 0.6 & creat <= 1.1, creat, NA), ifelse(creat >= 0.8 & creat <= 1.3, creat, NA)),
           lncreat = ifelse(gender == 2,ifelse(lncreat >= log(0.6) & lncreat <= log(1.1), lncreat, NA), ifelse(lncreat >= log(0.8) & lncreat <= log(1.3), lncreat, NA)),
           crp = ifelse(crp < 2, crp, NA),
           lncrp = ifelse(lncrp < log(2), lncrp, NA),
           hba1c = ifelse(hba1c >= 4 & hba1c <= 5.6, hba1c, NA),
           lymph = ifelse(lymph >= 20 & lymph <= 40, lymph, NA),
           wbc = ifelse(wbc >= 4.5 & wbc <= 11, wbc, NA),
           uap = ifelse(gender == 2, ifelse(uap >= 2.7 & uap <= 6.3, uap, NA), ifelse(uap >= 3.7 & uap <= 8, uap, NA)),
           sbp = ifelse(sbp < 120, sbp, NA),
           totchol = ifelse(totchol < 200, totchol, NA))

  #develop training dataset for HD
  #femlae
  train_fem = train %>%
    filter(gender == 2) %>%
    mutate_at(vars(biomarkers), funs(ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  #male
  train_male = train %>%
    filter(gender == 1) %>%
    mutate_at(vars(biomarkers), funs(ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  #develop test dataset for HD
  test = NHANES_ALL %>%
    filter(wave > 0 & wave < 11 & age >= 20)

  test_fem = test %>%
    filter(gender == 2) %>%
    mutate_at(vars(biomarkers), funs(ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  test_male = test %>%
    filter(gender == 1) %>%
    mutate_at(vars(biomarkers), funs(ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  #calculate hd
  hd_fem = hd_calc(test_fem, train_fem, biomarkers)
  hd_male = hd_calc(test_male, train_male, biomarkers)
  all = rbind(hd_fem$data,hd_male$data)

  dat = left_join(NHANES_ALL,all[,c("seqn","year","hd","hd_log")],by=c("seqn","year"))
  fit = list(female = hd_fem$fit, male = hd_male$fit, nobs = hd_fem$fit$nobs + hd_male$fit$nobs)

  hd = list(data = dat, fit = fit)
  class(hd) = append(class(hd),'hd')
  return(hd)


}
