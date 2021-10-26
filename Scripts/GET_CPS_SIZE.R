require(data.table); require(ggplot2); require(gridExtra); require(directlabels);require(openxlsx); require(ggpmisc)

source("LOAD_Theme.r")
aTheme <- theme_datareport_bar()+theme(panel.grid.major.y = element_blank(),
                                       axis.line = element_line(color="black"),
                                       plot.margin = margin(10, 0, 6, 0),
                                       axis.text.x= element_text(margin = margin(t = 2, r = 0, b = 0, l = 0)))

Z  <- readRDS("DATA\\readyDRS.rds")
LH <- data.table(read.xlsx("DATA\\METADATA.xlsx",sheet="SPECIES",colNames=TRUE))
LH <- subset(LH,select=c("Species","Sel_L95"))
Z  <- merge(Z,LH,by="Species")

Z <- Z[Area_C!="Rose"&Area_C!="Swains"]

# Descriptive statistics of Num_Pieces, Area, Method (how many N/a?)

Z$Num_Pieces2 <- as.character(Z$Num_Pieces)
Z[Num_Pieces>1]$Num_Pieces2 <- ">1"

glist <- list()
Za <- Z[,list(N=.N),by=list(Num_Pieces2)]
glist[[1]] <- ggplot(data=Za,aes(x=Num_Pieces2,y=N))+geom_bar(stat="identity",fill="darkblue")+scale_x_discrete(limits = c("0","1",">1"))+geom_text(aes(label=N),vjust=-.2)+
  xlab("Number of pieces reported")+aTheme
#ggsave("1_OUTPUTS/FIG/DRS/DRS_NUMPIECES.png",last_plot(),width=5,height=5, units="in")

Zb <- Z[,list(N=.N),by=list(Area_C)]
glist[[2]] <- ggplot(data=Zb,aes(x=reorder(Area_C,-N),y=N))+geom_bar(stat="identity",fill="darkblue")+geom_text(aes(label=N),vjust=-.2)+
  xlab("Fished area")+aTheme
#ggsave("1_OUTPUTS/FIG/DRS/DRS_AREA.png",last_plot(),width=5,height=5, units="in")

Z[is.na(Method_C)]$Method_C <- "N/A"
Zc <- Z[Year>=2010,list(N=.N),by=list(Method_C)]
glist[[3]] <- ggplot(data=Zc,aes(x=reorder(Method_C,-N),y=N))+geom_bar(stat="identity",fill="darkblue")+geom_text(aes(label=N),vjust=-.2)+
  xlab("Fishing gear")+aTheme
#ggsave("1_OUTPUTS/FIG/DRS/DRS_GEAR.png",last_plot(),width=5,height=5, units="in")

Zd <- Z[Year>=2010&Num_Pieces>0,list(N=.N),by=list(Species)]
glist[[4]] <- ggplot(data=Zd,aes(x=reorder(Species,-N),y=N))+geom_bar(stat="identity",fill="darkblue")+geom_text(aes(label=N),vjust=-.2)+
  xlab("Species")+aTheme
#ggsave("1_OUTPUTS/FIG/DRS/DRS_SPECIES.png",last_plot(),width=5,height=5, units="in")

G.All <- grid.arrange(grobs=glist,ncol=2)
ggsave(filename="1_OUTPUTS/FIG/DRS/DRS_N.tiff",G.All,units="cm",width=18,height=17,
       pointsize=8,compression="lzw",dpi=600)  

Ze <- Z[Num_Pieces>0,list(N=.N),by=list(Year, Species,SciName)]
ggplot(data=Ze,aes(x=Year,y=N,color=SciName,linetype=SciName))+geom_hline(aes(yintercept=50),color="red",linetype="solid")+geom_line()+scale_y_log10()+geom_point()+
  geom_dl(aes(label=Species),method=list(dl.trans(x=x-.3),"first.bumpup"))+
  geom_dl(aes(label=Species),method=list(dl.trans(x=x+.3),"last.bumpup"))+
  scale_x_continuous(limits=c(1988,2022))+scale_color_manual(values=species.colors)+
  scale_linetype_manual(values=species.linetypes)+aTheme+theme(legend.position="none", panel.grid.major.y=element_line(color="black"))+xlab("Year")+ylab("Count")
ggsave("1_OUTPUTS/FIG/DRS/DRS_N_TIME.png",last_plot(),width=6.5,height=3, units="in")




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
