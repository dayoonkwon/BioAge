#builds a formula
surv_form = function(x){

  return(as.formula(paste0("Surv(time,status)~", x)))

}


#' Projecting Phenotypic Age algorithm onto new data.
#'
#' @title phenoage_calc
#' @description Project Phenotypic Age algorithm onto new data.
#' @param data A projection dataset.
#' @param biomarkers A character vector indicating the names of the biomarkers included in the Phenotypic Age algorithm.
#' @param fit An S3 object for model fit. If the value is NULL, then the parameters to use for training Phenotypic Age are calculated.
#' @param orig TRUE to compute the origianl Phenotypic Age.
#' @return An object of class "phenoage". This object is a list with two elements (data and fit). The dataset can be drawn by typing 'data'. The model can be drawn by typing 'fit'.
#' @examples
#' #Train using the NHANES III
#' train = phenoage_calc(NHANES3,
#'                       biomarkers = c("albumin_gL","lymph","mcv","glucose_mmol",
#'                       "rdw","creat_umol","lncrp","alp","wbc"))
#'
#' #Project into the NHANES IV
#' phenoage = phenoage_calc(NHANES4,
#'                          biomarkers = c("albumin_gL","lymph","mcv","glucose_mmol",
#'                          "rdw","creat_umol","lncrp","alp","wbc"),
#'                          fit = train$fit)
#'
#' #Extract phenoage dataset
#' data = phenoage$data
#'
#'
#' @export
#' @importFrom flexsurv flexsurvreg


phenoage_calc = function (data, biomarkers, fit = NULL, orig = FALSE) {

  dat = data

  bm = c(biomarkers, "age")
  bm_dat = t(select(dat, bm))

  bm_name = paste(bm, collapse = "+")
  rm(biomarkers)

  #calculate  modified Levine's method
  if (is.null(fit)) {

    gom = flexsurvreg(surv_form(bm_name), data = dat, dist = "gompertz")
    coef = as.data.frame(gom$coefficients)
    colnames(coef) = "coef"
    rm(gom)

    n1 = bm_dat
    for (r in 1:nrow(n1)) {

      x = rownames(n1)[r]
      n1[r,] = (bm_dat[x,] * coef[x, "coef"])

    }

    rm(r); rm(x)
    xb = apply(n1, 2, sum) + coef[2,]

    m_n = -(exp(120 * coef[1,]) - 1)
    m_d = coef[1,]
    m = 1 - exp((m_n * exp(xb)) / m_d)

    gom_age = flexsurvreg(surv_form("age"), data = dat, dist="gompertz")
    coef_age = as.data.frame(gom_age$coefficients)
    colnames(coef_age) = "coef"
    rm(gom_age)

    BA_d = coef_age[3,]
    BA_n = -coef_age[1,]
    BA_i = (-log(exp(coef_age[1,] * 120) - 1) -coef_age[2,]) / coef_age[3,]

  }

  else {

    coef = fit$coef
    m_n = fit$m_n
    m_d = fit$m_d
    BA_n = fit$BA_n
    BA_d = fit$BA_d
    BA_i = fit$BA_i

    n1 = bm_dat
    for (r in 1:nrow(n1)) {
      x = rownames(n1)[r]
      n1[r,] = (bm_dat[x,] * coef[x,"coef"])

    }

    rm(r); rm(x)

    xb = apply(n1, 2, sum) + coef[2,]
    m = 1 - exp((m_n * exp(xb)) / m_d)

  }

  if (orig == TRUE) {

    xb_orig = -19.90667 + (-0.03359355 * dat$albumin_gL) + (0.009506491 * dat$creat_umol) + (0.1953192 * dat$glucose_mmol) +
      (0.09536762 * dat$lncrp) + (-0.01199984 * dat$lymph) + (0.02676401 * dat$mcv) + (0.3306156 * dat$rdw)+
      (0.001868778 * dat$alp) + (0.05542406 * dat$wbc) + (0.08035356 * dat$age)

    m_orig = 1 - (exp((-1.51714 * exp(xb_orig)) / 0.007692696))

    dat$phenoage0 = ((log(-.0055305 * (log(1 - m_orig))) / .090165) + 141.50225)
    dat$phenoage_advance0 = dat$phenoage0 - dat$age

  }

  dat$phenoage = ((log(BA_n * (log(1 - m))) / BA_d) + BA_i); nobs = sum(!is.na(dat$phenoage))
  dat$phenoage_advance = dat$phenoage - dat$age

  fit = list(coef = coef, m_n = m_n, m_d = m_d, BA_n = BA_n, BA_d = BA_d, BA_i = BA_i, nobs=nobs)

  phenoage = list(data = as.data.frame(dat), fit = fit)
  class(phenoage) = append(class(phenoage), "phenoage")
  return(phenoage)

}
