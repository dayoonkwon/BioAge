#' Calculate Klemera-Doubal Method Biological Age Using NHANES Dataset
#'
#' @title bioage_nhanes
#' @description Calculate Klemera-Doubal Method (KDM) Biological Age Using NHANES Dataset
#' @param biomarkers A character vector indicating the names of the variables for the biomarkers to use in calculating bioage
#' @return An object of class "bioage". This object is a list with two elements (data and fit)
#' @examples
#' #Calculate KDM bioage
#' bioage = bioage_nhanes(biomarkers=c("fev","sbp","totchol","hba1c","albumin","creat","lncrp","alp","bun"))
#'
#' #Extract bioage dataset
#' data = bioage$data
#'
#'
#' @export


bioage_nhanes = function (biomarkers) {

  #develop training dataset for modified KDM
  nhanes3 = NHANES_ALL %>%
    dplyr::filter(wave==0 & age >= 30 & age <= 75 & pregnant == 0)

  #femlae
  nhanes3_fem = nhanes3 %>%
    dplyr::filter(gender == 2) %>%
    dplyr::mutate_at(vars(biomarkers), funs(ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  #male
  nhanes3_male = nhanes3 %>%
    dplyr::filter(gender == 1) %>%
    dplyr::mutate_at(vars(biomarkers), funs(ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  #calculate training KDM
  train_fem = bioage_calc(nhanes3_fem, biomarkers, fit = NULL, s_ba2 = NULL)
  train_male = bioage_calc(nhanes3_male, biomarkers, fit = NULL, s_ba2 = NULL)

  #develop test dataset for KDM
  nhanes = NHANES_ALL %>%
    dplyr::filter(wave > 0 & wave < 11 & age >= 20)

  nhanes_fem = nhanes %>%
    dplyr::filter(gender == 2) %>%
    dplyr::mutate_at(vars(biomarkers), funs(ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  nhanes_male = nhanes %>%
    dplyr::filter(gender == 1) %>%
    dplyr::mutate_at(vars(biomarkers), funs(ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. <(mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .)))

  #calculate test modified KDM
  test_fem = bioage_calc(nhanes_fem, biomarkers, fit = train_fem$fit, s_ba2 = train_fem$fit$s_ba2)
  test_male = bioage_calc(nhanes_male, biomarkers, fit = train_male$fit, s_ba2 = train_male$fit$s_ba2)
  kdm = rbind(test_fem$data, test_male$data)

  #combine data
  dat = left_join(NHANES_ALL, kdm[,c("seqn", "year", "bioage", "bioage_advance", "bioage_residual")], by = c("seqn", "year"))
  fit = list(female = test_fem$fit, male = test_male$fit, nobs = test_fem$fit$nobs + test_male$fit$nobs)

  bioage = list(data = dat, fit = fit)
  class(bioage) = append(class(bioage), "bioage")
  return(bioage)

}
