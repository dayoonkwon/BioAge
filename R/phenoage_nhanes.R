#' Training Phenotypic Age algorithm using the NHANES III and projecting into NHANES IV dataset.
#'
#' @title phenoage_nhanes
#' @description Train Phenotypic Age algorithm in NHANES III and project into NHANES IV.
#' @param biomarkers A character vector indicating the names of the biomarkers included in the Phenotypic Age algorithm.
#' @return An object of class "phenoage". This object is a list with two elements (data and fit). The dataset can be drawn by typing 'data'. The model can be drawn by typing 'fit'.
#' @examples
#' #Phenoage using NHANES
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
  train = phenoage_calc(data = NHANES3 %>%
                          filter(age >= 20 & age <= 84) %>%
                          mutate(albumin = albumin_gL,
                                 glucose = glucose_mmol,
                                 creat = creat_umol,
                                 lncreat = lncreat_umol),
                        biomarkers, fit=NULL)

  #develop test dataset for Levine's phenoage method
  test = phenoage_calc(data = NHANES4 %>%
                         filter(age >= 20) %>%
                         mutate(albumin = albumin_gL,
                                glucose = glucose_mmol,
                                creat = creat_umol,
                                lncreat = lncreat_umol),
                       biomarkers, fit=train$fit)

  #comebine calculated phenoage
  dat = left_join(NHANES4, test$data[,c("sampleID", "phenoage", "phenoage_advance")], by = "sampleID")

  phenoage = list(data = dat, fit = train$fit)
  class(phenoage) = append(class(phenoage), "phenoage")
  return(phenoage)


}
