# Line chart of units allocated to industry 

svg(filename ="Industrial-Allocation-line-2010-2020-720-540-v1.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white") 
#png("Industrial-Allocation-line-2010-2020-560by420-v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(2.7,2.7,1,1)+0.1)
plot(Annualallocations[["Year"]],Annualallocations[["Allocation"]],ylim=c(0,10), xlim=c(2010,2020),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0, lwd = 1, at = c(2010:2020), labels = c(2010:2020), tick = TRUE)
axis(side=2, tck=0.01, las=2, line = NA,lwd = 1, at = c(0:8), labels = c(0:8),tick = TRUE)
axis(side=4, tck=0.01, at = c(0:8), labels = FALSE, tick = TRUE)
box(lwd=1)
lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",lwd=1,lty=1) # shocking pink
points(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",pch=19)
mtext(side=1,line=-1.5,cex=1,"Source: EPA industrial allocation decisions")
mtext(side=3,cex=1.5, line=-2.2,expression(paste("Industrial Allocation emission units allocated to industry 2010 to 2020")) )
mtext(side=2,cex=1, line=-1.5,expression(paste("million units")))
mtext(side=3,line=-3.5,cex=1,expression(paste("From 2010 to 2020 55 million free emission units were given to industries")))
mtext(side=4,cex=0.75, line=0.05,R.version.string)
dev.off()


# check last 11 years of Industry emissions from inventory 2010 2020
crfsummarydatasector[["Industry"]][21:31]
[1] 4591.133 4627.387 4703.190 4836.346 5006.981 5137.323 4883.073 4928.440
[9] 4825.074 4861.046 4618.354  
# create vector that is industry emissions 11 years to 2020 restated in million tonnes 
Annualallocations[["IndustryGHG"]] <- crfsummarydatasector[["Industry"]][21:31]/10^3
Annualallocations[["IndustryGHG"]]
[1] 4.591133 4.627387 4.703190 4.836346 5.006981 5.137323 4.883073 4.928440
 [9] 4.825074 4.861046 4.618354
# what were actual emissions from 2009 to 2020? 53 million tonnes
sum(Annualallocations[["IndustryGHG"]])
[1] 53.01835 

# create vector that is the '1 for 2' discount given for surrendering units emissions; 1 NZU for 2 tonnes GHG
# create variable that is the 'two-for-one' discount - 2 tonnes = 1 unit to surrender  add unit discount variable to the data frame
https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Guidance/ETS-Surrender-Obligations-One-for-two-phase-out-factsheet.pdf
https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/participating-in-the-ets/surrendering-units/
# "Phase out of the '1 for 2' surrender obligation, Prior to 2017, non-forestry participants had to surrender one eligible unit for every two tonnes of emissions they reported in their Annual emissions return, effectively a 50% surrender obligation. 2017 - 1 unit for each 1.5 whole tonnes of emissions 2018 - 1 unit for each 1.2 whole tonnes of emissions 2019 - 1 unit for each 1 whole tonne of emissions"
# 2010 was a half year for ETS so the 'discount' for calculating emissions liability under the ETS is .5 x .5 = 0.25

Annualallocations[["unitdiscount"]] <- c(0.25,0.5,0.5,0.5,0.5,0.5,0.5,0.67,0.83,1,1)

# create variable that is the emissions permitted by each years allocation of free units in mts i.e. 2 tonnes for 1 NZU
Annualallocations[["AllocatedGHG"]] <- Annualallocations[["Allocation"]]/Annualallocations[["unitdiscount"]]

str(Annualallocations)
'data.frame':	11 obs. of  5 variables:
 $ Year        : num  2010 2011 2012 2013 2014 ...
 $ Allocation  : num  1.76 3.46 3.45 4.82 4.48 ...
 $ unitdiscount: num  0.25 0.5 0.5 0.5 0.5 0.5 0.5 0.67 0.83 1 ...
 $ IndustryGHG : num  4.59 4.63 4.7 4.84 5.01 ...
 $ AllocatedGHG: num  7.05 6.92 6.9 9.63 8.97 ...
# make csv file of allocations data
write.table(Annualallocations, file = "Annualallocations.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 
# read in csv file
Annualallocations<-read.csv("Annualallocations.csv") 
Annualallocations[["Allocation"]] 
[1] 1.763232 3.461556 3.451147 4.815810 4.484100 4.369366 4.307558 5.606415 6.744229 8.282779 7.715722
sum(Annualallocations[["Allocation"]]) 
[1] 55.00191 
# What are the Industry sector emissions ?
Annualallocations[["IndustryGHG"]]
[1] 4.591133 4.627387 4.703190 4.836346 5.006981 5.137323 4.883073 4.928440 4.825074 4.861046 4.618354 
What is the sum of emissions from Industry for the 11 years ?
sum(Annualallocations[["IndustryGHG"]])
[1] 53.01835 
# check the actual emissions permitted by the free units after factoring in the two for one discount 
Annualallocations[["AllocatedGHG"]]
 [1] 7.052928 6.923112 6.902294 9.631620 8.968200 8.738732 8.615116 8.367784 8.125577 8.282779 7.715722

# What is the emissions footprint of industrial allocation? How many tonnnes of emissions were permitted by the allocations to industry? 89 million
sum(Annualallocations[["AllocatedGHG"]]) 
[1] 89.32386 
 
# plot 1 line chart of units allocated to industry 
svg(filename ="Industrial-Allocation-line-2010-2020-720-540-v1.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white") 
#png("Industrial-Allocation-line-2010-2020-560by420-v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4.7,2.7,1,1)+0.1)
plot(Annualallocations[["Year"]],Annualallocations[["Allocation"]],ylim=c(0,10), xlim=c(2010,2020),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0, lwd = 1, at = c(2010:2020), labels = c(2010:2020), tick = TRUE)
axis(side=2, tck=0.01, las=2, line = NA,lwd = 1, at = c(0:10), labels = c(0:10),tick = TRUE)
axis(side=4, tck=0.01, at = c(0:10), labels = FALSE, tick = TRUE)
box(lwd=1)
lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",lwd=1,lty=1)                    #cerise/pink
points(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",pch=17)                        
mtext(side=1,line=3.3,cex=1,"Source: EPA industrial allocation decisions \nNew Zealands Greenhouse Gas Inventory 1990–2020, April 2022, ME 1635")
mtext(side=3,cex=1.5, line=-2.2,expression(paste("Industrial allocation of units to industry 2010 to 2020")) )
mtext(side=2,cex=1, line=1.8,expression(paste("million units/tonnes")))
mtext(side=3,line=-4,cex=1.2,expression(paste("From 2010 to 2020 53 million emission units were given to industry")))
mtext(side=4,cex=0.75, line=0.05,R.version.string)
dev.off()

sum(Annualallocations[["IndustryGHG"]])
[1] 53.01835
# plot 2 line chart of industry emissions and units allocated to industry 
svg(filename ="Industrial-Allocation-line-2010-2020-720-540-v2.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white") 
png("Industrial-Allocation-line-2010-2020-560by420-v2.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4.7,2.7,1,1)+0.1) 
plot(Annualallocations[["Year"]],Annualallocations[["Allocation"]],ylim=c(0,10), xlim=c(2010,2020),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0, lwd = 1, at = c(2010:2020), labels = c(2010:2020), tick = TRUE)
axis(side=2, tck=0.01, las=2, line = NA,lwd = 1, at = c(0:10), labels = c(0:10),tick = TRUE)
axis(side=4, tck=0.01, at = c(0:10), labels = FALSE, tick = TRUE)
box(lwd=1)
legend("bottom", inset=c(0.0,0.0) ,bty="n",cex=1.2,c("Actual industry emissions 53 million tonnes","Industrial allocation of units 55 million units"),col=c("#d95f02","#E7298A"),lwd=1, pch=c(16,17))
lines(Annualallocations[["Year"]],Annualallocations[["IndustryGHG"]],col="#d95f02",lwd=1)
points(Annualallocations[["Year"]],Annualallocations[["IndustryGHG"]],col="#d95f02",cex=1,pch=16)
lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",lwd=1,lty=1)                 
points(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",pch=17)                       
mtext(side=1,line=3.3,cex=1,"Source: EPA industrial allocation decisions \nNew Zealands Greenhouse Gas Inventory 1990–2020, April 2022, ME 1635")
mtext(side=3,cex=1.6, line=-2.2,expression(paste("Industrial allocation of units to industry 2010 to 2020")) )
mtext(side=2,cex=1.1, line=1.8,expression(paste("million units/tonnes")) )
mtext(side=4,cex=1, line=0.05,R.version.string)
dev.off()

# plot 3 line chart of emissions footprint of industrial allocation ( not industry emissions and units allocated to industry )
svg(filename ="Industrial-Allocation-line-2010-2020-720-540-v3.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white") 
#png("Industrial-Allocation-line-2010-2020-560by420-v3.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4.7,2.7,1,1)+0.1) # 
plot(Annualallocations[["Year"]],Annualallocations[["AllocatedGHG"]], xlim=c(2010,2020),ylim=c(4,11),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0, lwd = 1, at = c(2010:2020), labels = c(2010:2020), tick = TRUE)
axis(side=2, tck=0.01, las=2, line = NA,lwd = 1, at = c(0:10), labels = c(0:10),tick = TRUE)
axis(side=4, tck=0.01, at = c(0:10), labels = FALSE, tick = TRUE)
box(lwd=1)
#legend("bottom", inset=c(0.0,0.0) ,bty="n",c("Emissions footprint of industrial allocation 89 million tonnes","Actual industry emissions 44 million tonnes","Industrial allocation of units 39 million units"),col=c("#1b9e77","#d95f02","gray"),pch=c(15,16,17))
lines(Annualallocations[["Year"]],Annualallocations[["AllocatedGHG"]],col="#1b9e77",lwd=1)      # Mountain Meadow
points(Annualallocations[["Year"]],Annualallocations[["AllocatedGHG"]],col="#1b9e77",cex=1,pch=15)
#lines(Annualallocations[["Year"]],Annualallocations[["IndustryGHG"]],col="#d95f02",lwd=1)
#points(Annualallocations[["Year"]],Annualallocations[["IndustryGHG"]],col="#d95f02",cex=1,pch=16)
#lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",lwd=1,lty=1)                    #gray
#points(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",pch=17)                        #gray
mtext(side=1,line=3.3,cex=1,"Source: EPA industrial allocation decisions \nNew Zealands Greenhouse Gas Inventory 1990–2020, April 2022, ME 1635")
#mtext(side=3,cex=1.5, line=-2.2,expression(paste("Emissions units industrial allocation to industry 2010 to 2020")) )
mtext(side=3,cex=1.5, line=-2.2,expression(paste("Industrial allocation of units to industry 2010 to 2020")) )
#mtext(side=3,cex=1.5, line=-2.2,expression(paste("Carbon footprint of industrial allocation to industry 2010 to 2020")) )
#mtext(side=2,cex=1, line=-1.5,expression(paste("million units/tonnes")))
mtext(side=2,cex=1, line=1.8,expression(paste("million units/tonnes")))
mtext(side=3,line=-4.5,cex=1,expression(paste("From 2010 to 2020 the emissions footprint of industry allocation was 89 millions tonnes")))
mtext(side=4,cex=0.75, line=0.05,R.version.string)
dev.off()

# plot 4 line chart of emissions footprint of industrial allocation and industry emissions and units allocated to industry 
svg(filename ="Industrial-Allocation-line-2010-2020-720-540-v4.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white") 
#png("Industrial-Allocation-line-2010-2020-560by420-v4.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4.7,2.7,1,1)+0.1)  
plot(Annualallocations[["Year"]],Annualallocations[["AllocatedGHG"]], xlim=c(2010,2020),ylim=c(1.75,11.25),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0, lwd = 1, at = c(2010:2020), labels = c(2010:2020), tick = TRUE)
axis(side=2, tck=0.01, las=2, line = NA,lwd = 1, at = c(0:10), labels = c(0:10),tick = TRUE)
axis(side=4, tck=0.01, at = c(0:10), labels = FALSE, tick = TRUE)
box(lwd=1)
legend("bottomright", inset=c(0.0,0.0) ,bty="n",c("Emissions footprint of industrial allocation 89 million tonnes","Actual industry emissions 44 million tonnes","Industrial allocation of units 39 million units"),col=c("#1b9e77","#d95f02","#E7298A"),pch=c(15,16,17))
lines(Annualallocations[["Year"]],Annualallocations[["AllocatedGHG"]],col="#1b9e77",lwd=1)
points(Annualallocations[["Year"]],Annualallocations[["AllocatedGHG"]],col="#1b9e77",cex=1.25,pch=15)
lines(Annualallocations[["Year"]],Annualallocations[["IndustryGHG"]],col="#d95f02",lwd=1)               # Bamboo
points(Annualallocations[["Year"]],Annualallocations[["IndustryGHG"]],col="#d95f02",cex=1,pch=16)
lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",lwd=1,lty=1)                    #gray
points(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",pch=17)                        #gray
mtext(side=1,line=3.3,cex=1,"Source: EPA industrial allocation decisions \nNew Zealands Greenhouse Gas Inventory 1990–2020, April 2022, ME 1635")
mtext(side=3,cex=1.5, line=-2.2,expression(paste("Industrial allocation of units to industry 2010 to 2020")) )
mtext(side=2,cex=1, line=1.8,expression(paste("million units/tonnes")))
mtext(side=3,line=-4.5,cex=1,expression(paste("From 2010 to 2020 the emissions footprint of industrial allocation \nwas double the actual industry sector emissions")))
mtext(side=4,cex=0.75, line=0.05,R.version.string)
dev.off()
