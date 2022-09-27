require(data.table); require(this.path); require(openxlsx); require(ggplot2); require(tidyverse);options(scipen = 999)

dir <- this.path::here(.. = 2)

# APVI data
#D <- data.table( read.xlsx(file.path(dir,"Data","APVI_EVB for SAP.xlsx")) )
#D <- select(D,REGION=location,LENGTH_FL=length,AGE=age)

# ETCO data
D <- data.table( read.xlsx(file.path(dir,"Data","ETCO_MHI preliminary length at age 2022.xlsx")) )
D <- select(D,SEX,LENGTH_FL=LENGTH_CM,AGE=Final.Age)
ggplot(data=D,aes(x=AGE,y=LENGTH_FL,col=SEX))+geom_point()

# Remove 3 outliers
D <- D[!(AGE==23&LENGTH_FL==55.9)&!(AGE==20&LENGTH_FL==63.6)&!(AGE==16&LENGTH_FL==53)]
ggplot(data=D,aes(x=AGE,y=LENGTH_FL,col=SEX))+geom_point()

BreakAge <- 0

VB       <- function(VBpar,x){ VBpar[1]*(1-exp(-VBpar[2]*(x-VBpar[3]))) }
VB_FixA0 <- function(VBpar,x){ VBpar[1]*(1-exp(-VBpar[2]*(x))) }

VB2_Fit <- function(param,BreakAge,x){
  
  Linf<-param[1]; K<-param[2]; a0<-param[3]; Slope<-param[4]; SD_Yg<-param[5]; CV_Old<-param[6]
  
  #ExpLength_Yg  <- x[AGE<BreakAge]$AGE*Slope   
  ExpLength_Old <- VB(c(Linf,K,a0),x[AGE>=BreakAge]$AGE)   
  
  SD_Old <- ExpLength_Old*CV_Old
  
  #NLL_Yg  <- -log(dnorm(x[AGE<BreakAge]$LENGTH_FL,ExpLength_Yg,SD_Yg))
  NLL_Old <- -log(dnorm(x[AGE>=BreakAge]$LENGTH_FL,ExpLength_Old,SD_Old))
  
  #return(sum(NLL_Yg,NLL_Old))
  return(sum(NLL_Old))
  
}

# Females
R1F <- nls(LENGTH_FL~Linf*(1-exp(-K*(AGE))),data=D[SEX=="F"|SEX=="U"],start=list(Linf=70,K=0.4))
R2F <- nlm(VB2_Fit,p=c(60,0.25,-5,16,5,0.12),BreakAge=BreakAge,x=D[SEX=="F"|SEX=="U"])

# Males
R1M <- nls(LENGTH_FL~Linf*(1-exp(-K*(AGE))),data=D[SEX=="M"|SEX=="U"],start=list(Linf=70,K=0.4))
R2M <- nlm(VB2_Fit,p=c(60,0.25,-5,16,5,0.12),BreakAge=BreakAge,x=D[SEX=="M"|SEX=="U"])


#coef(R1)
R2F$estimate
R2M$estimate
R1F; R1M

E              <- data.table(AGE=seq(from=0,to=max(D$AGE),by=0.5))
E$LENGTH_FL_F  <- VB(R2F$estimate[1:3],E$AGE)
E$LENGTH_FL_M  <- VB(R2M$estimate[1:3],E$AGE)

#E[AGE<BreakAge]$LENGTH_FL <- E[AGE<BreakAge]$AGE*R2$estimate[4]

ggplot()+geom_point(data=D,aes(x=AGE,y=LENGTH_FL,col=SEX))+
  geom_line(data=E,aes(x=AGE,y=LENGTH_FL_F),col="red",size=1)+
  geom_line(data=E,aes(x=AGE,y=LENGTH_FL_M),col="blue",size=1)+
  geom_line(aes(x=E$AGE,y=VB_FixA0(coef(R1F),E$AGE)),col="red",size=0.5,linetype="dashed")+
  geom_line(aes(x=E$AGE,y=VB_FixA0(coef(R1M),E$AGE)),col="blue",size=0.5,linetype="dashed")
  


