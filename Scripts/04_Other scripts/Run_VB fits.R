require(data.table); require(this.path); require(openxlsx); require(ggplot2); require(tidyverse);options(scipen = 999)

dir <- this.path::here(.. = 2)

# APVI data
D <- data.table( read.xlsx(file.path(dir,"Data","APVI_EVB for SAP.xlsx")) )
D <- select(D,REGION=location,LENGTH_FL=length,AGE=age)

# ETCO data
#D <- data.table( read.xlsx(file.path(dir,"Data","ETCO_MHI preliminary length at age 2022.xlsx")) )
#D <- select(D,SEX,LENGTH_FL=LENGTH_CM,AGE=Final.Age)
#ggplot(data=D,aes(x=AGE,y=LENGTH_FL,col=SEX))+geom_point()


# VALO data
#D <- data.table( read.csv(file.path(dir,"Data","VALO LH data.csv")) )
#ggplot(data=D,aes(x=AGE,y=LENGTH_FL))+geom_point()


BreakAge <- 3


VB <- function(VBpar,x){ VBpar[1]*(1-exp(-VBpar[2]*(x-VBpar[3]))) }
VB.T0 <- function(VBpar,x){ VBpar[1]*(1-exp(-VBpar[2]*(x))) }

VB2_Fit <- function(param,BreakAge,x){
  
  Linf<-param[1]; K<-param[2]; a0<-param[3]; Slope<-param[4]; SD_Yg<-param[5]; CV_Old<-param[6]
  
  ExpLength_Yg  <- x[AGE<BreakAge]$AGE*Slope   
  ExpLength_Old <- VB(c(Linf,K,a0),x[AGE>=BreakAge]$AGE)   
  
  SD_Old <- ExpLength_Old*CV_Old
  
  NLL_Yg  <- -log(dnorm(x[AGE<BreakAge]$LENGTH_FL,ExpLength_Yg,SD_Yg))
  NLL_Old <- -log(dnorm(x[AGE>=BreakAge]$LENGTH_FL,ExpLength_Old,SD_Old))
  
  return(sum(NLL_Yg,NLL_Old))
  #return(sum(NLL_Old))
  
}

R0 <- nls(LENGTH_FL~Linf*(1-exp(-K*(AGE))),data=D,start=list(Linf=70,K=0.4))
R1 <- nls(LENGTH_FL~Linf*(1-exp(-K*(AGE-a0))),data=D,start=list(Linf=70,K=0.4,a0=0))
R1.NoYoung <- nls(LENGTH_FL~Linf*(1-exp(-K*(AGE-a0))),data=D[AGE>=BreakAge],start=list(Linf=76,K=0.1,a0=-2))
R2 <- nlm(VB2_Fit,p=c(76.9,0.13,-2,10,4.6,0.1),BreakAge=BreakAge,x=D)


#coef(R1)
R2$estimate

E                         <- data.table(AGE=seq(from=0,to=max(D$AGE),by=0.5))
E$LENGTH_FL               <- VB(R2$estimate[1:3],E$AGE)
E[AGE<BreakAge]$LENGTH_FL <- E[AGE<BreakAge]$AGE*R2$estimate[4]

ggplot()+geom_point(data=D,aes(x=AGE,y=LENGTH_FL))+
  geom_line(data=E,aes(x=AGE,y=LENGTH_FL),col="red",size=1)+
  geom_line(aes(x=E$AGE,y=VB(coef(R1),E$AGE)),col="blue",size=1)+
  geom_line(aes(x=E$AGE,y=VB.T0(coef(R0),E$AGE)),col="orange",size=1)+
  scale_y_continuous(expand=c(0,0),limits=c(0,NA))

VB(R2$estimate[1:3],3)

