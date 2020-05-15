#' Calculate Klemera-Doubal Method Biological Age
#'
#' @title bioage_calc
#' @description Calculate Klemera-Doubal Method Biological Age
#' @param data The dataset for calculating bioage
#' @param age A character vector (length=1) indicating the name of the variable for age
#' @param biomarkers A character vector indicating the names of the variables for the biomarkers to use in calculating bioage
#' @param fit An S3 object for model fit. If the value is NULL, then the parameters to use for training bioage are calculated
#' @param s_ba2 A particular fit parameter. Advanced users can modify this parameter to control the variance of bioage
#' @return An object of class "bioage". This object is a list with two elements (data and fit)
#' @examples
#' #Train KDM bioage parameters
#' train = bioage_calc(nhanes3,age="age",
#'                  biomarkers=c("fev","sbp","totchol","hba1c","albumin","creat","lncrp","alp","bun"))
#'
#' #Use training data to calculate KDM bioage
#' bioage = bioage_calc(nhanes,age="age",
#'                        biomarkers=c("fev","sbp","totchol","hba1c","albumin","creat","lncrp","alp","bun"),
#'                        fit=train$fit,
#'                        s_ba2=train$fit$s_ba2)
#'
#' #Extract bioage dataset
#' data = bioage$data
#'
#'
#' @export


bioage_calc = function (data, age, biomarkers, fit = NULL, s_ba2 = NULL) {

  dat = data
  dat$age = unlist(dat[, age])
  bm = biomarkers
  bm_dat = t(select(dat, bm))

  rm(age); rm(biomarkers)

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

  dat$bioage = ((BAe_n) + (dat$age / (s_ba2))) / ((BAe_d) + (1 / (s_ba2)))
  dat$bioage_advance = dat$bioage - dat$age
  dat$bioage_residual = residuals(lm(bioage ~ age, data = dat, na.action = "na.exclude"))

  fit = list(lm_age = lm_age, s_r = s_r, s_ba2 = s_ba2, s2 = s2, nobs = nobs)

  bioage = list(data = dat, fit = fit)
  class(bioage) = append(class(bioage), "bioage")
  return(bioage)

}

