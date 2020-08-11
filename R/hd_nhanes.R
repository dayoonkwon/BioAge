#' Training HD algorithm using the NHANES III (1988 - 1994) and projecting into NHANES IV (1999 - 2018) dataset. For this function, NHANES III included men and women who are between the ages of 20 and 30, and have observe biomarker data within clinically acceptable distributions.
#'
#' @title hd_nhanes
#' @description Train HD algorithm in NHANES III and project into NHANES IV.
#' @param biomarkers A character vector indicating the names of the biomarkers included in the HD algorithm.
#' @return An object of class "hd". This object is a list with two elements (data and fit). The dataset can be drawn by typing 'data'. The model can be drawn by typing 'fit'.
#' @examples
#' #HD using NHANES
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
  train = NHANES3 %>%
    filter(age >= 20 & age <= 30 & pregnant == 0 & bmi < 30) %>%
    mutate(albumin = ifelse(albumin >= 3.5 & albumin <= 5, albumin, NA),
           albumin_gL = ifelse(is.na(albumin), NA, albumin_gL),
           alp = ifelse(gender == 2, ifelse(alp >= 37 & alp <= 98, alp, NA), ifelse(alp >= 45 & alp <= 115, alp, NA)),
           lnalp = ifelse(is.na(alp), NA, lnalp),
           bap = ifelse(gender == 2, ifelse(bap <= 14, bap, NA), ifelse(bap <= 20, bap, NA)),
           bun = ifelse(gender == 2, ifelse(bun >= 6 & bun <= 21, bun, NA), ifelse(bun >= 8 & bun <= 24, bun, NA)),
           lnbun = ifelse(is.na(bun), NA, lnbun),
           creat = ifelse(gender == 2, ifelse(creat >= 0.6 & creat <= 1.1, creat, NA), ifelse(creat >= 0.8 & creat <= 1.3, creat, NA)),
           creat_umol = ifelse(is.na(creat), NA, creat_umol),
           lncreat = ifelse(is.na(creat), NA, lncreat),
           lncreat_umol = ifelse(is.na(creat), NA, lncreat_umol),
           glucose = ifelse(glucose >= 60 & glucose <= 100, glucose, NA),
           glucose_mmol = ifelse(is.na(glucose), NA, glucose_mmol),
           glucose_fasting = ifelse(glucose_fasting >= 65 & glucose_fasting <= 110, glucose_fasting, NA),
           ttbl = ifelse(ttbl >= 0.1 & ttbl <= 1.4, ttbl, NA),
           uap = ifelse(gender == 2, ifelse(uap >= 2 & uap <= 7, uap, NA), ifelse(uap >= 2.1 & uap <= 8.5, uap, NA)),
           lnuap = ifelse(is.na(uap), NA, lnuap),
           basopa = ifelse(basopa >= 0 & basopa <= 2, basopa, NA),
           eosnpa = ifelse(eosnpa >=1 & eosnpa <= 7, eosnpa, NA),
           mcv = ifelse(gender == 2, ifelse(mcv >= 78 & mcv <= 101, mcv, NA), ifelse(mcv >= 82 & mcv <= 102, mcv, NA)),
           monopa = ifelse(monopa >= 3 & monopa <= 10, monopa, NA),
           neut = ifelse(neut >= 45 & neut <= 74, neut, NA),
           rbc = ifelse(gender == 2, ifelse(rbc >= 3.5 & rbc <= 5.5, rbc, NA), ifelse(rbc >= 4.2 & rbc <= 6.9, rbc, NA)),
           rdw = ifelse(rdw >= 11.5 & rdw <= 14.5, rdw, NA),
           cadmium = ifelse(cadmium >= 2.7 & cadmium <= 10.7, cadmium, NA),
           crp = ifelse(crp < 2, crp, NA),
           crp_cat = ifelse(is.na(crp), NA, crp_cat),
           lncrp = ifelse(is.na(crp), NA, lncrp),
           cyst = ifelse(cyst >= 0.51 & cyst <= 0.98, cyst, NA),
           ggt = ifelse(gender == 2, ifelse(ggt <= 37.79, ggt, NA), ifelse(ggt <= 55.19, ggt, NA)),
           insulin = ifelse(insulin >= 2.52 & insulin <= 24.1, insulin, NA),
           hba1c = ifelse(hba1c >= 4 & hba1c <= 5.6, hba1c, NA),
           lnhba1c = ifelse(is.na(hba1c), NA, lnhba1c),
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
           fev_1000 = ifelse(is.na(fev), NA, fev_1000),
           vitaminA = ifelse(vitaminA >= 1.05 & vitaminA <= 2.27, vitaminA, NA),
           vitaminE = ifelse(vitaminE <= 28, vitaminE, NA),
           vitaminB12 = ifelse(vitaminB12 >= 100 & vitaminB12 <= 700, vitaminB12, NA),
           vitaminC = ifelse(vitaminC >= 23 & vitaminC <= 85, vitaminC, NA))

  #calculate hd
  hd_fem = hd_calc(data = NHANES4 %>%
                     filter(gender == 2),
                   reference = train %>%
                     filter(gender == 2),
                   biomarkers)

  hd_male = hd_calc(data = NHANES4 %>%
                     filter(gender == 1),
                   reference = train %>%
                     filter(gender == 1),
                   biomarkers)

  dat = rbind(hd_fem$data, hd_male$data)

  dat = left_join(NHANES4, dat[,c("sampleID","hd","hd_log")], by= "sampleID")
  fit = list(female = hd_fem$fit, male = hd_male$fit, nobs = hd_fem$fit$nobs + hd_male$fit$nobs)

  hd = list(data = dat, fit = fit)
  class(hd) = append(class(hd),'hd')
  return(hd)


}
