## code to prepare `DATASET` dataset goes here
library(RNHANES)
library(plyr)
library(dplyr)

# NHANES 1999-2018 --------------------------------------------------------
#Demographic
DEMO <- nhanes_load_data(c("DEMO","DEMO_B","DEMO_C","DEMO_D","DEMO_E","DEMO_F","DEMO_G","DEMO_H","DEMO_I","DEMO_J"),
                         c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#Activities of daily livings
PFQ <- nhanes_load_data(c("PFQ","PFQ_B","PFQ_C","PFQ_D","PFQ_E","PFQ_F","PFQ_G","PFQ_H","PFQ_I","PFQ_J"),
                        c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#BMI
BMI <- nhanes_load_data(c("BMX","BMX_B","BMX_C","BMX_D","BMX_E","BMX_F","BMX_G","BMX_H","BMX_I","BMX_J"),
                        c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#Body Fat
BIX <- nhanes_load_data(c("BIX","BIX_B","BIX_C"),
                        c("1999-2000","2001-2002","2003-2004"))
#FEV1
SPX <- nhanes_load_data(c("SPX_E","SPX_F","SPX_G"),
                        c("2007-2008","2009-2010","2011-2012"))
#Grip strength
MGX <- nhanes_load_data(c("MGX_G","MGX_H"),
                        c("2011-2012","2013-2014"))
#Self-rated health
HSQ <- nhanes_load_data(c("HSQ_B","HSQ_C","HSQ_D","HSQ_E","HSQ_F","HSQ_G","HSQ_H","HSQ_I","HSQ_J"),
                        c("2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#Walk speed
MSX <- nhanes_load_data(c("MSX","MSX_B"),
                        c("1999-2000","2001-2002"))
#VO2 max
CVX <- nhanes_load_data(c("CVX","CVX_B","CVX_C"),
                        c("1999-2000","2001-2002","2003-2004"))
#Albumin
SGL <- nhanes_load_data(c("LAB18","L40_B","L40_C","BIOPRO_D","BIOPRO_E","BIOPRO_F","BIOPRO_G","BIOPRO_H","BIOPRO_I","BIOPRO_J"),
                        c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#BAP
BAP <- nhanes_load_data(c("LAB11","L11_B","L11_C"),
                        c("1999-2000","2001-2002","2003-2004"))
#Basophils
WBC <- nhanes_load_data(c("LAB25","L25_B","L25_C","CBC_D","CBC_E","CBC_F","CBC_G","CBC_H","CBC_I","CBC_J"),
                        c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#Cadmium
CAD <- nhanes_load_data(c("LAB06","L06_B","L06BMT_C","PbCd_D","PbCd_E","PbCd_F","PbCd_G","PBCD_H","PBCD_I"),
                        c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016"))
#CRP
CRP <- nhanes_load_data(c("LAB11","L11_B","L11_C","CRP_D","CRP_E","CRP_F","HSCRP_I","HSCRP_J"),
                        c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2015-2016","2017-2018"))
#Cystatin C
CYS <- nhanes_load_data(c("SSCYST_A","SSCYST_B"),
                        c("1999-2000","2001-2002"))
#Blood pressure
BPX <- nhanes_load_data(c("BPX","BPX_B","BPX_C","BPX_D","BPX_E","BPX_F","BPX_G","BPX_H","BPX_I","BPX_J"),
                        c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#Gamma glutamyl transferase
GGT <- nhanes_load_data(c("L40_2_B","L40_C","BIOPRO_D","BIOPRO_E","BIOPRO_F","BIOPRO_G","BIOPRO_H","BIOPRO_I","BIOPRO_J"),
                        c("2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#Plasma fasting glucose
GLU <- nhanes_load_data(c("LAB10AM","L10AM_B","L10AM_C","GLU_D","GLU_E","GLU_F","GLU_G","GLU_H","INS_H","GLU_I","INS_I"),
                         c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2013-2014","2015-2016","2015-2016"))
#Fasting
PHH <- nhanes_load_data(c("PH","PH_B","PH_C","FASTQX_D","FASTQX_E","FASTQX_F","FASTQX_G","FASTQX_H","FASTQX_I","FASTQX_J"),
                        c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#Hba1c
HBA <- nhanes_load_data(c("LAB10","L10_B","L10_C","GHB_D","GHB_E","GHB_F","GHB_G","GHB_H","GHB_I","GHB_J"),
                        c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#HDL
HDLchol <- nhanes_load_data(c("LAB13","L13_B","L13_C","HDL_D","HDL_E","HDL_F","HDL_G","HDL_H","HDL_I","HDL_J"),
                            c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#LDL
TRI <- nhanes_load_data(c("LAB13AM","L13AM_B","L13AM_C","TRIGLY_D","TRIGLY_E","TRIGLY_F","TRIGLY_G","TRIGLY_H","TRIGLY_I"),
                        c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016"))
#Total cholesterol
CHL <- nhanes_load_data(c("Lab13","l13_b","l13_c","TCHOL_D","TCHOL_E","TCHOL_F","TCHOL_G","TCHOL_H","TCHOL_I","TCHOL_J"),
                        c("1999-2000","2001-2002","2003-2004","2005-2006","2007-2008","2009-2010","2011-2012","2013-2014","2015-2016","2017-2018"))
#Vitamin A
VITA <- nhanes_load_data(c("LAB06","L06VIT_B","L45VIT_C","VITAEC_D"),
                         c("1999-2000","2001-2002","2003-2004","2005-2006"))
#Vitamin B
VITAB <- nhanes_load_data(c("LAB06","L06_B","L06NB_C","B12_D","VITB12_G","VITB12_H"),
                          c("1999-2000","2001-2002","2003-2004","2005-2006","2011-2012","2013-2014"))
#Vitamin C
VITAC <- nhanes_load_data(c("L06VIT_C","VIC_D"),
                          c("2003-2004","2005-2006"))

# Demographic -------------------------------------------------------------
Demo_1999 <-select(DEMO$DEMO,SEQN,RIAGENDR,RIDAGEYR,RIDRETH1,DMDEDUC2,INDFMPIR,RIDEXPRG,INDFMINC)
#Adding a dummy variable to hold sample wave
Demo_1999 <- mutate(Demo_1999,WAVE=1,YEAR=1999)

Demo_2001 <- select(DEMO$DEMO_B,SEQN,RIAGENDR,RIDAGEYR,RIDRETH1,DMDEDUC2,INDFMPIR,RIDEXPRG,INDFMINC)
Demo_2001 <- mutate(Demo_2001,WAVE=2,YEAR=2001)

Demo_2003 <- select(DEMO$DEMO_C,SEQN,RIAGENDR,RIDAGEYR,RIDRETH1,DMDEDUC2,INDFMPIR,RIDEXPRG,INDFMINC)
Demo_2003 <- mutate(Demo_2003,WAVE=3,YEAR=2003)

Demo_2005 <- select(DEMO$DEMO_D,SEQN,RIAGENDR,RIDAGEYR,RIDRETH1,DMDEDUC2,INDFMPIR,RIDEXPRG,INDFMINC)
Demo_2005 <- mutate(Demo_2005,WAVE=4,YEAR=2005)

Demo_2007 <- select(DEMO$DEMO_E,SEQN,RIAGENDR,RIDAGEYR,RIDRETH1,DMDEDUC2,INDFMPIR,RIDEXPRG,INDFMIN2)
Demo_2007 <- mutate(Demo_2007,WAVE=5,YEAR=2007)

Demo_2009 <- select(DEMO$DEMO_F,SEQN,RIAGENDR,RIDAGEYR,RIDRETH1,DMDEDUC2,INDFMPIR,RIDEXPRG,INDFMIN2)
Demo_2009 <- mutate(Demo_2009,WAVE=6,YEAR=2009)

Demo_2011 <- select(DEMO$DEMO_G,SEQN,RIAGENDR,RIDAGEYR,RIDRETH1,DMDEDUC2,INDFMPIR,RIDEXPRG,INDFMIN2)
Demo_2011 <- mutate(Demo_2011, WAVE=7,YEAR=2011)

Demo_2013 <- select(DEMO$DEMO_H,SEQN,RIAGENDR,RIDAGEYR,RIDRETH1,DMDEDUC2,INDFMPIR,RIDEXPRG,INDFMIN2)
Demo_2013 <- mutate(Demo_2013, WAVE=8,YEAR=2013)

Demo_2015 <- select(DEMO$DEMO_I,SEQN,RIAGENDR,RIDAGEYR,RIDRETH1,DMDEDUC2,INDFMPIR,RIDEXPRG,INDFMIN2)
Demo_2015 <- mutate(Demo_2015,WAVE=9,YEAR=2015)

Demo_2017 <- select(DEMO$DEMO_J,SEQN,RIAGENDR,RIDAGEYR,RIDRETH1,DMDEDUC2,INDFMPIR,RIDEXPRG,INDFMIN2)
Demo_2017 <- mutate(Demo_2017,WAVE=10,YEAR=2017)

colnames(Demo_1999) <- colnames(Demo_2007)
colnames(Demo_2001) <- colnames(Demo_2007)
colnames(Demo_2003) <- colnames(Demo_2007)
colnames(Demo_2005) <- colnames(Demo_2007)

#Combining demographics into one dataframe for all waves
Demographics_ALL <- bind_rows(Demo_1999,Demo_2001,Demo_2003,Demo_2005,Demo_2007,Demo_2009,Demo_2011,Demo_2013,Demo_2015,Demo_2017)
Demographics_ALL <- transmute(Demographics_ALL,seqn=SEQN,year=YEAR,wave=WAVE,gender=RIAGENDR,age=RIDAGEYR,annual_income=INDFMIN2,education=DMDEDUC2,RIDRETH1=RIDRETH1,poverty_ratio=INDFMPIR,pregnant=RIDEXPRG)

head(Demographics_ALL)
summary(Demographics_ALL)

#Recoding pregnancy variable to be nonpregnant for all men and for individuals of uncertain pregnancy status
Demographics_ALL$pregnant[Demographics_ALL$pregnant==3] <- 0
Demographics_ALL$pregnant[is.na(Demographics_ALL$pregnant)] <- 0
Demographics_ALL$pregnant[Demographics_ALL$pregnant==2] <- 0

#Recoding missing or nonresponse indicators to NA
Demographics_ALL$education[Demographics_ALL$education==7] <- NA
Demographics_ALL$education[Demographics_ALL$education==9] <- NA
Demographics_ALL$annual_income[Demographics_ALL$annual_income==77] <- NA
Demographics_ALL$annual_income[Demographics_ALL$annual_income==99] <- NA
Demographics_ALL$annual_income[Demographics_ALL$annual_income==12] <- NA
Demographics_ALL$annual_income[Demographics_ALL$annual_income==13] <- NA
Demographics_ALL$annual_income[Demographics_ALL$annual_income==14|Demographics_ALL$annual_income==15] <- 11

Demographics_ALL$income_recode=Demographics_ALL$annual_income
Demographics_ALL$income_recode[Demographics_ALL$annual_income>8] <- 8

#Recoding education
Demographics_ALL$edu[Demographics_ALL$education==1|Demographics_ALL$education==2] <- 1 #<high school
Demographics_ALL$edu[Demographics_ALL$education==3] <- 2 #high school graduate
Demographics_ALL$edu[Demographics_ALL$education==4] <- 3 #some college
Demographics_ALL$edu[Demographics_ALL$education==5] <- 4 #bachelor's degree or higher

#Recoding ethnicity
Demographics_ALL$ethnicity[Demographics_ALL$RIDRETH1==3] <-1 #non-hispanic white
Demographics_ALL$ethnicity[Demographics_ALL$RIDRETH1==4] <-2 #non-hispanic black
Demographics_ALL$ethnicity[Demographics_ALL$RIDRETH1==1|Demographics_ALL$RIDRETH1==2] <-3 #mexian american
Demographics_ALL$ethnicity[Demographics_ALL$RIDRETH1==5] <-4 #other

Demographics_ALL$race = Demographics_ALL$ethnicity
Demographics_ALL$race[Demographics_ALL$race==3|Demographics_ALL$race==4] <-3 #hispanic and other

#Select variables
Demographics_ALL <- select(Demographics_ALL,seqn,year,wave,gender,age,annual_income,income_recode,education,edu,ethnicity,race,poverty_ratio,pregnant)
head(Demographics_ALL)
summary(Demographics_ALL)

# Activities of daily livings ---------------------------------------------
PFQ_1999 <- select(PFQ$PFQ,SEQN,PFQ060A,PFQ060B,PFQ060C,PFQ060D,PFQ060E,PFQ060F,PFQ060G,PFQ060H,PFQ060I,PFQ060J,PFQ060K,PFQ060L,PFQ060M,PFQ060N,PFQ060O,PFQ060P,PFQ060Q,PFQ060R,PFQ060S)
PFQ_2001 <- select(PFQ$PFQ_B,SEQN,PFQ060A,PFQ060B,PFQ060C,PFQ060D,PFQ060E,PFQ060F,PFQ060G,PFQ060H,PFQ060I,PFQ060J,PFQ060K,PFQ060L,PFQ060M,PFQ060N,PFQ060O,PFQ060P,PFQ060Q,PFQ060R,PFQ060S)
PFQ_2003 <- select(PFQ$PFQ_C,SEQN,PFQ061A,PFQ061B,PFQ061C,PFQ061D,PFQ061E,PFQ061F,PFQ061G,PFQ061H,PFQ061I,PFQ061J,PFQ061K,PFQ061L,PFQ061M,PFQ061N,PFQ061O,PFQ061P,PFQ061Q,PFQ061R,PFQ061S)
PFQ_2005 <- select(PFQ$PFQ_D,SEQN,PFQ061A,PFQ061B,PFQ061C,PFQ061D,PFQ061E,PFQ061F,PFQ061G,PFQ061H,PFQ061I,PFQ061J,PFQ061K,PFQ061L,PFQ061M,PFQ061N,PFQ061O,PFQ061P,PFQ061Q,PFQ061R,PFQ061S)
PFQ_2007 <- select(PFQ$PFQ_E,SEQN,PFQ061A,PFQ061B,PFQ061C,PFQ061D,PFQ061E,PFQ061F,PFQ061G,PFQ061H,PFQ061I,PFQ061J,PFQ061K,PFQ061L,PFQ061M,PFQ061N,PFQ061O,PFQ061P,PFQ061Q,PFQ061R,PFQ061S)
PFQ_2009 <- select(PFQ$PFQ_F,SEQN,PFQ061A,PFQ061B,PFQ061C,PFQ061D,PFQ061E,PFQ061F,PFQ061G,PFQ061H,PFQ061I,PFQ061J,PFQ061K,PFQ061L,PFQ061M,PFQ061N,PFQ061O,PFQ061P,PFQ061Q,PFQ061R,PFQ061S)
PFQ_2011 <- select(PFQ$PFQ_G,SEQN,PFQ061A,PFQ061B,PFQ061C,PFQ061D,PFQ061E,PFQ061F,PFQ061G,PFQ061H,PFQ061I,PFQ061J,PFQ061K,PFQ061L,PFQ061M,PFQ061N,PFQ061O,PFQ061P,PFQ061Q,PFQ061R,PFQ061S)
PFQ_2013 <- select(PFQ$PFQ_H,SEQN,PFQ061A,PFQ061B,PFQ061C,PFQ061D,PFQ061E,PFQ061F,PFQ061G,PFQ061H,PFQ061I,PFQ061J,PFQ061K,PFQ061L,PFQ061M,PFQ061N,PFQ061O,PFQ061P,PFQ061Q,PFQ061R,PFQ061S)
PFQ_2015 <- select(PFQ$PFQ_I,SEQN,PFQ061A,PFQ061B,PFQ061C,PFQ061D,PFQ061E,PFQ061F,PFQ061G,PFQ061H,PFQ061I,PFQ061J,PFQ061K,PFQ061L,PFQ061M,PFQ061N,PFQ061O,PFQ061P,PFQ061Q,PFQ061R,PFQ061S)
PFQ_2017 <- select(PFQ$PFQ_J,SEQN,PFQ061A,PFQ061B,PFQ061C,PFQ061D,PFQ061E,PFQ061F,PFQ061G,PFQ061H,PFQ061I,PFQ061J,PFQ061K,PFQ061L,PFQ061M,PFQ061N,PFQ061O,PFQ061P,PFQ061Q,PFQ061R,PFQ061S)

colnames(PFQ_1999) <- colnames(PFQ_2003)
colnames(PFQ_2001) <- colnames(PFQ_2003)

PFQ_ALL <- bind_rows(PFQ_1999,PFQ_2001,PFQ_2003,PFQ_2005,PFQ_2007,PFQ_2009,PFQ_2011,PFQ_2013,PFQ_2015,PFQ_2017)
PFQ_ALL <- PFQ_ALL %>%
  mutate_at(vars(PFQ061A,PFQ061B,PFQ061C,PFQ061D,PFQ061E,PFQ061F,PFQ061G,PFQ061H,PFQ061I,PFQ061J,PFQ061K,PFQ061L,PFQ061M,PFQ061N,PFQ061O,PFQ061P,PFQ061Q,PFQ061R,PFQ061S),list(~ifelse(.>=7,NA,.))) %>%
  mutate_at(vars(PFQ061A,PFQ061B,PFQ061C,PFQ061D,PFQ061E,PFQ061F,PFQ061G,PFQ061H,PFQ061I,PFQ061J,PFQ061K,PFQ061L,PFQ061M,PFQ061N,PFQ061O,PFQ061P,PFQ061Q,PFQ061R,PFQ061S),list(~ifelse(.==1,0,1))) %>%
  mutate(seqn=SEQN,adl=rowSums(.[2:20])) %>%
  select(seqn,adl)

head(PFQ_ALL)
dim(PFQ_ALL)

# BMI ---------------------------------------------------------------------
BMI_1999 <- select(BMI$BMX,SEQN,BMXBMI,BMXWT,BMXHT,BMXWAIST)
BMI_2001 <- select(BMI$BMX_B,SEQN,BMXBMI,BMXWT,BMXHT,BMXWAIST)
BMI_2003 <- select(BMI$BMX_C,SEQN,BMXBMI,BMXWT,BMXHT,BMXWAIST)
BMI_2005 <- select(BMI$BMX_D,SEQN,BMXBMI,BMXWT,BMXHT,BMXWAIST)
BMI_2007 <- select(BMI$BMX_E,SEQN,BMXBMI,BMXWT,BMXHT,BMXWAIST)
BMI_2009 <- select(BMI$BMX_F,SEQN,BMXBMI,BMXWT,BMXHT,BMXWAIST)
BMI_2011 <- select(BMI$BMX_G,SEQN,BMXBMI,BMXWT,BMXHT,BMXWAIST)
BMI_2013 <- select(BMI$BMX_H,SEQN,BMXBMI,BMXWT,BMXHT,BMXWAIST)
BMI_2015 <- select(BMI$BMX_I,SEQN,BMXBMI,BMXWT,BMXHT,BMXWAIST)
BMI_2017 <- select(BMI$BMX_J,SEQN,BMXBMI,BMXWT,BMXHT,BMXWAIST)

BMI_ALL <- bind_rows(BMI_1999,BMI_2001,BMI_2003,BMI_2005,BMI_2007,BMI_2009,BMI_2011,BMI_2013,BMI_2015,BMI_2017)
BMI_ALL <- transmute(BMI_ALL,seqn=SEQN,bmi=BMXBMI,height=BMXHT,waist=BMXWAIST,weight=BMXWT)

head(BMI_ALL)
summary(BMI_ALL)

# Body Fat ----------------------------------------------------------------
BIX_1999 <- select(BIX$BIX,SEQN,BIDFFM,BIDFAT,BIDPFAT)
BIX_2001 <- select(BIX$BIX_B,SEQN,BIDFFM,BIDFAT,BIDPFAT)
BIX_2003 <- select(BIX$BIX_C,SEQN,BIDFFM,BIDFAT,BIDPFAT)

BIX_ALL <- bind_rows(BIX_1999,BIX_2001,BIX_2003)
BIX_ALL <- transmute(BIX_ALL,seqn=SEQN,btotpf=BIDPFAT,ffm=BIDFFM,fm=BIDFAT)

head(BIX_ALL)
summary(BIX_ALL)

# FEV1 --------------------------------------------------------------------
SPX_2007 <- select(SPX$SPX_E,SEQN,SPXNFEV1,SPXBFEV1)
SPX_2009 <- select(SPX$SPX_F,SEQN,SPXNFEV1,SPXBFEV1)
SPX_2011 <- select(SPX$SPX_G,SEQN,SPXNFEV1,SPXBFEV1)

SPX_ALL <- bind_rows(SPX_2007,SPX_2009,SPX_2011) %>%
  mutate(fev=ifelse(!is.na(SPXBFEV1),(SPXNFEV1+SPXBFEV1)/2,SPXNFEV1),
         fev_1000=fev/1000,
         seqn=SEQN) %>%
  select(seqn,fev,fev_1000)

head(SPX_ALL)
summary(SPX_ALL)

# Grip strength -----------------------------------------------------------
MGX_2001 <- select(MGX$MGX_G,SEQN,MGD130,MGATHAND,MGXH1T1,MGXH1T2,MGXH1T3,MGXH2T1,MGXH2T2,MGXH2T3)
MGX_2003 <- select(MGX$MGX_H,SEQN,MGD130,MGATHAND,MGXH1T1,MGXH1T2,MGXH1T3,MGXH2T1,MGXH2T2,MGXH2T3)

MGX_ALL <- bind_rows(MGX_2001,MGX_2003)
MGX_ALL$grip_r <- ifelse(MGX_ALL$MGATHAND==1,rowMeans(MGX_ALL[,4:6],na.rm=TRUE),rowMeans(MGX_ALL[,7:9],na.rm=TRUE))
MGX_ALL$grip_l <- ifelse(MGX_ALL$MGATHAND==2,rowMeans(MGX_ALL[,4:6],na.rm=TRUE),rowMeans(MGX_ALL[,7:9],na.rm=TRUE))
MGX_ALL$grip_d <- ifelse(MGX_ALL$MGD130==1,MGX_ALL$grip_r,MGX_ALL$grip_l)
MGX_ALL$grip_d <- ifelse(MGX_ALL$MGD130==3,(MGX_ALL$grip_r+MGX_ALL$grip_l)/2,MGX_ALL$grip_d)
MGX_ALL <- select(MGX_ALL,seqn=SEQN,grip_r,grip_l,grip_d)

MGX_ALL$grip_r[MGX_ALL$grip_r=="NaN"]<-NA
MGX_ALL$grip_l[MGX_ALL$grip_l=="NaN"]<-NA
MGX_ALL$grip_d[MGX_ALL$grip_d=="NaN"]<-NA

MGX_ALL <- full_join(Demographics_ALL,MGX_ALL,by="seqn")
MGX_ALL <- filter(MGX_ALL,!is.na(grip_r)&!is.na(grip_l)&!is.na(grip_d))
library(standardize)
MGX_ALL$grip_scaled <- scale_by(MGX_ALL$grip_d~MGX_ALL$gender)
MGX_ALL <- select(MGX_ALL,seqn,grip_r,grip_l,grip_d,grip_scaled)

head(MGX_ALL)
summary(MGX_ALL)

# Self-rated health -------------------------------------------------------
HSQ_2001 <- select(HSQ$HSQ_B,SEQN,HSD010)
HSQ_2003 <- select(HSQ$HSQ_C,SEQN,HSD010)
HSQ_2005 <- select(HSQ$HSQ_D,SEQN,HSD010)
HSQ_2007 <- select(HSQ$HSQ_E,SEQN,HSD010)
HSQ_2009 <- select(HSQ$HSQ_F,SEQN,HSD010)
HSQ_2011 <- select(HSQ$HSQ_G,SEQN,HSD010)
HSQ_2013 <- select(HSQ$HSQ_H,SEQN,HSD010)
HSQ_2015 <- select(HSQ$HSQ_I,SEQN,HSD010)
HSQ_2017 <- select(HSQ$HSQ_J,SEQN,HSD010)

HSQ_ALL <- bind_rows(HSQ_2001,HSQ_2003,HSQ_2005,HSQ_2007,HSQ_2009,HSQ_2011,HSQ_2013,HSQ_2015,HSQ_2017)
HSQ_ALL <- transmute(HSQ_ALL,seqn=SEQN,health=HSD010)

HSQ_ALL$health[HSQ_ALL$health==7]<-NA
HSQ_ALL$health[HSQ_ALL$health==9]<-NA

head(HSQ_ALL)
table(HSQ_ALL$health,useNA="ifany")

# Walk speed --------------------------------------------------------------
MSX_1999 <- select(MSX$MSX,SEQN,MSXWTIME)
MSX_2001 <- select(MSX$MSX_B,SEQN,MSXW20TM)
colnames(MSX_2001) <- colnames(MSX_1999)

MSX_ALL <- bind_rows(MSX_1999,MSX_2001)
MSX_ALL$MSXWTIME <- log(MSX_ALL$MSXWTIME)
MSX_ALL <- transmute(MSX_ALL,seqn=SEQN,lnwalk=MSXWTIME)

head(MSX_ALL)
summary(MSX_ALL)

# VO2 max -----------------------------------------------------------------
CVX_1999 <- select(CVX$CVX,SEQN,CVDESVO2)
CVX_2001 <- select(CVX$CVX_B,SEQN,CVDESVO2)
CVX_2003 <- select(CVX$CVX_C,SEQN,CVDESVO2)
CVX_ALL <- bind_rows(CVX_1999,CVX_2001,CVX_2003)
CVX_ALL <- transmute(CVX_ALL,seqn=SEQN,vomeas=CVDESVO2)

head(CVX_ALL)
summary(CVX_ALL)

# Albumin -----------------------------------------------------------------
SGL_1999 <- select(SGL$LAB18,SEQN,LBXSGL,LBXSTB,LBXSAL,LBXSCR,LBXSBU,LBXSUA,LBXSAPSI)
SGL_1999 <- mutate(SGL_1999,LBXSCR=(1.013*LBXSCR+0.147))
SGL_2001 <- select(SGL$L40_B,SEQN,LBXSGL,LBDSTB,LBXSAL,LBDSCR,LBXSBU,LBXSUA,LBDSAPSI)
colnames(SGL_2001) <- colnames(SGL_1999)
SGL_2003 <- select(SGL$L40_C,SEQN,LBXSGL,LBXSTB,LBXSAL,LBXSCR,LBXSBU,LBXSUA,LBXSAPSI)
SGL_2005 <- select(SGL$BIOPRO_D,SEQN,LBXSGL,LBXSTB,LBXSAL,LBXSCR,LBXSBU,LBXSUA,LBXSAPSI)
SGL_2005 <- mutate(SGL_2005,LBXSCR=(-0.016+0.978*LBXSCR))
SGL_2007 <- select(SGL$BIOPRO_E,SEQN,LBXSGL,LBXSTB,LBXSAL,LBXSCR,LBXSBU,LBXSUA,LBXSAPSI)
SGL_2009 <- select(SGL$BIOPRO_F,SEQN,LBXSGL,LBXSTB,LBXSAL,LBXSCR,LBXSBU,LBXSUA,LBXSAPSI)
SGL_2011 <- select(SGL$BIOPRO_G,SEQN,LBXSGL,LBXSTB,LBXSAL,LBXSCR,LBXSBU,LBXSUA,LBXSAPSI)
SGL_2013 <- select(SGL$BIOPRO_H,SEQN,LBXSGL,LBXSTB,LBXSAL,LBXSCR,LBXSBU,LBXSUA,LBXSAPSI)
SGL_2015 <- select(SGL$BIOPRO_I,SEQN,LBXSGL,LBXSTB,LBXSAL,LBXSCR,LBXSBU,LBXSUA,LBXSAPSI)
SGL_2017 <- select(SGL$BIOPRO_J,SEQN,LBXSGL,LBXSTB,LBXSAL,LBXSCR,LBXSBU,LBXSUA,LBXSAPSI)

SGL_ALL <- bind_rows(SGL_1999,SGL_2001,SGL_2003,SGL_2005,SGL_2007,SGL_2009,SGL_2011,SGL_2013,SGL_2015,SGL_2017)
SGL_ALL <- transmute(SGL_ALL,seqn=SEQN,albumin=LBXSAL,albumin_gL=albumin*10,alp=LBXSAPSI,lnalp=log(1+alp),
                     bun=LBXSBU,lnbun=log(1+bun),creat=LBXSCR,creat_umol=creat*88.4017,lncreat=log(1+creat),
                     lncreat_umol=log(1+creat_umol),glucose=LBXSGL,glucose_mmol=glucose*0.0555,ttbl=LBXSTB,
                     uap=LBXSUA,lnuap=log(1+uap))

head(SGL_ALL)
summary(SGL_ALL)

# BAP ---------------------------------------------------------------------
BAP_1999 <- select(BAP$LAB11,SEQN,LBXBAP)
BAP_1999 <- mutate(BAP_1999, LBXBAP=(log(LBXBAP)))
summary(BAP_1999)
dim(BAP_1999)

#Creating 3 new dataframes to hold bone alkaline phosphatase values to simplify adjustment equations. The three subsets are defined by those values less than 4.5151, those between 4.5151 and 4.9030, and those above 4.90230.
BAP_low <- subset(BAP_1999,LBXBAP<4.5151)
BAP_mid <- subset(BAP_1999,LBXBAP>=4.5151 & LBXBAP<4.9030)
BAP_high <- subset(BAP_1999,LBXBAP>=4.9030)
dim(BAP_low)
dim(BAP_mid)
dim(BAP_high)

#Adjusting BAP from 1999-2000 to align with data from 2001-2004
BAP_low <- mutate(BAP_low,LBXBAP=(exp(-0.5324+1.1139*(LBXBAP)-0.7963*(0)+0.9660*(0))))
BAP_mid <- mutate(BAP_mid,LBXBAP=(exp(-0.5324+1.1139*(LBXBAP)-0.7963*((LBXBAP)-4.5151)+0.9660*(0))))
BAP_high <- mutate(BAP_high,LBXBAP=(exp(-0.5324+1.1139*(LBXBAP)-0.7963*((LBXBAP)-4.5151)+0.9660*((LBXBAP)-4.9030))))
dim(BAP_low)
dim(BAP_mid)
dim(BAP_high)

#Combining adjusted values back into a single matrix
BAP_1999 <- bind_rows(BAP_low,BAP_mid,BAP_high)
dim(BAP_1999)
BAP_2001 <- select(BAP$L11_B,SEQN,LBDBAP)
colnames(BAP_2001) <- colnames(BAP_1999)
BAP_2003 <- select(BAP$L11_C,SEQN,LBXBAP)

BAP_ALL <- bind_rows(BAP_1999,BAP_2001,BAP_2003)
BAP_ALL <- transmute(BAP_ALL,seqn=SEQN,bap=LBXBAP)

head(BAP_ALL)
summary(BAP_ALL)

# Basophils ---------------------------------------------------------------
WBC_1999 <- select(WBC$LAB25,SEQN,LBXWBCSI,LBXRDW,LBXRBCSI,LBXNEPCT,LBXLYPCT,LBXMCVSI,LBXMOPCT,LBXEOPCT,LBXBAPCT)
WBC_2001 <- select(WBC$L25_B,SEQN,LBXWBCSI,LBXRDW,LBXRBCSI,LBXNEPCT,LBXLYPCT,LBXMCVSI,LBXMOPCT,LBXEOPCT,LBXBAPCT)
WBC_2003 <- select(WBC$L25_C,SEQN,LBXWBCSI,LBXRDW,LBXRBCSI,LBXNEPCT,LBXLYPCT,LBXMCVSI,LBXMOPCT,LBXEOPCT,LBXBAPCT)
WBC_2005 <- select(WBC$CBC_D,SEQN,LBXWBCSI,LBXRDW,LBXRBCSI,LBXNEPCT,LBXLYPCT,LBXMCVSI,LBXMOPCT,LBXEOPCT,LBXBAPCT)
WBC_2007 <- select(WBC$CBC_E,SEQN,LBXWBCSI,LBXRDW,LBXRBCSI,LBXNEPCT,LBXLYPCT,LBXMCVSI,LBXMOPCT,LBXEOPCT,LBXBAPCT)
WBC_2009 <- select(WBC$CBC_F,SEQN,LBXWBCSI,LBXRDW,LBXRBCSI,LBXNEPCT,LBXLYPCT,LBXMCVSI,LBXMOPCT,LBXEOPCT,LBXBAPCT)
WBC_2011 <- select(WBC$CBC_G,SEQN,LBXWBCSI,LBXRDW,LBXRBCSI,LBXNEPCT,LBXLYPCT,LBXMCVSI,LBXMOPCT,LBXEOPCT,LBXBAPCT)
WBC_2013 <- select(WBC$CBC_H,SEQN,LBXWBCSI,LBXRDW,LBXRBCSI,LBXNEPCT,LBXLYPCT,LBXMCVSI,LBXMOPCT,LBXEOPCT,LBXBAPCT)
WBC_2015 <- select(WBC$CBC_I,SEQN,LBXWBCSI,LBXRDW,LBXRBCSI,LBXNEPCT,LBXLYPCT,LBXMCVSI,LBXMOPCT,LBXEOPCT,LBXBAPCT)
WBC_2017 <- select(WBC$CBC_J,SEQN,LBXWBCSI,LBXRDW,LBXRBCSI,LBXNEPCT,LBXLYPCT,LBXMCVSI,LBXMOPCT,LBXEOPCT,LBXBAPCT)

WBC_ALL <- bind_rows(WBC_1999,WBC_2001,WBC_2003,WBC_2005,WBC_2007,WBC_2009,WBC_2011,WBC_2013,WBC_2015,WBC_2017)

WBC_ALL$LBXWBCSI[WBC_ALL$LBXWBCSI<=0.050] <- NA
WBC_ALL$LBXWBCSI[WBC_ALL$LBXWBCSI>=400] <- NA
WBC_ALL$LBXRDW[WBC_ALL$LBXRDW<=10.00] <- NA
WBC_ALL$LBXRDW[WBC_ALL$LBXRDW>=40.00] <- NA
WBC_ALL$LBXMCVSI[WBC_ALL$LBXMCVSI<=50.00] <- NA
WBC_ALL$LBXMCVSI[WBC_ALL$LBXMCVSI>=150.00] <- NA

WBC_ALL <- transmute(WBC_ALL,seqn=SEQN,basopa=LBXBAPCT,eosnpa=LBXEOPCT,lymph=LBXLYPCT,mcv=LBXMCVSI,
                     monopa=LBXMOPCT,neut=LBXNEPCT,rbc=LBXRBCSI,rdw=LBXRDW,wbc=LBXWBCSI)

head(WBC_ALL)
summary(WBC_ALL)

# Cadmium -----------------------------------------------------------------
CAD_1999 <- select(CAD$LAB06,SEQN,LBDBCDSI)
CAD_2001 <- select(CAD$L06_B,SEQN,LBDBCDSI)
CAD_2003 <- select(CAD$L06BMT_C,SEQN,LBDBCDSI)
CAD_2005 <- select(CAD$PbCd_D,SEQN,LBDBCDSI)
CAD_2007 <- select(CAD$PbCd_E,SEQN,LBDBCDSI)
CAD_2009 <- select(CAD$PbCd_F,SEQN,LBDBCDSI)
CAD_2011 <- select(CAD$PbCd_G,SEQN,LBDBCDSI)
CAD_2013 <- select(CAD$PBCD_H,SEQN,LBDBCDSI)
CAD_2015 <- select(CAD$PBCD_I,SEQN,LBDBCDSI)

CAD_ALL <- bind_rows(CAD_1999,CAD_2001,CAD_2003,CAD_2005,CAD_2007,CAD_2009,CAD_2011,CAD_2013,CAD_2015)
CAD_ALL <- transmute(CAD_ALL,seqn=SEQN,cadmium=LBDBCDSI)

head(CAD_ALL)
summary(CAD_ALL)

# CRP ---------------------------------------------------------------------
CRP_1999 <- select(CRP$LAB11,SEQN,LBXCRP)
CRP_2001 <- select(CRP$L11_B,SEQN,LBXCRP)
CRP_2003 <- select(CRP$L11_C,SEQN,LBXCRP)
CRP_2005 <- select(CRP$CRP_D,SEQN,LBXCRP)
CRP_2007 <- select(CRP$CRP_E,SEQN,LBXCRP)
CRP_2009 <- select(CRP$CRP_F,SEQN,LBXCRP)

#CRP in 2015 was measured in mg/L units and needs to be divided by 10 to equal units in other waves. Before this I need to remove values below the lower limit of detection (values less than 0.11).
CRP_2015 <- select(CRP$HSCRP_I,SEQN,LBXHSCRP)
CRP_2017 <- select(CRP$HSCRP_J,SEQN,LBXHSCRP)
CRP_2015 <- transmute(CRP_2015,SEQN,LBXCRP=LBXHSCRP/10)
CRP_2017 <- transmute(CRP_2017,SEQN,LBXCRP=LBXHSCRP/10)
CRP_ALL <- bind_rows(CRP_1999,CRP_2001,CRP_2003,CRP_2005,CRP_2007,CRP_2009,CRP_2015,CRP_2017)
CRP_ALL <- transmute(CRP_ALL,seqn=SEQN,crp=LBXCRP,crp_cat=ifelse(crp>=3,1,0),lncrp=log(1+crp))

head(CRP_ALL)
summary(CRP_ALL)

# Cystatin C --------------------------------------------------------------
CYS_1999 <- select(CYS$SSCYST_A,SEQN,SSCYPC)
CYS_2001 <- select(CYS$SSCYST_B,SEQN,SSCYPC)

CYS_ALL <- bind_rows(CYS_1999,CYS_2001)
CYS_ALL <- transmute(CYS_ALL,seqn=SEQN,cyst=SSCYPC)

head(CYS_ALL)
summary(CYS_ALL)

# Blood pressure ----------------------------------------------------------
BPX_1999 <- select(BPX$BPX,SEQN,BPXSY1,BPXSY2,BPXSY3,BPXSY4,BPXDI1,BPXDI2,BPXDI3,BPXDI4)
BPX_2001 <- select(BPX$BPX_B,SEQN,BPXSY1,BPXSY2,BPXSY3,BPXSY4,BPXDI1,BPXDI2,BPXDI3,BPXDI4)
BPX_2003 <- select(BPX$BPX_C,SEQN,BPXSY1,BPXSY2,BPXSY3,BPXSY4,BPXDI1,BPXDI2,BPXDI3,BPXDI4)
BPX_2005 <- select(BPX$BPX_D,SEQN,BPXSY1,BPXSY2,BPXSY3,BPXSY4,BPXDI1,BPXDI2,BPXDI3,BPXDI4)
BPX_2007 <- select(BPX$BPX_E,SEQN,BPXSY1,BPXSY2,BPXSY3,BPXSY4,BPXDI1,BPXDI2,BPXDI3,BPXDI4)
BPX_2009 <- select(BPX$BPX_F,SEQN,BPXSY1,BPXSY2,BPXSY3,BPXSY4,BPXDI1,BPXDI2,BPXDI3,BPXDI4)
BPX_2011 <- select(BPX$BPX_G,SEQN,BPXSY1,BPXSY2,BPXSY3,BPXSY4,BPXDI1,BPXDI2,BPXDI3,BPXDI4)
BPX_2013 <- select(BPX$BPX_H,SEQN,BPXSY1,BPXSY2,BPXSY3,BPXSY4,BPXDI1,BPXDI2,BPXDI3,BPXDI4)
BPX_2015 <- select(BPX$BPX_I,SEQN,BPXSY1,BPXSY2,BPXSY3,BPXSY4,BPXDI1,BPXDI2,BPXDI3,BPXDI4)
BPX_2017 <- select(BPX$BPX_J,SEQN,BPXSY1,BPXSY2,BPXSY3,BPXSY4,BPXDI1,BPXDI2,BPXDI3,BPXDI4)

BPX_ALL <- bind_rows(BPX_1999,BPX_2001,BPX_2003,BPX_2005,BPX_2007,BPX_2009,BPX_2011,BPX_2013,BPX_2015,BPX_2017)

BPX_ALL$sbp <- rowMeans(BPX_ALL[,c("BPXSY1","BPXSY2","BPXSY3","BPXSY4")], na.rm=TRUE)
BPX_ALL$dbp <- rowMeans(BPX_ALL[,c("BPXDI1","BPXDI2","BPXDI3","BPXDI4")], na.rm=TRUE)

BPX_ALL$sbp[BPX_ALL$sbp==0]<-NA
BPX_ALL$dbp[BPX_ALL$dbp==0]<-NA

BPX_ALL$sbp[BPX_ALL$sbp=="NaN"]<-NA
BPX_ALL$dbp[BPX_ALL$dbp=="NaN"]<-NA

BPX_ALL$meanbp <- (BPX_ALL$sbp + (2*BPX_ALL$dbp))/3
BPX_ALL$pulse <- BPX_ALL$sbp - BPX_ALL$dbp

BPX_ALL <- BPX_ALL %>% select(seqn=SEQN,dbp,sbp,meanbp,pulse)

head(BPX_ALL)
summary(BPX_ALL)

# Gamma glutamyl transferase  ---------------------------------------------
GGT_2001 <- select(GGT$L40_2_B,SEQN,LB2SGTSI)
GGT_2003 <- select(GGT$L40_C,SEQN,LBXSGTSI)
GGT_2005 <- select(GGT$BIOPRO_D,SEQN,LBXSGTSI)
GGT_2007 <- select(GGT$BIOPRO_E,SEQN,LBXSGTSI)
GGT_2009 <- select(GGT$BIOPRO_F,SEQN,LBXSGTSI)
GGT_2011 <- select(GGT$BIOPRO_G,SEQN,LBXSGTSI)
GGT_2013 <- select(GGT$BIOPRO_H,SEQN,LBXSGTSI)
GGT_2015 <- select(GGT$BIOPRO_I,SEQN,LBXSGTSI)
GGT_2017 <- select(GGT$BIOPRO_J,SEQN,LBXSGTSI)
colnames(GGT_2001) <- colnames(GGT_2003)

GGT_ALL <- bind_rows(GGT_2001,GGT_2003,GGT_2005,GGT_2007,GGT_2009,GGT_2011,GGT_2013,GGT_2015,GGT_2017)
GGT_ALL <- transmute(GGT_ALL,seqn=SEQN,ggt=LBXSGTSI)

head(GGT_ALL)
summary(GGT_ALL)

# Plasma fasting glucose  -------------------------------------------------
## The measurement methods for glucose, and especially insulin were widely changes across NHANES waves.
## Adjustment of glucose involves multiple regression equations as the methodology changes 3 times between 1999 and 2016. First, 1999-2004 values must be adjusted to reflect changes to the methodology for 2005-2006 such that all values are equivalent to measures from the "Hitachi 911" [see here](https://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/GLU_D.htm). Next, all values prior to 2007 must be adjusted to reflect changes in methodology for 2007-2008 such that all values are equivalent to measures from the "Roche ModP" [see here](https://wwwn.cdc.gov/Nchs/Nhanes/2007-2008/GLU_E.htm). Lastly, methodology changed once again in 2015 such that these values need to be backward regressed to be comparable to values from previous waves to be in the "C501" form [see here](https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/GLU_I.htm#LBXGLU).
## Adjustment of insulin involves multiple regression equations as the methodology changed 5 times between 1999 and 2014. First, 1999-2002 values must be adjusted to reflect changes in methodology for 2003-2004 [see here](https://wwwn.cdc.gov/Nchs/Nhanes/2003-2004/L10AM_C.htm). These adjusted values, as well as values from 2003-2004, must be adjusted again to reflect changes in methodology for 2005-2006 such that all insuilin values are equivalent to the "Mercodia" method [see here](https://wwwn.cdc.gov/Nchs/Nhanes/2005-2006/GLU_D.htm). Next all values before 2011 must be adjusted to reflect methodological changes in 2011-2012 such that insulin values are in their "Roche-equivalent" form [see here](https://wwwn.cdc.gov/Nchs/Nhanes/2011-2012/GLU_G.htm). Finally, values from 2013-2014 must be "backward" regressed to match 2011-2012 methodology such that 2013-2014 values are in the "Roche-equivalent" form [see here](https://wwwn.cdc.gov/Nchs/Nhanes/2013-2014/INS_H.htm#LBXIN).
GLU_1999 <- select(GLU$LAB10AM,SEQN,LBXGLU,LBXIN)
GLU_2001 <- select(GLU$L10AM_B,SEQN,LBXGLU,LBXIN)

#Combining and adjusting 1999-2002 insulin
GLU_early <- bind_rows(GLU_1999,GLU_2001)
GLU_early <- mutate(GLU_early,LBXIN=(1.0027*LBXIN-2.2934))

GLU_2003 <- select(GLU$L10AM_C,SEQN,LBXGLU,LBXIN)

#Recoding values of insulin below the limit of detection as missing
GLU_2003$LBXIN[GLU_2003$LBXIN==0.71] <- NA

#Combining 2003 measures with 1999-2002 and adjusting glucose and insulin to match 2005 methods
GLU_middle <- bind_rows(GLU_early,GLU_2003)
GLU_middle <- mutate(GLU_middle,LBXGLU=(LBXGLU*0.9815+3.5707),LBXIN=(0.9501*LBXIN+1.4890))

GLU_2005 <- select(GLU$GLU_D,SEQN,LBXGLU,LBXIN)

# Combining pre-2007 measures and adjusting glucose such that all glucose results should be in line with 2007 methodology
GLU_pre2007 <- bind_rows(GLU_middle,GLU_2005)
GLU_pre2007 <- transmute(GLU_pre2007,LBXGLU=LBXGLU+1.148,LBXIN=LBXIN)


GLU_2007 <- select(GLU$GLU_E,SEQN,LBXGLU,LBXIN)
GLU_2009 <- select(GLU$GLU_F,SEQN,LBXGLU,LBXIN)

#Combining pre-2011 measures and adjusting insulin
GLU_late <- bind_rows(GLU_pre2007,GLU_2007,GLU_2009)
GLU_late <- mutate(GLU_late,LBXIN=(0.8868*LBXIN+(0.0011*LBXIN^2)-0.0744))

GLU_2011 <- select(GLU$GLU_G,SEQN,LBXGLU,LBXIN)
GLU_2013 <- select(GLU$GLU_H,SEQN,LBXGLU)
insulin_2013 <- select(GLU$INS_H,SEQN,LBXIN)

#Removing values below the LLOD for 2013 insulin and adjusting values to match 2011-2012 wave
insulin_2013$LBXIN[insulin_2013$LBXIN<=1] <- NA
insulin_2013 <- mutate(insulin_2013,LBXIN=(10^(0.9765*log10(LBXIN))+0.07832))

#Joining 2013 glucose and 2013 insulin dataframes
GLU_2013 <- full_join(GLU_2013,insulin_2013,by="SEQN")

#Extracting 2015 glucose and adjusting to match previous methods with backward Deming regression equation
GLU_2015 <- select(GLU$GLU_I,SEQN,LBXGLU)
GLU_2015 <- mutate(GLU_2015,LBXGLU=LBXGLU*0.9776+0.4994)

#Extracting 2015 insulin, rmoving values below the LLOD and combining with glucose
insulin_2015 <- select(GLU$INS_I,SEQN,LBXIN)
insulin_2015$LBXIN[insulin_2015$LBXIN<=1] <- NA
GLU_2015 <- full_join(GLU_2015,insulin_2015,by="SEQN")

GLU_ALL <- bind_rows(GLU_late,GLU_2011,GLU_2013,GLU_2015)

#Removing outlier values of insulin
GLU_ALL$LBXIN[GLU_ALL$LBXIN<=1] <- NA

#Making informative variable names
GLU_ALL <- transmute(GLU_ALL,seqn=SEQN,glucose_fasting=LBXGLU,insulin=LBXIN)

dim(GLU_ALL)
summary(GLU_ALL)

# Fasting -----------------------------------------------------------------
PHH_1999 <- select(PHH$PH,SEQN,PHAFSTHR)
PHH_2001 <- select(PHH$PH_B,SEQN,PHAFSTHR)
PHH_2003 <- select(PHH$PH_C,SEQN,PHAFSTHR)
PHH_2005 <- select(PHH$FASTQX_D,SEQN,PHAFSTHR)
PHH_2007 <- select(PHH$FASTQX_E,SEQN,PHAFSTHR)
PHH_2009 <- select(PHH$FASTQX_F,SEQN,PHAFSTHR)
PHH_2011 <- select(PHH$FASTQX_G,SEQN,PHAFSTHR)
PHH_2013 <- select(PHH$FASTQX_H,SEQN,PHAFSTHR)
PHH_2015 <- select(PHH$FASTQX_I,SEQN,PHAFSTHR)
PHH_2017 <- select(PHH$FASTQX_J,SEQN,PHAFSTHR)

PHH_ALL <- bind_rows(PHH_1999,PHH_2001,PHH_2003,PHH_2005,PHH_2007,PHH_2009,PHH_2011,PHH_2013,PHH_2015,PHH_2017)
PHH_ALL <- transmute(PHH_ALL,seqn=SEQN,phpfast=PHAFSTHR)

head(PHH_ALL)
summary(PHH_ALL)

# Hba1c -------------------------------------------------------------------
HBA_1999 <- select(HBA$LAB10,SEQN,LBXGH)
HBA_2001 <- select(HBA$L10_B,SEQN,LBXGH)
HBA_2003 <- select(HBA$L10_C,SEQN,LBXGH)
HBA_2005 <- select(HBA$GHB_D,SEQN,LBXGH)
HBA_2007 <- select(HBA$GHB_E,SEQN,LBXGH)
HBA_2009 <- select(HBA$GHB_F,SEQN,LBXGH)
HBA_2011 <- select(HBA$GHB_G,SEQN,LBXGH)
HBA_2013 <- select(HBA$GHB_H,SEQN,LBXGH)
HBA_2015 <- select(HBA$GHB_I,SEQN,LBXGH)
HBA_2017 <- select(HBA$GHB_J,SEQN,LBXGH)

HBA_ALL <- bind_rows(HBA_1999,HBA_2001,HBA_2003,HBA_2005,HBA_2007,HBA_2009,HBA_2011,HBA_2013,HBA_2015,HBA_2017)
HBA_ALL <- transmute(HBA_ALL,seqn=SEQN,hba1c=LBXGH,lnhba1c=log(hba1c))

head(HBA_ALL)
summary(HBA_ALL)

# HDL ---------------------------------------------------------------------
HDL_1999 <- select(HDLchol$LAB13,SEQN,LBDHDL)
HDL_2001 <- select(HDLchol$L13_B,SEQN,LBDHDL)
HDL_2003 <- select(HDLchol$L13_C,SEQN,LBXHDD)
HDL_2005 <- select(HDLchol$HDL_D,SEQN,LBDHDD)
HDL_2007 <- select(HDLchol$HDL_E,SEQN,LBDHDD)
HDL_2009 <- select(HDLchol$HDL_F,SEQN,LBDHDD)
HDL_2011 <- select(HDLchol$HDL_G,SEQN,LBDHDD)
HDL_2013 <- select(HDLchol$HDL_H,SEQN,LBDHDD)
HDL_2015 <- select(HDLchol$HDL_I,SEQN,LBDHDD)
HDL_2017 <- select(HDLchol$HDL_J,SEQN,LBDHDD)

colnames(HDL_1999) <- colnames(HDL_2013)
colnames(HDL_2001) <- colnames(HDL_2013)
colnames(HDL_2003) <- colnames(HDL_2013)

HDL_ALL <- bind_rows(HDL_1999,HDL_2001,HDL_2003,HDL_2005,HDL_2007,HDL_2009,HDL_2011,HDL_2013,HDL_2015,HDL_2017)
HDL_ALL <- transmute(HDL_ALL,seqn=SEQN,hdl=LBDHDD)

head(HDL_ALL)
summary(HDL_ALL)

# LDL ---------------------------------------------------------------------
LDL_1999 <- select(TRI$LAB13,SEQN,LBDLDL,LBXTR)
LDL_2001 <- select(TRI$L13AM_B,SEQN,LBDLDL,LBXTR)
LDL_2003 <- select(TRI$L13AM_C,SEQN,LBDLDL,LBXTR)
LDL_2005 <- select(TRI$TRIGLY_D,SEQN,LBDLDL,LBXTR)
LDL_2007 <- select(TRI$TRIGLY_E,SEQN,LBDLDL,LBXTR)
LDL_2009 <- select(TRI$TRIGLY_F,SEQN,LBDLDL,LBXTR)
LDL_2011 <- select(TRI$TRIGLY_G,SEQN,LBDLDL,LBXTR)
LDL_2013 <- select(TRI$TRIGLY_H,SEQN,LBDLDL,LBXTR)
LDL_2015 <- select(TRI$TRIGLY_I,SEQN,LBDLDL,LBXTR)

LDL_ALL <- bind_rows(LDL_1999,LDL_2001,LDL_2003,LDL_2005,LDL_2007,LDL_2009,LDL_2011,LDL_2013,LDL_2015)
LDL_ALL <- transmute(LDL_ALL,seqn=SEQN,ldl=LBDLDL,trig=LBXTR)

head(LDL_ALL)
summary(LDL_ALL)

# Total cholesterol  ------------------------------------------------------
CHL_1999 <- select(CHL$Lab13,SEQN,LBXTC)
CHL_2001 <- select(CHL$l13_b,SEQN,LBXTC)
CHL_2003 <- select(CHL$l13_c,SEQN,LBXTC)
CHL_2005 <- select(CHL$TCHOL_D,SEQN,LBXTC)
CHL_2007 <- select(CHL$TCHOL_E,SEQN,LBXTC)
CHL_2009 <- select(CHL$TCHOL_F,SEQN,LBXTC)
CHL_2011 <- select(CHL$TCHOL_G,SEQN,LBXTC)
CHL_2013 <- select(CHL$TCHOL_H,SEQN,LBXTC)
CHL_2015 <- select(CHL$TCHOL_I,SEQN,LBXTC)
CHL_2017 <- select(CHL$TCHOL_J,SEQN,LBXTC)

CHL_ALL <- bind_rows(CHL_1999,CHL_2001,CHL_2003,CHL_2005,CHL_2007,CHL_2009,CHL_2011,CHL_2013,CHL_2015,CHL_2017)
CHL_ALL <- transmute(CHL_ALL,seqn=SEQN,totchol=LBXTC)

head(CHL_ALL)
summary(CHL_ALL)

# Vitamin A ---------------------------------------------------------------
VITA_1999 <- select(VITA$LAB06,SEQN,LBDVIESI,LBDVIASI)
VITA_2001 <- select(VITA$L06VIT_B,SEQN,LBDVIESI,LBDVIASI)
VITA_2003 <- select(VITA$L45VIT_C,SEQN,LBDVIASI)
VITA_2005 <- select(VITA$VITAEC_D,SEQN,LBDVIESI,LBDVIASI)

VITA_ALL <- bind_rows(VITA_1999,VITA_2001,VITA_2003,VITA_2005)
VITA_ALL <- transmute(VITA_ALL,seqn=SEQN,vitaminA=LBDVIASI,vitaminE=LBDVIESI)

head(VITA_ALL)
summary(VITA_ALL)

# Vitamin B ---------------------------------------------------------------
VITAB_1999 <- select(VITAB$LAB06,SEQN,LBDB12SI)
VITAB_2001 <- select(VITAB$L06_B,SEQN,LBDB12SI)
VITAB_2003 <- select(VITAB$L06NB_C,SEQN,LBDB12SI)
VITAB_2005 <- select(VITAB$B12_D,SEQN,LBDB12SI)
VITAB_2011 <- select(VITAB$VITB12_G,SEQN,LBDB12SI)
VITAB_2013 <- select(VITAB$VITB12_H,SEQN,LBDB12SI)

VITAB_ALL <- bind_rows(VITAB_1999,VITAB_2001,VITAB_2003,VITAB_2005,VITAB_2011,VITAB_2013)
VITAB_ALL <- transmute(VITAB_ALL,seqn=SEQN,vitaminB12=LBDB12SI)

head(VITAB_ALL)
summary(VITAB_ALL)

# Vitamin C ---------------------------------------------------------------
VITAC_2003 <- select(VITAC$L06VIT_C,SEQN,LBDVICSI)
VITAC_2005 <- select(VITAC$VIC_D,SEQN,LBDVICSI)

VITAC_ALL <- bind_rows(VITAC_2003,VITAC_2005)
VITAC_ALL <- transmute(VITAC_ALL,seqn=SEQN,vitaminC=LBDVICSI)

head(VITAC_ALL)
summary(VITAC_ALL)

# Mortality ---------------------------------------------------------------
library(readstata13)
library(stringr)

f <- file.path("/Users/dayoonkwon/Dropbox/belskylab/project/nhanes/NHANES/NHANESFiles/Mortality",
               c("NHANES_1999_2000_Mort2015Public.dta","NHANES_2001_2002_Mort2015Public.dta",
                 "NHANES_2003_2004_Mort2015Public.dta","NHANES_2005_2006_Mort2015Public.dta",
                 "NHANES_2007_2008_Mort2015Public.dta","NHANES_2009_2010_Mort2015Public.dta",
                 "NHANES_2011_2012_Mort2015Public.dta","NHANES_2013_2014_Mort2015Public.dta"))
NHANES_MORT <- lapply(f, read.dta13); rm(f)
NHANES_MORT <- lapply(NHANES_MORT,function(x){
  x$seqn = as.numeric(str_remove(x$seqn,"^0+"))
  return(x)
})
NHANES_MORT <- bind_rows(NHANES_MORT)

#include age-related mortality
NHANES_MORT$mortstat[NHANES_MORT$ucod_leading==4|NHANES_MORT$ucod_leading==8|NHANES_MORT$ucod_leading==10]<-0

# Combine all datasets ----------------------------------------------------
NHANES4 <- full_join(Demographics_ALL,PFQ_ALL,by="seqn") %>%
  full_join(.,BMI_ALL,by="seqn") %>%
  full_join(.,BIX_ALL,by="seqn") %>%
  full_join(.,SPX_ALL,by="seqn") %>%
  full_join(.,MGX_ALL,by="seqn") %>%
  full_join(.,HSQ_ALL,by="seqn") %>%
  full_join(.,MSX_ALL,by="seqn") %>%
  full_join(.,CVX_ALL,by="seqn") %>%
  full_join(.,SGL_ALL,by="seqn") %>%
  full_join(.,BAP_ALL,by="seqn") %>%
  full_join(.,WBC_ALL,by="seqn") %>%
  full_join(.,CAD_ALL,by="seqn") %>%
  full_join(.,CRP_ALL,by="seqn") %>%
  full_join(.,CYS_ALL,by="seqn") %>%
  full_join(.,BPX_ALL,by="seqn") %>%
  full_join(.,GGT_ALL,by="seqn") %>%
  full_join(.,GLU_ALL,by="seqn") %>%
  full_join(.,PHH_ALL,by="seqn") %>%
  full_join(.,HBA_ALL,by="seqn") %>%
  full_join(.,HDL_ALL,by="seqn") %>%
  full_join(.,LDL_ALL,by="seqn") %>%
  full_join(.,CHL_ALL,by="seqn") %>%
  full_join(.,VITA_ALL,by="seqn") %>%
  full_join(.,VITAB_ALL,by="seqn") %>%
  full_join(.,VITAC_ALL,by="seqn") %>%
  full_join(.,NHANES_MORT,by="seqn") %>%
  unique()

dim(NHANES4)
head(NHANES4)
summary(NHANES4)

# NHANESIII ---------------------------------------------------------------
adult <- read.dta13("/Users/dayoonkwon/Dropbox/belskylab/project/nhanes/NHANES/NHANESFiles/NHANESIII/adult.dta")
colnames(adult) <-toupper(colnames(adult))

exam1 <- read.dta13("/Users/dayoonkwon/Dropbox/belskylab/project/nhanes/NHANES/NHANESFiles/NHANESIII/exam1.dta")
exam2 <- read.dta13("/Users/dayoonkwon/Dropbox/belskylab/project/nhanes/NHANES/NHANESFiles/NHANESIII/exam2.dta")
exam <- merge(exam1,exam2,by="seqn")
colnames(exam) <-toupper(colnames(exam))

lab <- read.dta13("/Users/dayoonkwon/Dropbox/belskylab/project/nhanes/NHANES/NHANESFiles/NHANESIII/lab.dta")
colnames(lab) <-toupper(colnames(lab))

# Demographic -------------------------------------------------------------
Demo_III <- select(adult,SEQN,HSSEX,HSAGEIR,DMARETHN,HFA8R,DMPPIR,HAB1,HFF19R)
#Adding a wave variable and informative variable names to match those in the continuous NHANES panels data file
Demo_III <- transmute(Demo_III,seqn=SEQN,year=1991,wave=0,gender=HSSEX,age=HSAGEIR,
                      income_recode=HFF19R,education=HFA8R,ethnicity=DMARETHN,poverty_ratio=DMPPIR,
                      health=HAB1)

#Recoding variables
Demo_III$income_recode[Demo_III$income_recode==88]<-NA
Demo_III$income_recode[Demo_III$income_recode==99]<-NA
Demo_III$income_recode[Demo_III$income_recode<=5]<-1
Demo_III$income_recode[Demo_III$income_recode>=6&Demo_III$income_recode<=10]<-2
Demo_III$income_recode[Demo_III$income_recode>=11&Demo_III$income_recode<=15]<-3
Demo_III$income_recode[Demo_III$income_recode>=16&Demo_III$income_recode<=20]<-4
Demo_III$income_recode[Demo_III$income_recode==21]<-5
Demo_III$income_recode[Demo_III$income_recode>=22&Demo_III$income_recode<=23]<-6
Demo_III$income_recode[Demo_III$income_recode>=24&Demo_III$income_recode<=25]<-7
Demo_III$income_recode[Demo_III$income_recode>=26&Demo_III$income_recode<=27]<-8

Demo_III$education[Demo_III$education==88] <- NA
Demo_III$education[Demo_III$education==99] <- NA
Demo_III$education[Demo_III$education<9] <- 1 #less than 9th grade
Demo_III$education[Demo_III$education>=9&Demo_III$education<=11] <- 2 #9-11th grade
Demo_III$education[Demo_III$education==12] <- 3 #high school graduate
Demo_III$education[Demo_III$education>=13&Demo_III$education<=15] <- 4 #some college
Demo_III$education[Demo_III$education>=16] <- 5 #college graduate or higher

Demo_III$edu = Demo_III$education
Demo_III$edu[Demo_III$education==1|Demo_III$education==2]<-1
Demo_III$edu[Demo_III$education==3]<-2
Demo_III$edu[Demo_III$education==4]<-3
Demo_III$edu[Demo_III$education==5]<-4

Demo_III$race=Demo_III$ethnicity
Demo_III$race[Demo_III$race==3|Demo_III$race==4]<-3

Demo_III$poverty_ratio[Demo_III$poverty_ratio==888888] <- NA
Demo_III$health[Demo_III$health>=8] <- NA

head(Demo_III)
summary(Demo_III)

# Pregnant ----------------------------------------------------------------
BMI_III <- select(exam,SEQN,MAPF12R,BMPBMI,BMPHT,BMPWAIST,BMPWT,PEPMNK1R,PEPMNK5R,SPPFEV1)
BMI_III <- transmute(BMI_III,seqn=SEQN,pregnant=MAPF12R,bmi=BMPBMI,height=BMPHT,waist=BMPWAIST,
                     weight=BMPWT,sbp=PEPMNK1R,dbp=PEPMNK5R,fev=SPPFEV1)

#Recoding pregnancy variable to be nonpregnant for all men and for individuals of uncertain pregnancy status
BMI_III$pregnant[BMI_III$pregnant==8] <- 0
BMI_III$pregnant[BMI_III$pregnant==9] <- 0
BMI_III$pregnant[is.na(BMI_III$pregnant)] <- 0
BMI_III$pregnant[BMI_III$pregnant==2] <- 0

#Recoding missing indicators to NA
BMI_III$bmi[BMI_III$bmi==8888] <- NA
BMI_III$height[BMI_III$height==88888] <- NA
BMI_III$waist[BMI_III$waist==88888] <- NA
BMI_III$weight[BMI_III$weight==888888] <- NA
BMI_III$sbp[BMI_III$sbp==888] <- NA
BMI_III$dbp[BMI_III$dbp==888] <- NA
BMI_III$fev[BMI_III$fev>=8880] <- NA

#Create variables
BMI_III$meanbp <- (BMI_III$sbp + (2*BMI_III$dbp))/3
BMI_III$pulse <- BMI_III$sbp - BMI_III$dbp
BMI_III$fev_1000 <- BMI_III$fev/1000

head(BMI_III)
summary(BMI_III)

# Biomarkers --------------------------------------------------------------
Bio_III <- select(lab,SEQN,GHP,TCP,HDP,LCP,TGP,CRP,CEP,SGP,I1P,URP,PHPFAST,AMP,APPSI,BUP,UAP,
                  LMPPCNT,WCPSI,MVPSI,RWP,MOPPCNT,RCPSI,TBP,GGPSI,UDPSI,I1P,VBPSI,VCP,VAPSI,VEPSI)
Bio_III <- transmute(Bio_III,seqn=SEQN,hba1c=GHP,totchol=TCP,hdl=HDP,ldl=LCP,trig=TGP,crp=CRP,
                     creat=CEP,glucose=SGP,phpfast=PHPFAST,albumin=AMP,alp=APPSI,bun=BUP,uap=UAP,
                     lymph=LMPPCNT,wbc=WCPSI,mcv=MVPSI,rdw=RWP,monopa=MOPPCNT,rbc=RCPSI,ttbl=TBP,
                     ggt=GGPSI,cadmium=UDPSI,insulin=I1P,vitaminB12=VBPSI,vitaminC=VCP,vitaminA=VAPSI,
                     vitaminE=VEPSI)

#Recoding NHANES III blank indicators to missing
Bio_III$hba1c[Bio_III$hba1c==8888] <- NA
Bio_III$totchol[Bio_III$totchol==888] <- NA
Bio_III$hdl[Bio_III$hdl==888] <- NA
Bio_III$ldl[Bio_III$ldl==888] <- NA
Bio_III$trig[Bio_III$trig==8888] <- NA
Bio_III$crp[Bio_III$crp>=8888.80] <- NA
Bio_III$creat[Bio_III$creat==8888] <- NA
Bio_III$glucose[Bio_III$glucose==888] <- NA
Bio_III$phpfast[Bio_III$phpfast==88888] <- NA
Bio_III$albumin[Bio_III$albumin==888] <- NA
Bio_III$alp[Bio_III$alp==8888] <- NA
Bio_III$bun[Bio_III$bun==888] <- NA
Bio_III$uap[Bio_III$uap==8888] <- NA
Bio_III$lymph[Bio_III$lymph==88888] <- NA
Bio_III$monopa[Bio_III$monopa==88888] <- NA
Bio_III$wbc[Bio_III$wbc==88888] <- NA
Bio_III$mcv[Bio_III$mcv==88888] <- NA
Bio_III$rdw[Bio_III$rdw==88888] <- NA
Bio_III$rbc[Bio_III$rbc==8888] <- NA
Bio_III$ttbl[Bio_III$ttbl==8888] <- NA
Bio_III$ggt[Bio_III$ggt==8888] <- NA
Bio_III$cadmium[Bio_III$cadmium==888888] <- NA
Bio_III$insulin[Bio_III$insulin==888888] <- NA
Bio_III$vitaminB12[Bio_III$vitaminB12==88888888] <- NA
Bio_III$vitaminC[Bio_III$vitaminC==8888] <- NA
Bio_III$vitaminA[Bio_III$vitaminA==8888] <- NA
Bio_III$vitaminE[Bio_III$vitaminE==888888] <- NA

#Adjusting serum creatinine according to published equation
Bio_III$creat <- Bio_III$creat*0.960-0.184
Bio_III$lncrp <- log(1+Bio_III$crp)
Bio_III$crp_cat <- ifelse(Bio_III$crp>=3,1,0)
Bio_III$lncreat <- log(1+Bio_III$creat)
Bio_III$creat_umol <- Bio_III$creat*88.4017
Bio_III$lncreat_umol <- log(1+Bio_III$creat_umol)
Bio_III$glucose_mmol <- Bio_III$glucose*0.0555
Bio_III$albumin_gL <- Bio_III$albumin*10
Bio_III$vitaminC <- Bio_III$vitaminC*56.82
Bio_III$lnhba1c <- log(1+Bio_III$hba1c)
Bio_III$lnalp = log(1+Bio_III$alp)
Bio_III$lnbun = log(1+Bio_III$bun)
Bio_III$lnuap = log(1+Bio_III$uap)

head(Bio_III)
summary(Bio_III)


# cyst c ------------------------------------------------------------------
library(Hmisc)
NHANESIII_CYST <- sasxport.get("/Users/dayoonkwon/Dropbox/belskylab/project/nhanes/data/sscystat.xpt")
NHANESIII_CYST <- select(NHANESIII_CYST,seqn,sscystat)
NHANESIII_CYST <- transmute(NHANESIII_CYST,seqn,cyst=sscystat)
NHANESIII_CYST$seqn = as.numeric(NHANESIII_CYST$seqn)
NHANESIII_CYST$cyst = as.numeric(NHANESIII_CYST$cyst)

# Mortality ---------------------------------------------------------------
NHANESIII_MORT <- read.dta13("/Users/dayoonkwon/Dropbox/belskylab/project/nhanes/NHANES/NHANESFiles/Mortality/NHANES_III_Mort2015Public.dta")
NHANESIII_MORT$seqn = as.numeric(str_remove(NHANESIII_MORT$seqn,"^0+"))

#include age-related mortality
NHANESIII_MORT$mortstat[NHANESIII_MORT$ucod_leading==4|NHANESIII_MORT$ucod_leading==8|NHANESIII_MORT$ucod_leading==10]<-0
NHANESIII_MORT$mortstat[NHANESIII_MORT$mortstat==1 & NHANESIII_MORT$permth_exm >240]<-0
NHANESIII_MORT$permth_exm[NHANESIII_MORT$permth_exm>240]<-240

# Combine all datasets ----------------------------------------------------
NHANES3 <- full_join(Demo_III,BMI_III,by="seqn") %>%
  full_join(.,Bio_III,by="seqn") %>%
  full_join(.,NHANESIII_CYST,by="seqn") %>%
  full_join(.,NHANESIII_MORT,by="seqn") %>%
  unique()

head(NHANES3)
summary(NHANES3)
dim(NHANES3)

# Merge NHANES and NHANESIII ----------------------------------------------
NHANES_ALL = rbind.fill(NHANES4,NHANES3) %>%
  unique() %>%
  filter(!is.na(year)&age>=20) %>%
  dplyr::rename(sampleID = seqn,
                time = permth_exm,
                status = mortstat) %>%
  mutate(sampleID = paste0(year,"_",sampleID))

head(NHANES_ALL)
summary(NHANES_ALL)
dim(NHANES_ALL)

# Final two seperate data -------------------------------------------------
NHANES3 = subset(NHANES_ALL, wave==0) %>%
  group_by(gender) %>%
  mutate_at(vars(fev,albumin:alp,bun,creat,creat_umol,glucose:uap,bap:crp,cyst:insulin,hba1c,hdl:vitaminC),
            list(~ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE)))|
                          (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .))) %>%
  mutate(fev_1000 = ifelse(is.na(fev), NA, fev_1000),
         lncreat = ifelse(is.na(creat), NA, lncreat),
         lncreat_umol = ifelse(is.na(creat_umol), NA, lncreat_umol),
         crp_cat = ifelse(is.na(crp), NA, crp_cat),
         lncrp = ifelse(is.na(crp), NA, lncrp),
         lnalp = ifelse(is.na(alp), NA, lnalp),
         lnbun = ifelse(is.na(bun), NA, lnbun),
         lnuap = ifelse(is.na(uap), NA, lnuap),
         lnhba1c = ifelse(is.na(hba1c), NA, lnhba1c)) %>%
  ungroup()

NHANES4 = subset(NHANES_ALL, wave>0) %>%
  group_by(gender) %>%
  mutate_at(vars(fev,albumin:alp,bun,creat,creat_umol,glucose:uap,bap:crp,cyst:insulin,hba1c,hdl:vitaminC),
            list(~ifelse((. > (mean(., na.rm = TRUE) + 5 * sd(., na.rm = TRUE)))|
                           (. < (mean(., na.rm = TRUE) - 5 * sd(., na.rm = TRUE))), NA, .))) %>%
  mutate(fev_1000 = ifelse(is.na(fev), NA, fev_1000),
         lncreat = ifelse(is.na(creat), NA, lncreat),
         lncreat_umol = ifelse(is.na(creat_umol), NA, lncreat_umol),
         crp_cat = ifelse(is.na(crp), NA, crp_cat),
         lncrp = ifelse(is.na(crp), NA, lncrp),
         lnalp = ifelse(is.na(alp), NA, lnalp),
         lnbun = ifelse(is.na(bun), NA, lnbun),
         lnuap = ifelse(is.na(uap), NA, lnuap),
         lnhba1c = ifelse(is.na(hba1c), NA, lnhba1c)) %>%
  ungroup()

summary(NHANES3)
summary(NHANES4)
# Calculate KDM Bioage ----------------------------------------------------
biomarkers=c("fev","sbp","totchol","hba1c","albumin","creat","lncrp","alp","bun")

train_fem = BioAge::kdm_calc(data = NHANES3 %>%
                               filter(gender==2 & age>=30 & age<=75 & pregnant==0),
                             biomarkers, fit = NULL, s_ba2 = NULL)
train_male = BioAge::kdm_calc(data = NHANES3 %>%
                                filter(gender==1 & age>=30 & age<=75 & pregnant==0),
                              biomarkers, fit = NULL, s_ba2 = NULL)

test_fem = BioAge::kdm_calc(data = NHANES4 %>%
                              filter(gender==2),
                            biomarkers, fit = train_fem$fit, s_ba2 = train_fem$fit$s_ba2)

test_male = BioAge::kdm_calc(data = NHANES4 %>%
                               filter(gender==1),
                             biomarkers, fit = train_male$fit, s_ba2 = train_male$fit$s_ba2)

train = rbind(train_fem$data, train_male$data) %>%
  dplyr::rename(kdm0 = kdm,
                kdm_advance0 = kdm_advance)

test = rbind(test_fem$data, test_male$data) %>%
  dplyr::rename(kdm0 = kdm,
                kdm_advance0 = kdm_advance)

NHANES3 <- left_join(NHANES3,train[,c("sampleID","kdm0","kdm_advance0")],by="sampleID")
NHANES4 <- left_join(NHANES4,test[,c("sampleID","kdm0","kdm_advance0")],by="sampleID")

# Calculate Phenoage ------------------------------------------------------
train = NHANES3 %>%
  filter(age>=20 & age<=84 & phpfast>=8)

xb = -19.90667+(-0.03359355*train$albumin_gL)+(0.009506491*train$creat_umol)+(0.1953192*train$glucose_mmol)+
  (0.09536762*train$lncrp)+(-0.01199984*train$lymph)+(0.02676401*train$mcv)+(0.3306156*train$rdw)+
  (0.001868778*train$alp)+(0.05542406*train$wbc)+(0.08035356*train$age)
m = 1-(exp((-1.51714*exp(xb))/0.007692696))
train$phenoage0 = ((log(-.0055305*(log(1-m)))/.090165)+141.50225)
train$phenoage_advance0 <- train$phenoage0-train$age
train$phenoage_residual0 <- residuals(lm(phenoage0 ~ age, data=train, na.action = "na.exclude"))

test = NHANES4
xb = -19.90667+(-0.03359355*test$albumin_gL)+(0.009506491*test$creat_umol)+(0.1953192*test$glucose_mmol)+
  (0.09536762*test$lncrp)+(-0.01199984*test$lymph)+(0.02676401*test$mcv)+(0.3306156*test$rdw)+
  (0.001868778*test$alp)+(0.05542406*test$wbc)+(0.08035356*test$age)
m = 1-(exp((-1.51714*exp(xb))/0.007692696))
test$phenoage0 = ((log(-.0055305*(log(1-m)))/.090165)+141.50225)
test$phenoage_advance0 <- test$phenoage0-test$age

NHANES3 <- left_join(NHANES3,train[,c("sampleID","phenoage0","phenoage_advance0")],by="sampleID")
NHANES4 <- left_join(NHANES4,test[,c("sampleID","phenoage0","phenoage_advance0")],by="sampleID")

NHANES3_CLEAN = NHANES3 %>%
  filter(age >= 20 & age <= 30 & pregnant == 0) %>%
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

usethis::use_data(NHANES3, overwrite = TRUE)
usethis::use_data(NHANES4, overwrite = TRUE)
usethis::use_data(NHANES3_CLEAN, overwrite = TRUE)
