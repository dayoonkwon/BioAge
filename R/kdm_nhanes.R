#' Training KDM Biological Age algorithm using the NHANES III and projecting into NHANES IV dataset.
#'
#' @title kdm_nhanes
#' @description Train KDM algorithm in NHANES III and project into NHANES IV.
#' @param biomarkers A character vector indicating the names of the biomarkers included in the KDM Biological Age algorithm.
#' @return An object of class "kdm". This object is a list with two elements (data and fit). The dataset can be drawn by typing 'data'. The model can be drawn by typing 'fit'.
#' @examples
#' #KDM using NHANES
#' kdm = kdm_nhanes(biomarkers=c("fev","sbp","totchol","hba1c","albumin","creat","lncrp","alp","bun"))
#'
#' #Extract KDM dataset
#' data = kdm$data
#'
#'
#' @export
#' @import dplyr


kdm_nhanes = function (biomarkers) {

  #calculate training KDM
  train_fem = kdm_calc(data = NHANES3 %>%
                         filter(age >= 30 & age <= 75 & pregnant == 0, gender == 2),
                       biomarkers, fit = NULL, s_ba2 = NULL)
  train_male = kdm_calc(data = NHANES3 %>%
                          filter(age >= 30 & age <= 75 & pregnant == 0, gender == 1),
                        biomarkers, fit = NULL, s_ba2 = NULL)

  #calculate test modified KDM
  test_fem = kdm_calc(data = NHANES4 %>%
                        filter(gender == 2),
                      biomarkers, fit = train_fem$fit, s_ba2 = train_fem$fit$s_ba2)
  test_male = kdm_calc(data = NHANES4 %>%
                         filter(gender == 1),
                       biomarkers, fit = train_male$fit, s_ba2 = train_male$fit$s_ba2)

  #comebine calculated kdm
  test = rbind(test_fem$data, test_male$data)

  #combine data
  dat = left_join(NHANES4, test[,c("sampleID", "kdm", "kdm_advance")], by = "sampleID")
  fit = list(female = train_fem$fit, male = train_male$fit, nobs = test_fem$fit$nobs + test_male$fit$nobs)

  kdm = list(data = dat, fit = fit)
  class(kdm) = append(class(kdm), "kdm")
  return(kdm)

}
