#' Calculate Levine's Phenotypic Age using NHANES dataset
#'
#' @title phenoage_nhanes
#' @description Calculate Levine's Phenotypic Age using NHANES dataset
#' @param biomarkers A character vector indicating the names of the variables for the biomarkers to use in calculating phenoage
#' @return An object of class "phenoage". This object is a list with two elements (data and fit)
#' @examples
#' #Calculate phenoage
#' phenoage = phenoage_nhanes(biomarkers=c("albumin_gL","lymph","mcv","glucose_mmol",
#'                            "rdw","creat_umol","lncrp","alp","wbc"))
#'
#' #Extract phenoage dataset
#' data = phenoage$data
#'
#'
#' @export
#' @import dplyr


phenoage_nhanes = function(biomarkers) {

  #develop training dataset for Levine's phenoage method
  nhanes3 = NHANES_ALL %>%
    filter(wave == 0 & age >= 20 & age <= 84) %>%
    mutate(albumin = albumin_gL,
           glucose = glucose_mmol,
           creat = creat_umol,
           lncreat = lncreat_umol) %>%
    group_by(gender) %>%
    mutate_at(vars(biomarkers), list(~ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(. ,na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .))) %>%
    ungroup()

  train = phenoage_calc(nhanes3, age = "age", time = "permth_exm", status = "mortstat", biomarkers,fit=NULL)

  #develop test dataset for Levine's phenoage method
  nhanes = NHANES_ALL %>%
    filter(wave > 0 & wave < 11 & age >= 20) %>%
    mutate(albumin = albumin_gL,
           glucose = glucose_mmol,
           creat = creat_umol,
           lncreat = lncreat_umol) %>%
    group_by(gender) %>%
    mutate_at(vars(biomarkers), list(~ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE))) |
                                              (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .))) %>%
    ungroup()

  test = phenoage_calc(nhanes, age = "age", time = "permth_exm", status = "mortstat", biomarkers, fit=train$fit)

  #comebine calculated phenoage
  all = rbind(train$data,test$data)
  dat = left_join(NHANES_ALL, all[,c("seqn", "year", "phenoage", "phenoage_advance", "phenoage_residual")], by = c("seqn", "year"))

  phenoage = list(data = dat, fit = test$fit)
  class(phenoage) = append(class(phenoage), "phenoage")
  return(phenoage)


}
