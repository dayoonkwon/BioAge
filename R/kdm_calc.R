#builds a fomula
form = function(y,x){
  return(as.formula(paste0(y,'~',x)))
}

#helper function to get effects from linear models on biomarkers
get_effs = function(mod){
  #input model object
  #output is list of
  #intercept, rmse, rsqaure

  m = summary(mod)
  res = data.frame(q=coef(mod)['(Intercept)'],k=coef(mod)[2],s=NA,r=NA)
  if('glm' %in% attr(mod,'class')){
    #sd of residuals is the RMSE
    res$s = sd(mod$residuals)
    #calculate s=pseudo r-squared
    res$r = 1-(mod$deviance/mod$null.deviance)
  }else{
    res$s = m$sigma
    res$r = m$r.squared
  }

  return(res)
}

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
#' @importFrom survey svydesign

kdm_calc = function (data, biomarkers, fit = NULL, s_ba2 = NULL) {

  dat = data
  bm = biomarkers; rm(biomarkers)

  design=svydesign(id=~1,weights=~1,data=dat)

  if (is.null(fit)) {

    lm_age = lapply(bm,function(marker){
      survey::svyglm(form(marker,"age"),
             design=design,
             family=gaussian())
    })


    agev = do.call(rbind,lapply(lm_age,get_effs)) %>%
      mutate(bm = bm,
             r1=abs((k/s)*sqrt(r)),
             r2=abs(k/s),
             n2=(k/s)^2); rm(lm_age)

    age_range = range(dat$age, na.rm = TRUE)
    rchar = sum(agev$r1)/sum(agev$r2)
    s_r = ((1-(rchar^2))/(rchar^2))*(((age_range[2]-age_range[1])^2)/(12*nrow(agev)))

  }

  else {

    agev = fit$lm_age
    s_r = fit$s_r

  }
  #end dat conditional

  n1 = dat[,bm]

  for(m in colnames(n1)){
    row = which(agev$bm == m)
    obs = (dat[,m] - agev[row,'q'])*(agev[row,'k']/(agev[row,'s']^2))
    n1[,m]=(obs)
    }

  ba_nmiss = apply(n1,1,function(x) sum(is.na(x)))
  ba_obs = length(bm) - ba_nmiss
  BAe_n = rowSums(n1,na.rm=TRUE)
  BAe_d = sum(agev$n2,na.rm=TRUE)

  dat = dat %>%
    mutate(BA_eo = BAe_n/BAe_d,
           BA_e = (BA_eo/(ba_obs))*length(bm))

  dat$BA_CA = unlist(dat$BA_e - dat$age)
  t1 = (dat$BA_CA - mean(dat$BA_CA,na.rm=TRUE))^2
  s2=mean(t1,na.rm=TRUE)

  nobs = sum(!is.na(dat$BA_CA))

  if (is.null(s_ba2)) {

    s_ba2 = s2 - s_r

  }

  else {

    s_ba2 = s_ba2

  }

  dat$kdm = unlist((BAe_n + (dat$age/c(s_ba2)))/(BAe_d+(1/c(s_ba2))))
  dat$kdm = ifelse(ba_nmiss>2,NA,dat$kdm)
  dat$kdm_advance = dat$kdm - dat$age
  dat$BA_eo = NULL
  dat$BA_e = NULL
  dat$BA_CA = NULL

  fit = list(lm_age = agev, s_r = s_r, s_ba2 = s_ba2, s2 = s2, nobs = nobs)

  kdm = list(data = as.data.frame(dat), fit = fit)
  class(kdm) = append(class(kdm), "kdm")
  return(kdm)

}

