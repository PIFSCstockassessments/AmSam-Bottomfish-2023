require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx); require(ggpmisc)

source("LOAD_Theme.r")
aTheme <- theme_datareport_bar()+theme(panel.grid.major.y = element_blank(),
                                       axis.line = element_line(color="black"),
                                       plot.margin = margin(10, 0, 6, 0),
                                       axis.text.x= element_text(margin = margin(t = 2, r = 0, b = 0, l = 0)))

BS <- readRDS("DATA\\readyBiosamp.rds")
LH <- data.table(read.xlsx("DATA\\METADATA.xlsx",sheet="SPECIES",colNames=TRUE))
LH <- subset(LH,select=c("Species","Sel_L95"))
BS <- merge(BS,LH,by="Species")

BS <- BS[!is.na(Length_FL)]

# Convert to cm
BS$Length_FL <- BS$Length_FL/10
BS$Sel_L95 <- BS$Sel_L95/10


# Some descriptive stats on sample sizes
#----------------------------------------------------------------------------------------

# Samples by gear
G     <- BS[,list(N=sum(Count)),by=list(Species,Method_B)]
G     <- G[order(Species,Method_B)]
#Max.y <- max(G[Method_B!="N/A"]$N)*1.3

ggplot(data=G[Method_B!="N/A"],aes(fill=Method_B,x=reorder(Species,-N,sum),y=N))+geom_bar(position="fill",stat="identity")+
  xlab("Species")+ylab("Count")+scale_fill_manual(values=gear.colors)+aTheme+theme(legend.position="top")+labs(fill="Method")
ggsave("1_OUTPUTS/FIG/BIOS/BIO_GEAR.png",last_plot(),width=6.5,height=3, units="in")

# Samples by area
A     <- BS[,list(N=sum(Count)),by=list(Species,Area_C)]
A     <- A[order(Species,-N)]
Max.y <- max(A[Area_C!="N/A"]$N)*1.1

ggplot(data=A[Area_C!="N/A"],aes(fill=Area_C,x=reorder(Species,-N,sum),y=N))+geom_bar(position="stack",stat="identity")+
  geom_text(aes(label=stat(y), group=Species),stat='summary',fun=sum,vjust=-0.2)+xlab("Species")+ylab("Count")+
  scale_fill_manual(values=area.colors)+scale_y_continuous(expand=c(0,0),limits=c(0,Max.y))+aTheme+
  theme(legend.position=c(.9,.8),legend.justification=c("right", "top"),legend.box.just="right",legend.margin=margin(6,6,6,6))+labs(fill="Area")
ggsave("1_OUTPUTS/FIG/BIOS/BIO_AREA.png",last_plot(),width=6.5,height=3, units="in")

# Sample sizes for main gear and main area by Year
N    <- BS[Method_C==Method1]
N    <- N[,list(N=sum(Count)),by=list(SciName,Species,Year,Area_C)]
NT   <- N[Area_C=="Tutuila",list(N=sum(N)),by=list(SciName,Species,Year)] 

ggplot(data=NT,aes(x=Year,y=N,color=SciName,linetype=SciName))+geom_hline(aes(yintercept=50),color="red",linetype="solid")+geom_line()+scale_y_log10()+geom_point()+
  geom_dl(aes(label=Species),method=list(dl.trans(x=x-.3),"first.bumpup"))+
  geom_dl(aes(label=Species),method=list(dl.trans(x=x+.3),"last.bumpup"))+
  scale_x_continuous(limits=c(2010.5,2015.5))+scale_color_manual(values=species.colors)+
  scale_linetype_manual(values=species.linetypes)+aTheme+theme(legend.position="none", panel.grid.major.y=element_line(color="black"))+xlab("Year")+ylab("Count")
ggsave("1_OUTPUTS/FIG/BIOS/BIO_TIME.png",last_plot(),width=6.5,height=3, units="in")

#----------Size structure by Year-------------------------------------
NTB  <- BS[Area_C=="Tutuila"&Method_C==Method1,list(N=.N,Lbar=mean(Length_FL)),by=list(Species,Year)]
NTB  <- NTB[,list(Mean_N=mean(N),OLbar=mean(Lbar)),by=list(Species)]
NTB  <- NTB[order(-Mean_N)]

NTB$An            <- "None"
NTB[Mean_N>15]$An <- "Sum_Years"
NTB[Mean_N>50]$An <- "Ind_Years"

BS   <- merge(BS,NTB,by="Species")
E    <- BS[Length_FL>=Sel_L95&Area_C=="Tutuila"&Method_C==Method1,list(Lbar=mean(Length_FL),Sd=sd(Length_FL),N=.N),by=list(Species,SciName,Year,OLbar)]
E$Se <- E$Sd/sqrt(E$N)

ggplot(data=E,aes(x=Year, y=Lbar,col=SciName,linetype=SciName))+geom_line(size=1)+ylim(20,max(E$Lbar))+geom_point()+
  scale_color_manual(values=species.colors)+scale_linetype_manual(values=species.linetypes)+
  geom_dl(aes(label=Species),method=list(dl.trans(x=x-.3),"first.bumpup"))+
  geom_dl(aes(label=Species),method=list(dl.trans(x=x+.3),"last.bumpup"))+
  scale_x_continuous(limits=c(2010.5,2015.5))+aTheme+theme(legend.position="none")+xlab("Year")+ylab("Mean length (cm)")
ggsave(paste0("1_OUTPUTS/FIG/BIOS/BIO_Lbar.png"),last_plot(),width=6.5,height=3, units="in")

# Yearly size structure plots
Species.list <- unique(BS$Species)
BW <- function(data){  return (  round(    ( max(data$Length_FL)-min(data$Length_FL) )/(  log2(nrow(data))+1  )  )   )            }
for(i in 1:length(Species.list)){
 
 aSpecies <- Species.list[i]
  
 Glist <- list()
 
 D <- BS[Method_B==Method1&Species==aSpecies]
 Analysis <- NTB[Species==aSpecies]$An
 
 Year.list <- unique(D$Year)
 Year.list <- Year.list[order(Year.list)]
 if(Analysis=="None") next
 if(Analysis=="Ind_Years"){
    for(j in 1:length(Year.list)){
    
    aYear <- Year.list[j]
    aD    <- D[Year==aYear]
    anN   <- nrow(aD)
    #if(nrow(aD)<10) next
    Glist[[j]] <- ggplot(data=aD)+geom_histogram(aes(x=Length_FL),binwidth=BW(aD),col="black",fill="cadetblue3",lwd=0.2)+
      annotate("text_npc",npcx=0.9,npcy=0.9,size=3,label=aYear)+
      annotate("text_npc",npcx=0.05,npcy=0.9,size=3,label=paste0("n=",anN))+
      scale_y_continuous(expand = c(0, 0), limits = c(0,NA))+xlab("Fork length (cm)")+ylab("Count")+aTheme  
    }
  }
  if(Analysis=="Sum_Years"){
    anN   <- nrow(D)
    Glist[[1]] <- ggplot(data=D)+geom_histogram(aes(x=Length_FL),binwidth=BW(D),col="black",fill="cadetblue3",lwd=0.2)+
    annotate("text_npc",npcx=0.05,npcy=0.9,size=3,label=paste0("n=",anN))+
    scale_y_continuous(expand = c(0, 0), limits = c(0,NA))+xlab("Fork length (cm)")+ylab("Count")+aTheme  
  }  
 Graph.Number <- length(Glist)
 Col.Number   <- ifelse(Graph.Number>1,2,1)
 Col.Width    <- ifelse(Graph.Number>1,15,6)
 Col.Height   <- ifelse(Graph.Number>=3,12,ifelse(Graph.Number==2,6,ifelse(Graph.Number==1,6)))

 Grid <- arrangeGrob(grobs=Glist, ncol=Col.Number)
 ggsave(paste0("1_OUTPUTS/FIG/BIOS/BIO_SIZE_",Species.list[i],".png"),Grid,width=Col.Width,height=Col.Height, units="cm")
}
  
# All years together size structure plot

Glist <- list()
BW <- function(data){  return (  round(    ( max(data$Length_FL)-min(data$Length_FL) )/(  log2(nrow(data))+1  )  )   )            }
for(i in 1:length(Species.list)){

  aSpecies <- Species.list[i]
  D        <- BS[Method_C==Method1&Species==aSpecies]
  aBW      <- BW(D)
  
  Glist[[i]] <- ggplot(data=D)+geom_histogram(aes(x=Length_FL),binwidth=aBW,color="black",fill="cadetblue3",)+ggtitle(aSpecies)+
                   aTheme+annotate("text_npc",npcx=0.05,npcy=0.9,size=3,label=paste0("n=",nrow(D)))+xlab("Length (cm FL)")+
                   theme(plot.margin=margin(t=0,r=5,b=2.0), axis.title.x=element_text(margin=margin(0,0,0,0)))
                  
  if(i==1|i==4|i==7)           Glist[[i]]<-Glist[[i]]+labs(x="")#theme(axis.title.x=element_blank())
  if(i==2|i==3|i==5|i==6|i==8) Glist[[i]]<-Glist[[i]]+labs(x="",y="")#theme(axis.title.x=element_blank(),axis.title.y=element_blank())
  if(i==9|i==11)               Glist[[i]]<-Glist[[i]]+labs(y="")#theme(axis.title.y=element_blank())
}

G.All <- grid.arrange(grobs=Glist,ncol=3)
ggsave(filename="1_OUTPUTS/FIG/BIOS/BIO_SIZE_ALL.tiff",G.All,units="cm",width=15,height=18,
       pointsize=8,compression="lzw",dpi=600)  

#-----------L99th--------------------------------------

#Results <- matrix(nrow=1000,ncol=1)
#D1 <- D[Length>16]
#for(i in 1:1000){
  
#  aDataset   <- D1[sample(1:nrow(D),replace=T,)]
#  Results[i] <- quantile(aDataset$Length,probs=0.99,na.rm=T)    
#}

#hist(Results,col="Light blue")
#mean(Results);sd(Results)





