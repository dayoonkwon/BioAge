#develop training fit for homeostatic dysregulation (hd)
#theoretically the distance between observations
#hypothetically healthy and young cohort

#train seperately for men and women who are between thes of 20 and 30
#biomarker data within clinically acceptable distributions

#|Variable | Description | Female Healthy Range| Male Healthy Range|
#|:------- | :---------- | :------------------ | :-----------------|
#|sampleID | Unique individual identifier||
#|gender | gender (1=male; 2=female)||
#|**Biomarkers**||
#|albumin | Albumin (g/dL) | 3.5-5 | 3.5-5|
#|alp | Alkaline Phosphate (U/L) | 37-98 | 45-115|
#|bun  |Blood Urea Nitrogen (mg/dL) | 6-21 | 8-24|
#|creat | Creatinine (mg/dL) | 0.6-1.1 | 0.8-1.3|
#|lncreat | Creatinine (log) | log(0.6)-log(1.1) |log(0.8)-log(1.3)|
#|crp | CRP (mg/dL) | < 2 | < 2|
#|lncrp | CRP (log) | < log(2) | < log(2)|
#|hba1c | Glycalated Hemoglobin (%) | 4-5.6 | 4-5.6|
#|lymph |Lymphocite Percent (%) | 20-40 | 20-40|
#|wbc | White Blood Cell Count (1000 cells/uL)| 4.5-11 | 4.5-11|
#|uap | Uric Acid (mg/dL)| 2.7-6.3 | 3.7-8.0|
#|sbp | Systolic Blood Pressure | < 120 | < 120|
#|totchol | Total Cholesterol (mg/dL) | <200 | <200|

#' Calculate HD using NHANES dataset
#'
#' @title hd_nhanes
#' @description Calculate homeostatic dysregulation (HD) using NHANES dataset
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

  #develop training dataset for HD
  train = NHANES_ALL %>%
    filter(wave == 0 & age >= 20 & age <= 30 & pregnant == 0) %>%
    mutate(albumin = ifelse(albumin >= 3.5 & albumin <= 5, albumin, NA),
           albumin_gL = ifelse(!is.na(albumin), albumin*10, NA),
           alp = ifelse(gender == 2, ifelse(alp >= 37 & alp <= 98, alp, NA), ifelse(alp >= 45 & alp <= 115, alp, NA)),
           bap = ifelse(gender == 2, ifelse(bap <= 14, bap, NA), ifelse(bap <= 20, bap, NA)),
           bun = ifelse(gender == 2, ifelse(bun >= 6 & bun <= 21, bun, NA), ifelse(bun >= 8 & bun <= 24, bun, NA)),
           creat = ifelse(gender == 2, ifelse(creat >= 0.6 & creat <= 1.1, creat, NA), ifelse(creat >= 0.8 & creat <= 1.3, creat, NA)),
           creat_umol = ifelse(!is.na(creat), creat*88.4017, NA),
           lncreat = ifelse(!is.na(creat), log(creat), NA),
           lncreat_umol = ifelse(!is.na(creat_umol), log(creat_umol), NA),
           glucose = ifelse(glucose >= 60 & glucose <= 100, glucose, NA),
           glucose_mmol = ifelse(glucose_mmol >= 3.3 & glucose_mmol <= 5.6, glucose_mmol, NA),
           glucose_fasting = ifelse(glucose_fasting >= 65 & glucose_fasting <= 110, glucose_fasting, NA),
           ttbl = ifelse(ttbl >= 0.1 & ttbl <= 1.4, ttbl, NA),
           uap = ifelse(gender == 2, ifelse(uap >= 2 & uap <= 7, uap, NA), ifelse(uap >= 2.1 & uap <= 8.5, uap, NA)),
           basopa = ifelse(basopa >= 0 & basopa <= 2, basopa, NA),
           eosnpa = ifelse(eosnpa >=1 & eosnpa <= 7, eosnpa, NA),
           mcv = ifelse(gender == 2, ifelse(mcv >= 78 & mcv <= 101, mcv, NA), ifelse(mcv >= 82 & mcv <= 102, mcv, NA)),
           monopa = ifelse(monopa >= 3 & monopa <= 10, monopa, NA),
           neut = ifelse(neut >= 45 & neut <= 74, neut, NA),
           rbc = ifelse(gender == 2, ifelse(rbc >= 3.5 & rbc <= 5.5, rbc, NA), ifelse(rbc >= 4.2 & rbc <= 6.9, rbc, NA)),
           rdw = ifelse(rdw >= 11.5 & rdw <= 14.5, rdw, NA),
           cadmium = ifelse(cadmium >= 2.7 & cadmium <= 10.7, cadmium, NA),
           crp = ifelse(crp < 2, crp, NA),
           crp_cat = ifelse(!is.na(crp), crp_cat, NA),
           lncrp = ifelse(!is.na(crp), lncrp, NA),
           cyst = ifelse(cyst >= 0.51 & cyst <= 0.98, cyst, NA),
           ggt = ifelse(gender == 2, ifelse(ggt <= 37.79, ggt, NA), ifelse(ggt <= 55.19, ggt, NA)),
           insulin = ifelse(insulin >= 2.52 & insulin <= 24.1, insulin, NA),
           hba1c = ifelse(hba1c >= 4 & hba1c <= 5.6, hba1c, NA),
           hdl = ifelse(gender == 2, ifelse(hdl >= 40 & hdl <= 86, hdl, NA), ifelse(hdl >= 35 & hdl <= 80, hdl, NA)),
           ldl = ifelse(ldl >= 80 & ldl <= 130, ldl, NA),
           trig = ifelse(trig >= 54 & trig <= 110, trig, NA),
           lymph = ifelse(lymph >= 20 & lymph <= 40, lymph, NA),
           wbc = ifelse(wbc >= 4.5 & wbc <= 11, wbc, NA),
           uap = ifelse(gender == 2, ifelse(uap >= 2.7 & uap <= 6.3, uap, NA), ifelse(uap >= 3.7 & uap <= 8, uap, NA)),
           sbp = ifelse(sbp < 120, sbp, NA),
           dbp = ifelse(dbp < 80, dbp, NA),
           meanbp = ifelse(meanbp < 93.33, meanbp, NA),
           pulse = ifelse(pulse >= 60 & pulse <= 100, pulse, NA),
           totchol = ifelse(totchol < 200, totchol, NA),
           fev = ifelse(fev >= mean(fev, na.rm = TRUE) * 0.8, fev, NA),
           fev_new = ifelse(!is.na(fev), fev_new, NA),
           vitaminA = ifelse(vitaminA >= 1.05 & vitaminA <= 2.27, vitaminA, NA),
           vitaminE = ifelse(vitaminE <= 28, vitaminE, NA),
           vitaminB12 = ifelse(vitaminB12 >= 0.0001 & vitaminB12 <= 0.0007, vitaminB12, NA),
           vitaminC = ifelse(vitaminC >= 23 & vitaminC <= 85, vitaminC, NA))

  #develop training dataset for HD
  #femlae
  train_fem = train %>%
    filter(gender == 2) %>%
    mutate_at(vars(biomarkers), list(~ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  #male
  train_male = train %>%
    filter(gender == 1) %>%
    mutate_at(vars(biomarkers), list(~ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  #develop test dataset for HD
  test = NHANES_ALL %>%
    filter(wave > 0 & wave < 11 & age >= 20)

  test_fem = test %>%
    filter(gender == 2) %>%
    mutate_at(vars(biomarkers), list(~ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  test_male = test %>%
    filter(gender == 1) %>%
    mutate_at(vars(biomarkers), list(~ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  #calculate hd
  hd_fem = hd_calc(test_fem, train_fem, biomarkers)
  hd_male = hd_calc(test_male, train_male, biomarkers)
  all = rbind(hd_fem$data,hd_male$data)

  dat = left_join(NHANES_ALL,all[,c("sampleID","hd","hd_log")], by= "sampleID")
  fit = list(female = hd_fem$fit, male = hd_male$fit, nobs = hd_fem$fit$nobs + hd_male$fit$nobs)

  hd = list(data = dat, fit = fit)
  class(hd) = append(class(hd),'hd')
  return(hd)


}
