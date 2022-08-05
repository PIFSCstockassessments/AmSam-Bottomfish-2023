require(data.table); require(this.path); require(openxlsx); require(ggplot2)

dir <- this.path::here(.. = 2)

# APVI data
D <- data.table( read.xlsx(file.path(dir,"Data","APVI_EVB for SAP.xlsx")) )
D <- select(D,REGION=location,LENGTH_FL=length,AGE=age)

# ETCO data
#D <- data.table( read.xlsx(file.path(dir,"Data","ETCO_MHI preliminary length at age 2022.xlsx")) )
#D <- select(D,SEX,LENGTH_FL=LENGTH_CM,AGE=Final.Age)
#ggplot(data=D,aes(x=AGE,y=LENGTH_FL,col=SEX))+geom_point()

BreakAge <- 3

VB <- function(VBpar,x){ VBpar[1]*(1-exp(-VBpar[2]*(x-VBpar[3]))) }
VB2_Fit <- function(param,BreakAge,x){
  
  Linf<-param[1]; K<-param[2]; a0<-param[3]; Slope<-param[4]
  CV_Young<-param[5]; CV_Old<-param[6]
  
  ExpLength_Yg  <- x[AGE<BreakAge]$AGE*Slope   
  ExpLength_Old <- VB(c(Linf,K,a0),x[AGE>=BreakAge]$AGE)   
  
  SD_Yg  <- 5#ExpLength_Yg*CV_Young
  SD_Old <- ExpLength_Old*CV_Old
  
  NLL_Yg  <- -log(dnorm(x[AGE<BreakAge]$LENGTH_FL,ExpLength_Yg,SD_Yg))
  NLL_Old <- -log(dnorm(x[AGE>=BreakAge]$LENGTH_FL,ExpLength_Old,SD_Old))
  
  return(sum(NLL_Yg,NLL_Old))

}

R1 <- nls(LENGTH_FL~Linf*(1-exp(-K*(AGE-a0))),data=D,start=list(Linf=70,K=0.4,a0=0))
R2 <- optim(VB2_Fit,par=c(73,0.4,-0.5,16,0.1,0.1),BreakAge=BreakAge,x=D)

coef(R1)
R2$par

E                         <- data.table(AGE=seq(from=0,to=max(D$AGE),by=0.5))
E$LENGTH_FL               <- VB(R2$par[1:3],E$AGE)
E[AGE<BreakAge]$LENGTH_FL <- E[AGE<BreakAge]$AGE*R2$par[4]

ggplot()+geom_point(data=D,aes(x=AGE,y=LENGTH_FL))+geom_line(data=E,aes(x=AGE,y=LENGTH_FL),col="red",size=1)+geom_line(aes(x=E$AGE,y=VB(coef(R1),E$AGE)),col="blue",size=1)


