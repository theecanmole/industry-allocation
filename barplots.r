## 3 November 2022 What is Industrial Allocation under the New Zealand Emissions Trading Scheme?

The Ministry for the Environment says "Allocations of New Zealand Units are given to businesses carrying out certain activities". (https://environment.govt.nz/what-government-is-doing/areas-of-work/climate-change/ets/participating-in-the-nz-ets/overview-industrial-allocation/)
  
I prefer what Motu Research say. That one (out of five) ways of allocating emissions units in an emissions trading scheme is industrial allocation which Motu define as "Receiving them for free" (https://www.motu.nz/assets/Documents/our-research/environment/climate-change-mitigation/emissions-trading/A-Guide-to-the-New-Zealand-Emissions-Trading-System-2018-Motu-Research.pdf)

The Environmental Protection Authority annually publish the "final allocation" of emissions units. (https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/) So some analysis can be done.

# Load applications
library(readxl)
library(RColorBrewer)

# Obtain emission unit allocation to industry data from EPA Industrial Allocation webpage
download.file("https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx", "Industrial-Allocations-Final-Decisions.xlsx") 
trying URL 'https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx'
Content type 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' length 56684 bytes (55 KB)
==================================================
downloaded 55 KB 
# Check how many worksheets, there is only and read in the data with 'readxl' 
excel_sheets("Industrial-Allocations-Final-Decisions.xlsx")
[1] "IA Final Decisions"
# read in data on allocations of emission units
Allocations <- read_excel("Industrial-Allocations-Final-Decisions.xlsx", sheet = "IA Final Decisions",skip=3)
# Rename column variables and reorder columns
colnames(Allocations) <- c("Activity","Name","Year", "Allocation") 
# reorder columns
Allocations <- Allocations[,c("Year","Activity","Name","Allocation")] 
# check names
names(Allocations)
[1] "Year"       "Activity"   "Name"  "Allocation" 
# make csv file of allocations data
write.table(Allocations, file = "Allocations.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 
# Read in csv file later if needed
Allocations<-read.csv("Allocations.csv")
# How many emissions units have been given away from 2010 to 2020?
sum(Allocations[["Allocation"]])
[1] 55001914 
# The total is 55 million

# create dataframe of the emission units allocated for each year
Annualallocations <- aggregate(Allocations[["Allocation"]] ~ Year, Allocations, sum)

# check the data frame
str(Annualallocations) 
'data.frame':	11 obs. of  2 variables:
 $ Year                       : num  2010 2011 2012 2013 2014 ...
 $ Allocations[["Allocation"]]: num  1763232 3461556 3451147 4815810 4484100
# rename column variables
colnames(Annualallocations) <- c("Year", "Allocation") 
# restate to 10^6 (millions) 
Annualallocations["Allocation"] <- Annualallocations[["Allocation"]]/10^6
# check dataframe
str(Annualallocations) 
'data.frame':	11 obs. of  2 variables:
 $ Year      : num  2010 2011 2012 2013 2014 ...
 $ Allocation: num  1.76 3.46 3.45 4.82 4.48 ... 
# make csv file of allocations data
write.table(Annualallocations, file = "Annualallocations.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 
# Read in csv file later if needed
Allocations<-read.csv("Annualallocations.csv")
# create table that is industrial allocation of emission units
Annualallocations[["Allocation"]] 
[1] 1.763232 3.461556 3.451147 4.815810 4.484100 4.369366 4.307558 5.606415
 [9] 6.744229 8.282779 7.715722

table1 <- matrix(c(Annualallocations[["Allocation"]]), nrow = 1, ncol=11, byrow=TRUE, dimnames = list(c("NZUs"),c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")))
table1
         2010     2011     2012    2013   2014     2015     2016     2017
NZUs 1.763232 3.461556 3.451147 4.81581 4.4841 4.369366 4.307558 5.606415
         2018     2019     2020
NZUs 6.744229 8.282779 7.715722 

# select some colours for charts from the 'Dark2' palette
brewer.pal("Dark2",n=3)
[1] "#1B9E77" "#D95F02" "#7570B3"  # teal khaki mauve/blue

# chose a colour for bars from the 'Dark2' palette - light blue/mauve "#7570b3" Deluge - check what it looks like
barplot(matrix(c(5:9),nrow = 1, ncol=5, byrow=F), col= "#7570b3",cex.main=2,main="Colour is Deluge #7570b3",xlab="Deluge #7570b3")

# create barplot chart of the industrial allocation of emission units in the colour 'Deluge' #7570b3"
svg(filename ="Industrial-Allocation-barplot-2010-2020-720-540v1.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white")
#png("Industrial-Allocation-barplot-2010-2020-560by420-v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table1,ylim=c(0,9),las=1,space=c(0.1,1.1), beside = TRUE, col=c("#7570b3"))  
title(cex.main=1.4,main="Emission units allocated to industry 2010 to 2020",ylab="emission units (millions)")
mtext(side=1,line=2.5,cex=0.8,expression(paste("Source: EPA Industrial allocation decisions \nhttps://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
mtext(side=3,line=0,cex=1,expression(paste("From 2010 to 2020 industries were allocated 55 million free emission units")))
dev.off()

# conclusion. How many units? The answer is that from 2010 to 2020 fifty five million or 55,001,914 emissions units have been given at no cost to 162 entities.

![](Industrial-Allocation-barplot-2010-2020-720-540v1.svg)
