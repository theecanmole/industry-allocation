## 3 November 2022 What is Industrial Allocation under the New Zealand Emissions Trading Scheme?

The Ministry for the Environment says "Allocations of New Zealand Units are given to businesses carrying out certain activities". (https://environment.govt.nz/what-government-is-doing/areas-of-work/climate-change/ets/participating-in-the-nz-ets/overview-industrial-allocation/)
  
I prefer what Motu Research say. That one (out of five) ways of allocating emissions units in an emissions trading scheme is industrial allocation which Motu define as "Receiving them for free" (https://www.motu.nz/assets/Documents/our-research/environment/climate-change-mitigation/emissions-trading/A-Guide-to-the-New-Zealand-Emissions-Trading-System-2018-Motu-Research.pdf)

The Environmental Protection Authority annually publish the "final allocation" of emissions units. (https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/) So some analysis can be done.

# Load applications
library(readxl)
library(RColorBrewer)
setwd("/home/user/R/nzghg2021/industry/")
# Obtain emission unit allocation to industry data from EPA Industrial Allocation webpage
download.file("https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx", "Industrial-Allocations-Final-Decisions.xlsx") 
trying URL 'https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx'
Content type 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' length 56684 bytes (55 KB)
==================================================
Allocations-Final-Decisions_2022.xlsx
downloaded 55 KB 
# Check how many worksheets, there is only and read in the data with 'readxl' 
excel_sheets("Allocations-Final-Decisions_2022.xlsx")
[1] "IA Final Decisions"
# read in data on allocations of emission units
Allocations <- read_excel("Allocations-Final-Decisions_2022.xlsx", sheet = "IA Final Decisions",skip=3)
# Rename column variables and reorder columns
colnames(Allocations) <- c("Activity","Name","Year", "Units") 
# reorder columns
Allocations <- Allocations[,c("Year","Activity","Name","Units")] 
# check names
names(Allocations)
[1] "Year"       "Activity"   "Name"  "Units" 
# make csv file of allocations data
write.table(Allocations, file = "Allocations.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 
# Read in csv file later if needed
Allocations<-read.csv("Allocations.csv")
# How many emissions units have been given away from 2010 to 2022?
sum(Allocations[["Units"]])
[1] 67741839
# The total is 67.741839 million units

# create dataframe of the emission units allocated for each year
Annualallocations <- aggregate(Allocations[["Units"]] ~ Year, Allocations, sum)

# check the data frame
str(Annualallocations) 
'data.frame':	13 obs. of  2 variables:
 $ Year                  : num  2010 2011 2012 2013 2014 ...
 $ Allocations[["Units"]]: num  1763232 3461556 3451147 4815810 4484100 ... 
 
# rename column variables
colnames(Annualallocations) <- c("Year", "Units") 
# restate to 10^6 (millions) 
#Annualallocations["Units"] <- Annualallocations[["Units"]]/10^6
# check dataframe
str(Annualallocations) 
'data.frame':	13 obs. of  2 variables:
 $ Year : num  2010 2011 2012 2013 2014 ...
 $ Units: num  1763232 3461556 3451147 4815810 4484100 ... 
Annualallocations 
   Year   Units
1  2010 1763232
2  2011 3461556
3  2012 3451147
4  2013 4815810
5  2014 4484100
6  2015 4369366
7  2016 4307558
8  2017 5606415
9  2018 6744229
10 2019 8282779
11 2020 7716315
12 2021 6593253
13 2022 6146079  
# make csv file of allocations data
write.table(Annualallocations, file = "Annualallocations.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 
# Read in csv file later if needed
Allocations<-read.csv("Annualallocations.csv")
# create table that is industrial allocation of emission units

table1 <- matrix(c(Annualallocations[["Units"]]), nrow = 1, ncol=13, byrow=TRUE, dimnames = list(c("NZUs"),c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022")))


# select some colours for charts from the 'Dark2' palette
brewer.pal("Dark2",n=3)
[1] "#1B9E77" "#D95F02" "#7570B3"  # teal khaki mauve/blue

# chose a colour for bars from the 'Dark2' palette - light blue/mauve "#7570b3" Deluge - check what it looks like
barplot(matrix(c(5:9),nrow = 1, ncol=5, byrow=F), col= "#7570b3",cex.main=2,main="Colour is Deluge #7570b3",xlab="Deluge #7570b3")

# create barplot chart of the industrial allocation of emission units in the colour 'Deluge' #7570b3"
svg(filename ="Industrial-Allocation-barplot-2010-2022-720-540v1.svg", width = 8, height = 6, pointsize = 11, onefile = FALSE, family = "sans", bg = "white")
png("Industrial-Allocation-barplot-2010-2022-560by420.png", bg="white", width=560, height=420,pointsize = 11)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table1/10^6,ylim=c(0,9),las=1,space=c(0.1,1.1), beside = TRUE, col=c("#7570b3"))  
title(cex.main=1.5,main=expression(paste("Emission units allocated to industry 2010 to 2022")),ylab="emission units (millions)")
mtext(side=1,line=3,cex=0.8,expression(paste("Source: EPA Industrial allocation decisions \nhttps://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
mtext(side=3,line=0,cex=1,expression(paste("From 2010 to 2022 industries were allocated 67 million free emission units")))
dev.off()

# conclusion. How many units? The answer is that from 2010 to 2020 sixty seven million emissions units have been given at no cost to 162 entities.

![](Industrial-Allocation-barplot-2010-2020-720-540v1.svg)

# create table that is NZ AL allocation baseline Climate Change (Eligible Industrial Activities) Regulations 2010 No 7
# https://www.legislation.govt.nz/regulation/public/2010/0189/latest/DLM3075118.html
baselines <-c(2.645,2.726,2.062,10.441,5.136,5.152,5.160, 5.142,5.184,5.366,5.194,2.120,2.005)
str(baselines)
num [1:13] 2.65 2.73 2.06 10.44 5.14  

nzalbaseline <- matrix(baselines, nrow = 1, ncol=13, byrow=TRUE, dimnames = list(c("NA"),
c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022")))

#svg(filename ="NZAL-Allocation-baseline-2010-2022-720-540.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white")
png("NZAL-Allocation-baseline-2010-2022-560by420-v1.png", bg="white", width=560, height=420,pointsize = 11)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(nzalbaseline,ylim=c(0,11),las=1,space=c(0.1,1.1), beside = TRUE, col=c(rep("#ED731D",12),"red"))
title(cex.main=1.6,main="Aluminium Allocation Baseline Factor 2010 - 2022",ylab="Units per tonne aluminium produced",xlab="")
mtext(side=1,line=2.5,cex=1,expression(paste("Source: Climate Change (Eligible Industrial Activities) Regulations 2010 No 7")))
mtext(side=3,line=0,cex=0.9,expression(paste("What happened in 2013? The allocation factor is five times more than emissions per tonne aluminium")))
legend("topright", inset=c(0.0,0.0) ,bty="n",cex=1.2,c("Final allocation","Provisional allocation"),fill=c("#ED731D","red"))
dev.off()


===============================================
