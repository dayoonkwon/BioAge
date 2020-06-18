#' Projecting KDM algorithm onto new data.
#'
#' @title kdm_calc
#' @description Project KDM algorithm onto new data.
#' @param data A projection dataset.
#' @param biomarkers A character vector indicating the names of the biomarkers included in the KDM Biological Age algorithm.
#' @param fit An S3 object for model fit. If the value is NULL, then the parameters to use for training KDM Biological Age are calculated.
#' @param s_ba2 A particular fit parameter. Advanced users can modify this parameter to control the variance of KDM Biological Age. If left NULL, defaults are used.
#' @return An object of class "kdm". This object is a list with two elements (data and fit). The dataset can be drawn by typing 'data'. The model can be drawn by typing 'fit'.
#' @examples
#' #Train using the NHANES III
#' train = kdm_calc(NHANES3,
#'                  biomarkers = c("fev","sbp","totchol","hba1c","albumin",
#'                  "creat","lncrp","alp","bun"))
#'
#' #Project into the NHANES IV
#' kdm = kdm_calc(NHANES4,
#'                biomarkers = c("fev","sbp","totchol","hba1c","albumin",
#'                "creat","lncrp","alp","bun"),
#'                fit = train$fit,
#'                s_ba2 = train$fit$s_ba2)
#'
#' #Extract KDM dataset
#' data = kdm$data
#'
#'
#' @export
#' @import dplyr

kdm_calc = function (data, biomarkers, fit = NULL, s_ba2 = NULL) {

  dat = data
  bm = biomarkers
  bm_dat = t(select(dat, bm))

  rm(biomarkers)

  if (is.null(fit)) {

    lm_age = t(apply(bm_dat, 1, function(x) {
      sm = summary(lm(x ~ dat$age))
      return(c(sm$sigma, sm$r.sq, sm$coef[1,1], sm$coef[2,]))

    }))

    colnames(lm_age) <- c("RMSE", "r_squared", "B_intercept", "B_age", "se(B)_age", "T_val_age", "pval_age")
    lm_age <- as.data.frame(lm_age)

    lm_age$r1 = abs((lm_age$B_age / lm_age$RMSE) * sqrt(lm_age$r_squared))
    lm_age$r2 = abs((lm_age$B_age / lm_age$RMSE))
    lm_age$n2 = (lm_age$B_age / lm_age$RMSE) * (lm_age$B_age / lm_age$RMSE)

    age_range = range(dat$age, na.rm = TRUE)
    rchar = sum(lm_age$r1) / sum(lm_age$r2)
    s_r = ((1 - (rchar * rchar)) / (rchar * rchar) * (((age_range[2] - age_range[1]) ^ 2) / (nrow(lm_age) * 12)))

  }

  else {

    lm_age = fit$lm_age
    s_r = fit$s_r

  }
  #end dat conditional

  n1 = bm_dat
  for (r in 1:nrow(n1)) {

    x = rownames(n1)[r]
    n1[r,] = ((bm_dat[x,] - lm_age[x,"B_intercept"]) * (lm_age[x,"B_age"] / (lm_age[x,"RMSE"] * lm_age[x,"RMSE"])))

  }

  rm(r); rm(x)

  BAe_n = apply(n1, 2, sum); rm(n1)
  BAe_d = sum(lm_age$n2)

  BAe = BAe_n / BAe_d
  BA_CA = BAe - dat$age

  s2 = sd(BA_CA, na.rm = TRUE) ^ 2
  nobs = sum(!is.na(BA_CA))

  if (is.null(s_ba2)) {

    s_ba2 = s2 - s_r

  }

  else {

    s_ba2 = s_ba2

  }

  dat$kdm = ((BAe_n) + (dat$age / (s_ba2))) / ((BAe_d) + (1 / (s_ba2)))
  dat$kdm_advance = dat$kdm - dat$age

  fit = list(lm_age = lm_age, s_r = s_r, s_ba2 = s_ba2, s2 = s2, nobs = nobs)

  kdm = list(data = as.data.frame(dat), fit = fit)
  class(kdm) = append(class(kdm), "kdm")
  return(kdm)

}

