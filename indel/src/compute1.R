ARGV <- commandArgs(T)
ARGV <- as.numeric(ARGV)
n<- ARGV[1] #which file
max<- ARGV[2] #max length of records
nline<- ARGV[3] #number of records
library(calibrate)

format <- as.numeric(rep(NA,max))
M <- matrix(format,nrow=round(nline/2),ncol = max,byrow=TRUE) #make a matrix

bt <- sample(c(0:(nline-1)),size=round(nline/2),replace=FALSE) #sample 1/2 of the records to plot
for (i in 1:length(bt)){
	tmp<- scan(paste("../data/pair/divergence/",n,".out",sep=""),sep="\t", skip=bt[i], nlines = 1,na.strings = "NA", fill = TRUE)
	M[i,1:length(tmp)]<-tmp
}
#M is modified, store the matrix now.
write.table(M,"./tmp/comupte1R_sampleMatrix",sep="\t",row.names=FALSE,col.names=FALSE)
#incase...restart here from reading files above------------------->>>>>>>>>
library(calibrate)
ns<-apply(M,2,function(x){
length(which(!is.na(x)))
})
ns<-ns[which(ns!=0)]
ls<-apply(M,1,function(x){
length(which(!is.na(x)))
})
#ns is the sample numbers to each d1
#ls ~ d2


m<-apply(M,2,function(x){
	tmp<-x[which(!is.na(x))]#find no-na, the numbers in each column(each d1 value),
	here<-c(mean(tmp),sd(tmp)/sqrt(length(tmp)))#calculate the mean and sd error(sd/squaredrootof n) of valid values, output them
})
d2<-apply(M,1,function(x){#find no-na, the numbers in each line(each d2 value)
        tmp<-x[which(!is.na(x))]#calculate the mean output them
        mean(tmp)
})
#m is d1-D
#d2-D represents itself

#>>>>>>>>>>>>>>>>>>>plot D-d1
colnames(m)<-c(0:(ncol(m)-1))
m<-m[,which(!is.na(m[1,]))]
bar<-matrix(c(m[1,]+m[2,],m[1,],m[1,]-m[2,]),nrow=3,byrow=TRUE)
x<-as.integer(colnames(m)) #x in plot
pdf("D_d1.pdf")
curv<-plot(x,bar[2,],type="o",ylim=c(0,max(bar[2,])+0.05),xlab=c("d1"),ylab=c("Divergence"),axes=FALSE)
axis(1, at=0:max(x),lab=c(0:max(x)))
axis(2, at=seq(0,max(bar[2,])+0.005,0.005),lab=seq(0,max(bar[2,])+0.005,0.005))
arrows(x,bar[1,],x,bar[3,],angle=90,code=3,length=0.03,col=c("red"))
textxy(x,(bar[2,]+0.005),ns,cx=0.8)
dev.off()

#>>>>>>>>>>>>>>>>>>>plot D-d2
##q<-rbind(as.integer(ls),d2)
##q<-q[,order(ls,decreasing=FALSE)]#make q[1](i.e. length of interval a factor)
q_mean<-tapply(d2,as.integer(ls),mean)
q_sd<-tapply(d2,as.integer(ls),function(x){
Sd<-sd(x)
sde<-sd(x)/sqrt(length(x))
sde
})
bar<-matrix(c(q_mean+q_sd,q_mean,q_mean-q_sd),nrow=3,byrow=TRUE)
colnames(bar) <- names(q_mean)
x<-as.integer(colnames(bar)) #x in plot
pdf("D_d2.pdf")
curv<-plot(x,bar[2,],type="o",ylim=c(0,0.2),xlab=c("d2"),ylab=c("Divergence"),axes=FALSE)
axis(1, at=0:max(x),lab=c(0:max(x))) #x axi
axis(2, at=seq(0,1,0.1),lab=seq(0,1,0.1)) #y axi
arrows(x,bar[1,],x,bar[3,],angle=90,code=3,length=0.02,col=c("red")) #add sd range
dev.off()
