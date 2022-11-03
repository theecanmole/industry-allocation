# Industrial Allocation of emission units  
# https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/
# https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/eligibility/

# load applications
library(tidyr)
library(readxl)
library(dplyr)
library(RColorBrewer)
# check working directory
getwd()
[1] "/home/user/R/Industry-allocation"

# obtain emission unit allocation to industry data from EPA Industrial Allocation webpage

download.file("https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx", "Industrial-Allocations-Final-Decisions.xlsx") 
trying URL 'https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx'
Content type 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' length 56684 bytes (55 KB)
==================================================
downloaded 55 KB 

# check how many worksheets
excel_sheets("Industrial-Allocations-Final-Decisions.xlsx")
[1] "IA Final Decisions"

Allocations <- read_excel("Industrial-Allocations-Final-Decisions.xlsx", sheet = "IA Final Decisions",skip=3)

# rename column variables - which are in an odd order
colnames(Allocations) <- c("Activity","Name","Year", "Allocation") 

# can I reorder columns to a 'tidy' format easily in base R? Yes.
head(Allocations[,c("Year","Activity","Name","Allocation")]) 
  Year           Activity                                Name Allocation
1 2010 Aluminium smelting   New Zealand Aluminium Smelters Limited     210421
2 2010         Burnt lime                    Graymont (NZ) Limited      47144
3 2010         Burnt lime             Holcim (New Zealand) Limited       3653
4 2010         Burnt lime               Perry Resources (2008) Ltd       4712
5 2010         Burnt lime   Websters Hydrated Lime Company Limited        948
6 2010   Carbamide (urea) Ballance Agri-Nutrients (Kapuni) Limited      93275 

# reorder columns
Allocations <- Allocations[,c("Year","Activity","Name","Allocation")] 
names(Allocations)
[1] "Year"       "Activity"   "Name"  "Allocation" 
# make csv file of allocations data
write.table(Allocations, file = "Allocations.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 
# read in csv file
Allocations<-read.csv("Allocations.csv")

# How many emissions units have been given away from 2010 to 2020?
sum(Allocations[["Allocation"]])
[1] 55001914 
# 55 million

# How many emission units were allocated for each year
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

str(Annualallocations) 
'data.frame':	11 obs. of  2 variables:
 $ Year      : num  2010 2011 2012 2013 2014 ...
 $ Allocation: num  1.76 3.46 3.45 4.82 4.48 ... 

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

# select some colours for charts
brewer.pal("Dark2",n=8)
[1] "#1B9E77" "#D95F02" "#7570B3" "#E7298A" "#66A61E" "#E6AB02" "#A6761D" teal russet mauve pink green mustard tan gray
[8] "#666666"
brewer.pal("Dark2",n=3)
[1] "#1B9E77" "#D95F02" "#7570B3"  # teal khaki mauve
brewer.pal("Dark2",n=4)
[1] "#1B9E77" "#D95F02" "#7570B3" "#E7298A" # teal khaki mauve shocking pink 
# colour chosen for bars - blue blue/mauve "#7570b3")
# create barplot chart of industrial allocation of emission units
svg(filename ="Industrial-Allocation-barplot-2010-2020-720-540.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white")
#png("Industrial-Allocation-barplot-2010-2020-560by420-v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table1,ylim=c(0,9),las=1,space=c(0.1,1.1), beside = TRUE, col=c("#7570b3"))  
title(cex.main=1.4,main="Emission units allocated to industry 2010 to 2020",ylab="emission units (millions)")
mtext(side=1,line=2.5,cex=0.8,expression(paste("Source: EPA Industrial allocation decisions \nhttps://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
mtext(side=3,line=0,cex=1,expression(paste("From 2010 to 2020 industries were allocated 55 million free emission units")))
dev.off() 
