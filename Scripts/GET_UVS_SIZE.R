require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx); require(ggpmisc);require(directlabels);

source("LOAD_Theme.r")
aTheme <- theme_datareport_bar()+theme(panel.grid.major.y = element_blank(),
                                       axis.line = element_line(color="black"),
                                       plot.margin = margin(10, 0, 6, 0),
                                       axis.text.x= element_text(margin = margin(t = 2, r = 0, b = 0, l = 0)))

US <- readRDS("DATA\\readyUVS.rds")
US <- US[Area_A!="Rose"&Area_A!="Swains"]

# Convert to cm
US$Length_TL <- US$Length_TL/10


# Explore sample size by island, year, species
SPECIES.CODE         <- data.table(  read.xlsx("DATA/METADATA.xlsx",sheet="SPECIES")  )
SPECIES.CODE         <- subset(SPECIES.CODE,select=c("Species"))
N                    <- merge(US,SPECIES.CODE,by="Species")

# Samples by area
A     <- N[,list(N=sum(Count)),by=list(Species,Area_A)]
A     <- A[order(Species,-N)]
Max.y <- max(A[Area_A!="N/A"]$N)*1.3


ggplot(data=A[Area_A!="N/A"],aes(fill=Area_A,x=reorder(Species,-N,sum),y=N))+geom_bar(position="stack",stat="identity")+
  geom_text(aes(label=stat(y), group=Species),stat='summary',fun=sum,vjust=-0.2)+xlab("Species")+ylab("Count")+
  scale_fill_manual(values=area.colors,labels=c("Manu'a","Tutuila North","Tutuila South"))+scale_y_continuous(expand=c(0,0),limits=c(0,Max.y))+aTheme+
  theme(legend.position=c(.9,.8),legend.justification=c("right", "top"),legend.box.just="right",legend.margin=margin(6,6,6,6))+labs(fill="Area")
ggsave("1_OUTPUTS/FIG/UVS/UVS_AREA.png",last_plot(),width=6.5,height=3, units="in")

# Sample by time
T    <- N[,list(N=sum(Count)),by=list(Species,SciName,Area_C,Year)]

ggplot(data=T,aes(x=Year,y=N,color=SciName,linetype=SciName))+geom_hline(aes(yintercept=50),color="red",linetype="solid")+geom_line()+scale_y_log10()+geom_point()+
  geom_dl(aes(label=Species),method=list(dl.trans(x=x-.3),"first.bumpup"))+
  geom_dl(aes(label=Species),method=list(dl.trans(x=x+.3),"last.bumpup"))+
  scale_x_continuous(limits=c(2000,2021))+scale_color_manual(values=species.colors)+
  scale_linetype_manual(values=species.linetypes)+aTheme+theme(legend.position="none", panel.grid.major.y=element_line(color="black"))+xlab("Year")+ylab("Count")+facet_wrap(~ Area_C)
ggsave("1_OUTPUTS/FIG/UVS/UVS_TIME.png",last_plot(),width=8,height=4, units="in")

# Species specific size structure graphs
NTB  <- N[Area_C=="Tutuila",list(N=sum(Count)),by=list(Species,Year)]
NTB  <- NTB[,list(Mean_N=mean(N)),by=list(Species)]
NTB  <- NTB[order(-Mean_N)]

NTB$An            <- "None"
NTB[Mean_N>5]$An  <- "Sum_Years"
NTB[Mean_N>50]$An <- "Ind_Years"


Species.list <- unique(N$Species)
BW <- function(data){  return (  round(    ( max(data$Length_TL)-min(data$Length_TL) )/(  log2(nrow(data))+1  )  )   )            }
for(i in 1:length(Species.list)){

  aSpecies <- Species.list[i]
  
  Glist <- list()
  
  D        <- N[Species==aSpecies&Area_C=="Tutuila"]
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
      Glist[[j]] <- ggplot(data=aD)+geom_histogram(aes(x=Length_TL),binwidth=BW(aD),col="black",fill="cadetblue3",lwd=0.2)+
        annotate("text_npc",npcx=0.9,npcy=0.9,size=3,label=aYear)+
        annotate("text_npc",npcx=0.05,npcy=0.9,size=3,label=paste0("n=",anN))+
        scale_y_continuous(expand = c(0, 0), limits = c(0,NA))+xlab("Fork length (cm)")+ylab("Count")+aTheme  
    }
  }
  if(Analysis=="Sum_Years"){
    anN   <- nrow(D)
    Glist[[1]] <- ggplot(data=D)+geom_histogram(aes(x=Length_TL),binwidth=BW(D),col="black",fill="cadetblue3",lwd=0.2)+
      annotate("text_npc",npcx=0.05,npcy=0.9,size=3,label=paste0("n=",anN))+
      scale_y_continuous(expand = c(0, 0), limits = c(0,NA))+xlab("Total length (cm)")+ylab("Count")+aTheme  
  }  
  Graph.Number <- length(Glist)
  Col.Number   <- ifelse(Graph.Number>1,2,1)
  Col.Width    <- ifelse(Graph.Number>1,15,6)
  Col.Height   <- ifelse(Graph.Number>=3,20,ifelse(Graph.Number==2,6,ifelse(Graph.Number==1,6)))
  
  Grid <- arrangeGrob(grobs=Glist, ncol=Col.Number)
  ggsave(paste0("1_OUTPUTS/FIG/UVS/UVS_SIZE_",Species.list[i],".png"),Grid,width=Col.Width,height=Col.Height, units="cm")
}

# All years together size structure plot

Glist <- list()
BW <- function(data){  return (  round(    ( max(data$Length_TL)-min(data$Length_TL) )/(  log2(nrow(data))+1  )  )   )            }
Species.list <- Species.list[Species.list!="CALU"]
for(i in 1:length(Species.list)){
  
  aSpecies <- Species.list[i]
  D        <- N[Species==aSpecies&Area_C=="Tutuila"&Count==1&Year>=2008]
  aBW      <- BW(D)
  
  Glist[[i]] <- ggplot(data=D)+geom_histogram(aes(x=Length_TL),binwidth=aBW,color="black",fill="cadetblue3",)+ggtitle(aSpecies)+
    aTheme+annotate("text_npc",npcx=0.05,npcy=0.9,size=3,label=paste0("n=",nrow(D)))+xlab("Length (cm TL)")+
  theme(plot.margin=margin(t=0,r=8,b=10), axis.title.x=element_text(margin=margin(0,0,0,0)))
  
  #if(i==1|i==4|i==7)           Glist[[i]]<-Glist[[i]]+labs(x="")#theme(axis.title.x=element_blank())
  #if(i==2|i==3|i==5|i==6|i==8) Glist[[i]]<-Glist[[i]]+labs(x="",y="")#theme(axis.title.x=element_blank(),axis.title.y=element_blank())
  #if(i==9|i==11)               Glist[[i]]<-Glist[[i]]+labs(y="")#theme(axis.title.y=element_blank())
}

G.All <- grid.arrange(grobs=Glist,ncol=2)
ggsave(filename="1_OUTPUTS/FIG/UVS/UVS_SIZE_ALL_TUTUILA.tiff",G.All,units="cm",width=10,height=10,
       pointsize=8,compression="lzw",dpi=600)  


# Explore CPUE index for UVS
R <- US[(Obs_Type=="I"|Obs_Type=="N"|Obs_Type=="F")&Method=="nSPC"]
R <- R[,list(Count=sum(Count)),by=list(Year,Island,Area,Area_Weight,Area_A,Area_B,Area_C,SiteVisitID,SciName,Species)]

# Calculate # of sites by year and region
NSites <- R[,list(Count=sum(Count)),by=list(Year,Area_C,SiteVisitID)]
NSites <- NSites[,list(N=.N),by=list(Year,Area_C)]
NSites <- NSites[order(Year,Area_C)]

# No of sites surveyed by year and area
ggplot(data=NSites,aes(x=Year,y=N,color=Area_C))+geom_line()+geom_point()+
  geom_dl(aes(label=Area_C),method=list(dl.trans(x=x+1,y=y+.5),"first.bumpup"))+
  aTheme+theme(legend.position="none", panel.grid.major.y=element_line(color="black"))+xlab("Year")+ylab("Count")
ggsave("1_OUTPUTS/FIG/UVS/UVS_N_TIME.png",last_plot(),width=8,height=4, units="in")


# Prop. of sightings of each species on UVS
Species.bfish <- data.table(  read.xlsx("DATA/METADATA.xlsx",sheet="SPECIES")  )
Species.bfish <- subset(Species.bfish,select=c("Species"))

T <- R[,list(Count=sum(Count)),by=list(Species,Area_C, SiteVisitID)]
T <- T[,list(N=.N),by=list(Species,Area_C)]
T <- merge(T,Species.bfish)

NSites.T <- NSites[,list(N.Tot=sum(N)),by=list(Area_C)]
T      <- merge(T,NSites.T,by="Area_C") 
T$Prop <- round(T$N/T$N.Tot,2) 


ggplot(data=T[Species!="CALU"],aes(x=Species,y=Prop, fill=Area_C))+geom_bar(position="dodge",stat="identity")+
  geom_text(aes(label=stat(y)),position = position_dodge(width = 0.8),vjust=-0.6)+aTheme+
  annotate("text_npc",npcx=0.05,npcy=0.9,size=3,label="Manu'a I. # of sites = 318")+
  annotate("text_npc",npcx=0.05,npcy=0.85,size=3,label="Tutuila # of sites = 534")+
  scale_fill_manual(values=area.colors,labels=c("Manu'a","Tutuila"))+
  scale_y_continuous(expand = c(0, 0), limits = c(0,0.45))+
  theme(legend.position=c(.9,.8),legend.justification=c("right", "top"),legend.box.just="right",legend.margin=margin(6,6,6,6),legend.title=element_blank())
ggsave("1_OUTPUTS/FIG/UVS/UVS_PROP.png",last_plot(),width=8,height=4, units="in")







