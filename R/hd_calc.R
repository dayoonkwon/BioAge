#' Calculate HD
#'
#' @title hd_calc
#' @description Calculate homeostatic dysregulation (HD)
#' @param data The dataset for calculating HD
#' @param reference The reference dataset for calculating HD
#' @param biomarkers A character vector indicating the names of the variables for the biomarkers to use in calculating HD
#' @return An object of class "hd". This object is a list with two elements (data and fit)
#' @examples
#' #Calculate HD
#' hd = hd_calc(NHANES4, NHANES3,
#'              biomarkers=c("albumin_gL","lymph","mcv","glucose_mmol","rdw","creat_umol","lncrp","alp","wbc"))
#'
#' #Extract bioage dataset
#' data = hd$data
#'
#'
#' @export
#' @import dplyr

hd_calc = function(data, reference, biomarkers){

  ref = as.matrix(reference[, biomarkers])
  dat = as.matrix(data[, biomarkers])

  rm(reference); rm(biomarkers)

  #standardize variables by mean and sd of reference population
  for (j in 1:ncol(dat)){
    dat[,j] <- (dat[,j] - mean(ref[,j], na.rm = TRUE)) / sd(ref[,j], na.rm = TRUE)
  }

  for (j in 1:ncol(ref)){
    ref[,j] <- (ref[,j] - mean(ref[,j], na.rm = TRUE)) / sd(ref[,j], na.rm = TRUE)
  }

  dat = na.omit(dat)
  ref = na.omit(ref)

  if(nrow(ref) == 1){
    warning("The reference matrix must have more than one row")
  }

  else {

    means = colMeans(ref)
    cv_mat = var(ref)

  }

  if(nrow(dat) == 1){
    warning("The function does not work with single-row data")
  }

  else {

    dat = as.matrix(dat)
    hd = rep(NA, nrow(dat))

    for (x in 1:nrow(dat)){
      hd[x] <- sqrt((dat[x,] - means) %*% solve(cv_mat) %*% (dat[x,] - means))
    }

  }

  dat = data %>%
    select(sampleID,biomarkers) %>%
    na.omit()

  dat$hd = hd/sd(hd)
  dat$hd_log = log(hd)/sd(log(hd))
  nobs = sum(!is.na(dat$hd))

  dat = left_join(data, dat[,c("sampleID","hd","hd_log")], by = "sampleID")
  fit = list(mcov = means, cov_mat = cv_mat, nobs = nobs)
  hd = list(data = dat,fit = fit)

  class(hd) = append(class(hd),'hd')
  return(hd)

}
