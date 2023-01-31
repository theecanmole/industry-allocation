New Zealand’s historical and projected greenhouse gas emissions from 1990 to 2050 using AR5 values
https://environment.govt.nz/what-government-is-doing/areas-of-work/climate-change/emissions-reduction-targets/new-zealands-projected-greenhouse-gas-emissions-to-2050/
Data
https://environment.govt.nz/assets/2050-historical-and-projected-sectoral-emissions-data-March_2022-2.xlsx


NZ-ETS-settings-2023-2027-final-report-web-27-July-2022
page 38 of NZ-ETS-settings-2023-2027-final-report-web-27-July-2022
Our forecast of industrial free allocation volumes per year for 2023-2027 is given in the table below.
6.4 6.3 6.3 6.2 6.1

https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/


expand 2020 final allocation decisions New Zealand Steel Development Limited 2,030,166

New Zealands Greenhouse Gas Inventory 1990–2020, 12 April 2022, ME 1635 
https://environment.govt.nz/publications/new-zealands-greenhouse-gas-inventory-1990-2020/
https://environment.govt.nz/assets/publications/GhG-Inventory/Summary-emissions-data.xlsx

https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/eligibility/
https://www.nzherald.co.nz/business/opinion-fairly-sharing-the-burden-is-necessary-for-climate-success/LT2DSAYNPOB4M5J77BMPXQUMJU/
# load applications
library(tidyr)
library(readxl)
library(dplyr)
library(RColorBrewer)
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
palettepair11<-brewer.pal(11, "Paired")
palettepair11 
[1] "#A6CEE3" "#1F78B4" "#B2DF8A" "#33A02C" "#FB9A99" "#E31A1C" "#FDBF6F" "#FF7F00" "#CAB2D6" "#6A3D9A" "#FFFF99"
display.brewer.pal(11,"Paired") 
light blue, blue, lime, green, pink, red, sand, ochre, light mauve, mauve, light sand,
 
display.brewer.all(n=NULL, type="qual", select=NULL, exact.n=TRUE, colorblindFriendly=TRUE)
# plot of 3 palletes, Set2, Paired, Dark2 , Set2 is pastel shades, dark2 seems to show more contrast
display.brewer.all(n=4, type="qual", exact.n=TRUE, colorblindFriendly=TRUE)
# plot of 3 palletes, Set2, Paired, Dark2 sample = 4 cols
display.brewer.all(n=4, type="qual", select="Paired", exact.n=TRUE, colorblindFriendly=TRUE) # light blue,  blue, light green dark green 
display.brewer.pal(5,"Accent") # pastels
display.brewer.pal("Dark2",n=5)  # 

brewer.pal("Dark2",n=8)
[1] "#1B9E77" "#D95F02" "#7570B3" "#E7298A" "#66A61E" "#E6AB02" "#A6761D" teal russet mauve pink green mustard tan gray
[8] "#666666"
brewer.pal("Dark2",n=3)
[1] "#1B9E77" "#D95F02" "#7570B3"  # teal khaki mauve
brewer.pal("Dark2",n=4)
[1] "#1B9E77" "#D95F02" "#7570B3" "#E7298A" # teal khaki mauve shocking pink 
"#D95F02" #russet
"#B2DF8A" # lime
# "E7298A" very light blue blue/mauve "#7570b3")

# barplot chart of industrial allocation of emission units
svg(filename ="Industrial-Allocation-barplot-2010-2020-720-540.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white")
#png("Industrial-Allocation-barplot-2010-2020-560by420-v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table1,ylim=c(0,9),las=1,space=c(0.1,1.1), beside = TRUE, col=c("#7570b3"))  
title(cex.main=1.4,main="Emission units allocated to industry 2010 to 2020",ylab="emission units (millions)")
mtext(side=1,line=2.5,cex=0.8,expression(paste("Source: EPA Industrial allocation decisions \nhttps://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
mtext(side=3,line=0,cex=1,expression(paste("From 2010 to 2020 industries were allocated 55 million free emission units")))
dev.off() 

 
# line chart of units allocated to industry 
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

# line chart of units allocated to industry with linear regression
linearregression <- lm(Allocation ~ Year, Annualallocations)
summary(linearregression)
Call:
lm(formula = Allocation ~ Year, data = Annualallocations)

Residuals:
     Min       1Q   Median       3Q      Max 
-1.24108 -0.49265  0.03239  0.37695  1.08874 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -1.100e+03  1.416e+02  -7.767  2.8e-05 ***
Year         5.485e-01  7.029e-02   7.802  2.7e-05 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.7373 on 9 degrees of freedom
Multiple R-squared:  0.8712,	Adjusted R-squared:  0.8569 
F-statistic: 60.88 on 1 and 9 DF,  p-value: 2.702e-05 

lm(Allocation ~ Year, Annualallocations)
Call:
lm(formula = Allocation ~ Year, data = Annualallocations)

Coefficients:
(Intercept)         Year  
 -1100.1587       0.5485 
# The industrial allocations have increased by half a million units a year

predict(linearregression,interval="confidence",level=0.95)
confidencelimits <- predict(linearregression,interval="confidence",level=0.95)
confidencelimitsdata <- data.frame(confidencelimits)
confidencelimitsdata[["Year"]] <- 2010:2020
confidencelimitsdata
        fit      lwr      upr Year
1  2.257844 1.317087 3.198602 2010
2  2.806310 1.995479 3.617141 2011
3  3.354776 2.661637 4.047915 2012
4  3.903242 3.308255 4.498229 2013
5  4.451708 3.924308 4.979108 2014
6  5.000174 4.497318 5.503030 2015
7  5.548640 5.021240 6.076040 2016
8  6.097106 5.502119 6.692093 2017
9  6.645572 5.952433 7.338711 2018
10 7.194038 6.383207 8.004869 2019
11 7.742504 6.801746 8.683261 2020

#svg(filename ="Industrial-Allocation-line-2010-2020-720-540-v2.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white") 
png("Industrial-Allocation-line-2010-2020-560by420-v2.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(2.7,2.7,1,1)+0.1)
plot(Annualallocations[["Year"]],Annualallocations[["Allocation"]],ylim=c(0,10), xlim=c(2010,2020),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0, lwd = 1, at = c(2010:2020), labels = c(2010:2020), tick = TRUE)
axis(side=2, tck=0.01, las=2, line = NA,lwd = 1, at = c(0:8), labels = c(0:8),tick = TRUE)
axis(side=4, tck=0.01, at = c(0:8), labels = FALSE, tick = TRUE)
box(lwd=1)
lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",lwd=1,lty=1) # shocking pink
points(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",pch=19)
mtext(side=1,line=-1.5,cex=1,"Source: EPA industrial allocation decisions")
mtext(side=3,cex=1.5, line=-2.2,expression(paste("Emission units allocated to industry 2010 to 2020")) )
mtext(side=2,cex=1, line=-1.5,expression(paste("million units")))
mtext(side=3,line=-3.5,cex=1,expression(paste("From 2010 to 2020 55 million free emission units were given to industries")))
mtext(side=3,line=-5,cex=1,expression(paste("An increasing linear trend of 0.5 million units per year")))
mtext(side=4,cex=0.75, line=0.05,R.version.string)
abline(linearregression,col="#E7298A",lty=2,lwd=2)
lines(confidencelimitsdata[["Year"]],confidencelimitsdata[["lwr"]],col="#E7298A",lwd=1,lty=2) # shocking pink
lines(confidencelimitsdata[["Year"]],confidencelimitsdata[["upr"]],col="#E7298A",lwd=1,lty=2) # shocking pink
legend("right", inset=c(1.0,1.0) ,bty="n",c("Upper limit 95%","Linear trend","Lower limit 95%"),col="#E7298A",lwd=c(1,2,1),lty=2)
dev.off()
confint(linearregression,levels=0.95)
                    2.5 %      97.5 %
(Intercept) -1420.5784852 -779.739000
Year            0.3894489    0.707483

lines(confidencelimitsdata[["Year"]],confidencelimitsdata[["fit"]],col=3,lwd=3,lty=1)
library(ggplot2)
qplot(Year,Allocation,data=Annualallocations,geom="point") + geom_smooth(method="lm",se=TRUE)
predict(linearregression, Annualallocations,c(2013,2018))

------------------------------------------------------------------------------
# obtain Greenhouse Gas Inventory 1990 to 2020 emissions summary data from MfE 

download.file("https://environment.govt.nz/assets/publications/GhG-Inventory/Summary-emissions-data.xlsx","2020-crf-summary-data.xlsx")
# check individual worksheets 
excel_sheets("2020-crf-summary-data.xlsx")
[1] "Emissions by sector" "Emissions by gas" 

# read sector data into R from Excel file
crfsummarydatasector <- read_excel("2020-crf-summary-data.xlsx", sheet = "Emissions by sector", range ="A2:I33", col_names = TRUE, skip =1,col_types = c("guess"))

# check dataframe
str(crfsummarydatasector)
tibble [31 × 9] (S3: tbl_df/tbl/data.frame)
 $ Year                                           : chr [1:31] "1990" "1991" "1992" "1993" ...
 $ Energy                                         : num [1:31] 23878 24368 26228 25763 26082 ...
 $ Industrial processes and product use (IPPU)    : num [1:31] 3580 3729 3374 3213 3083 ...
 $ Agriculture                                    : num [1:31] 33793 34023 33571 33956 35133 ...
 $ Waste                                          : num [1:31] 3943 4053 4155 4258 4142 ...
 $ Tokelau (gross emissions)                      : num [1:31] 3.17 3.28 3.24 3.21 3.17 ...
 $ Land use, land-use change and forestry (LULUCF): num [1:31] -21229 -23277 -23044 -23842 -23634 ...
 $ Net emissions (with LULUCF)                    : num [1:31] 43968 42899 44288 43353 44810 ...
 $ Gross emissions (without LULUCF)               : num [1:31] 65197 66176 67332 67194 68444 .. 
# make Year a numeric vector
crfsummarydatasector[["Year"]] <- as.numeric(crfsummarydatasector[["Year"]]) 
# revise and shorten column names
colnames(crfsummarydatasector) <- c("Year", "Energy", "Industry", "Agriculture", "Waste", "Tokelau","LULUCF", "Net Emissions", "Gross Emissions") 
# check Industry sector emissions from GHG Inventory
str(crfsummarydatasector[["Industry"]])
num [1:31] 3580 3729 3374 3213 3083 ... 

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
lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",lwd=1,lty=1)                    #gray
points(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",pch=17)                        #gray
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
lines(Annualallocations[["Year"]],Annualallocations[["AllocatedGHG"]],col="#1b9e77",lwd=1)
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
lines(Annualallocations[["Year"]],Annualallocations[["IndustryGHG"]],col="#d95f02",lwd=1)
points(Annualallocations[["Year"]],Annualallocations[["IndustryGHG"]],col="#d95f02",cex=1,pch=16)
lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",lwd=1,lty=1)                    #gray
points(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",pch=17)                        #gray
mtext(side=1,line=3.3,cex=1,"Source: EPA industrial allocation decisions \nNew Zealands Greenhouse Gas Inventory 1990–2020, April 2022, ME 1635")
mtext(side=3,cex=1.5, line=-2.2,expression(paste("Industrial allocation of units to industry 2010 to 2020")) )
mtext(side=2,cex=1, line=1.8,expression(paste("million units/tonnes")))
mtext(side=3,line=-4.5,cex=1,expression(paste("From 2010 to 2020 the emissions footprint of industrial allocation \nwas double the actual industry sector emissions")))
mtext(side=4,cex=0.75, line=0.05,R.version.string)
dev.off()


=======================================================================
#lines(Annualallocations[["Year"]],Annualallocations[["Industry"]]/1000,col="#7570b3",lwd=1)
#points(Annualallocations[["Year"]],Annualallocations[["Industrial"]]/1000,col="#7570b3",cex=1,pch=9)
#lines(Annualallocations[["Years"]],Annualallocations[["Waste"]]/1000,col="#e7298a",lwd=1,lty=2)
#points(Annualallocations[["Years"]],Annualallocations[["Waste"]]/1000,col="#e7298a",cex=1,pch=10)
#lines(Annualallocations[["Years"]],Annualallocations[["LULUCF"]]/1000,col="#66a61e",lwd=1)
#points(Annualallocations[["Years"]],Annualallocations[["LULUCF"]]/1000,col="#66a61e",cex=1,pch=17)

# How many Applicants are receiving free emission units? 162

Applicants <- aggregate(Allocation ~ Name, Allocations, sum)
str(Applicants)
'data.frame':	162 obs. of  2 variables:
 $ Name : chr  "ACI OPERATIONS NZ LIMITED" "Affco New Zealand Limited" "Alliance Group Limited" "Alwyn Ernest Inger, Anne Marie Inger" 
 $ Allocation: int  457184 84603 80841 2220 70102 34 1381 245 243792 60 

# sort /order data by units allocated decreasing   https://www.statmethods.net/management/sorting.html
attach(Applicants)
Applicants <- Applicants[order(Allocation,decreasing=TRUE),]

# create csv file of Applicants data
write.table(Applicants, file = "Applicants.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 
Applicants <- read.csv( file = "Applicants.csv")

str(Applicants)
'data.frame':	162 obs. of  2 variables:
 $ Name      : chr  "New Zealand Steel Development Limited" "New Zealand Aluminium Smelters Limited" "Methanex New Zealand Ltd" "Fletcher Concrete and Infrastructure Limited" ...
 $ Allocation: int  14070207 10407692 7897573 4353470 3865433 2306629 1879433 1599929 1385445 1222905 ... 
 
quantile(Applicants[["Allocation"]],0.75) 

# Pie Chart with Percentages

slicestopten <- c(Applicants[["Allocation"]][1:10]/10^6)
str(slicestopten) 
[1] 14.070207 10.407692  7.897573  4.353470  3.865433  2.306629  1.879433
 [8]  1.599929  1.385445  1.222905 
sum(slicestopten) 
[1] 48.98872 
sumslicestopten  <- sum(slicestopten)  

total <-sum(Applicants[["Allocation"]]/10^6) 
total 
[1] 55.00191 

therest <- total - sumslicestopten
therest 
[1] 6.013198 

slices <-c(slices, therest) 

total <-sum(Applicants[["Allocation"]]/10^6)

# What percent of units went to top ten industries
therest / total
6.013198 / 55.00191 
[1] 0.1093271
sumslicestopten / total 
[1] 0.8906729 

# shorten label names
Applicants[["Name"]][1:10]
 [1] "New Zealand Steel Development Limited"       
 [2] "New Zealand Aluminium Smelters Limited"      
 [3] "Methanex New Zealand Ltd"                    
 [4] "Fletcher Concrete and Infrastructure Limited"
 [5] "Oji Fibre Solutions (NZ) Limited"            
 [6] "Ballance Agri-Nutrients (Kapuni) Limited"    
 [7] "Norske Skog Tasman Ltd"                      
 [8] "Pan Pac Forest Products Limited"             
 [9] "Graymont (NZ) Limited"                       
[10] "Winstone Pulp International Limited"  

slices <-c( 14.070207, 10.407692,  7.897573,  4.353470,  3.865433,  2.306629,  1.879433,  1.599929,  1.385445,  1.222905, 6.013198)
labels <- c("NZ Steel","NZ Aluminium","Methanex","Fletcher","Oji Fibre","Ballance","Norske skog","Pan Pac Forest", "Graymont", "Winstone", "The rest 152 firms")
percent <- round(slices/sum(slices)*100)
labels <- paste(labels, percent) # add percents to labels
labels <- paste(labels,"%",sep="") # add "%" to labels
labels 

milliondollars <- round (slices,1)
milliondollars 
mlabels <- paste(labels, milliondollars) # add amounts to labels
mlabels <- paste(mlabels,"m",sep=" ") # add amounts to labels
# select some colours for charts
palettepair11<-brewer.pal(11, "Paired")
palettepair11 
[1] "#A6CEE3" "#1F78B4" "#B2DF8A" "#33A02C" "#FB9A99" "#E31A1C" "#FDBF6F" "#FF7F00" "#CAB2D6" "#6A3D9A" "#FFFF99"



png("Allocations-pie-percent-2010-2020-720.png", width=565, height=565, pointsize = 12)
#png("Allocations-pie-percent-pie-2010-2020-720.png", width=720, height=720, pointsize = 14)
#svg(filename ="Allocations-pie-precent-2010-2020_720-720.svg", width = 8, height = 8, pointsize = 14, onefile = FALSE, family = "sans", bg = "white")
pie(slices,radius=0.9,clockwise =TRUE,labels = labels, col=palettepair11, main=expression(paste("Recipients of Industrial Allocation 2010 to 2020 by percent")))
mtext(side=1,cex=0.9,line=1.9,"Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")
mtext(side=1,cex=1,line=0.5,"Of 55 million emission units allocated to industry between 2010 and 2020\n89% went to ten companies")
dev.off()   

png("Allocations-pie-quantity-pie-2010-2020-720.png", width=565, height=565, pointsize = 12)
#png("Allocations-pie-quantity-pie-2010-2020-720.png", width=720, height=720, pointsize = 14)
#svg(filename ="Allocations-pie-quantity-2010-2020_720-720.svg", width = 8, height = 8, pointsize = 14, onefile = FALSE, family = "sans", bg = "white")
pie(slices,radius=0.9,clockwise =TRUE,labels = mlabels, col=palettepair11, main=expression(paste("Recipients of Industrial Allocation 2010 to 2020 by million units")))
mtext(side=1,cex=0.9,line=1.9,"Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")
mtext(side=1,cex=1,line=0.5,"Of 55 million units allocated to industry between 2010 and 2020\n49 million went to ten companies")
dev.off() 


# How many units allocated to all applicants? 
sum(Applicants[["Allocation"]])
[1] 55001914
png("Steel-Aluminium-Other-allocations-pie-2010-2020-680.png", width=680, height=510, pointsize = 14)
pie(toptwoallocation,labels=c(toptwonames),radius = 0.95,clockwise = FALSE,init.angle=260, col = 3 , cex.lab=1.1,cex.main=1.2,main="NZETS Industrial Allocation free allocation of emission units\nto the 'top two' applicants 2010 - 2020")
mtext(side=1,cex=0.9,line=1.8,"Source: https://www.epa.govt.nz/industry-areas/\nemissions-trading-scheme/industrial-allocations/decisions/")
mtext(side=1,cex=1,line=-0.1,"Of 55 million units allocated to industry, 24.5 million (45%) went to NZ Steel and NZ Aluminium")
labels <- paste(toptwonames, percent)
dev.off()

svg(filename ="Steel-Aluminium-Other-allocations-pie-2010-2020_720-540.svg", width = 8, height = 6, pointsize = 14, onefile = FALSE, family = "sans", bg = "white")
pie(toptwoallocation,labels=c(toptwonames),radius = 0.95,clockwise = FALSE,init.angle=260, col = palettepair11, cex.lab=1.1,cex.main=1.4,main="NZETS Industrial Allocation free allocation\nof emission units to the 'top two' applicants 2010 - 2020")
mtext(side=1,cex=0.9,line=1.8,"Source: https://www.epa.govt.nz/industry-areas/\nemissions-trading-scheme/industrial-allocations/decisions/")
mtext(side=1,cex=1,line=-0.1,"Of 55 million units allocated to industry between 2010 and 2020\n24.5 million (45%) went to NZ Steel and NZ Aluminium")
dev.off()

# select the top ten most generously allocated applicants
Applicantstopten <- head(Applicants[order(Allocation,decreasing=TRUE),],10)
str(Applicantstopten)
'data.frame':	10 obs. of  2 variables:
 $ Name      : chr  "New Zealand Steel Development Limited" "New Zealand Aluminium Smelters Limited" "Methanex New Zealand Ltd" "Fletcher Concrete and Infrastructure Limited" ...
 $ Allocation: num  14070207 10407692 7897573 4353470 3865433 ...  

# How many units allocated to top ten applicants?
sum(Applicantstopten[["Allocation"]])
[1] 48988716 # 48.988716 million
# How many units allocated to all applicants? 
sum(Applicants[["Allocation"]])
[1] 55001914
# what proportion of all 2010 to 2020 units were allocated to ten applicants?
toptenproportion <- sum(Applicantstopten[["Allocation"]]) /sum(Applicants[["Allocation"]]) 
toptenproportion 
[1] 0.8906729 
# How many units allocated to all other applicants?
sum(Applicants[["Allocation"]]) - sum(Applicantstopten[["Allocation"]]) 
[1] 6013198 

head(Applicants[order(Allocation,decreasing=TRUE),],10)
                                            Name Allocation
113        New Zealand Steel Development Limited   14070207
111       New Zealand Aluminium Smelters Limited   10407692
105                     Methanex New Zealand Ltd    7897573
43  Fletcher Concrete and Infrastructure Limited    4353470
116             Oji Fibre Solutions (NZ) Limited    3865433
11      Ballance Agri-Nutrients (Kapuni) Limited    2306629
114                       Norske Skog Tasman Ltd    1879433
119              Pan Pac Forest Products Limited    1599929
55                         Graymont (NZ) Limited    1385445
161          Winstone Pulp International Limited    1222905

# What percent of units went to top 10 emitters?

top10names<-c("NZ Steel", "NZ Aluminium Smelters", "Methanex NZ", "Fletcher Concrete", "Oji Fibre", "Ballance Agri-Nutrients",  "Norske Skog Tasman","Pan Pac Forest Products", "Graymont", "Winstone Pulp","All Others")
top10allocation <-c(14070207, 10407692,  7897573, 4353470,3865433,2306629, 1879433,1599929,1385445,1222905,6013198 )
palettepair11<-brewer.pal(11, "Paired")

png("nzu-allocations-pie-2010-2020-680.png", width=680, height=510, pointsize = 14)
pie(top10allocation,labels=c(top10names),radius = 0.95,clockwise = FALSE,init.angle=260, col = palettepair11, cex.lab=1.1,cex.main=1.5,main="NZETS free allocation of emission units\nto the 'top ten' applicants 2010 - 2020")
mtext(side=1,cex=0.9,line=1.8,"Source: https://www.epa.govt.nz/industry-areas/\nemissions-trading-scheme/industrial-allocations/decisions/")
mtext(side=1,cex=1,line=-0.1,"Of 55 million units allocated to industry, 48 million (89%) went to 10 companies")
dev.off() 

 
 
 
dotchart(sort(Applicants[["Allocation"]][1:12]), main = "chart of units allocated to applicants",las=1)

sort(Applicants[["Allocation"]])
  [1]        2       10       10       15       18       18       24       24
  [9]       31       34       34       43       45       47       48       58
 [17]       60       68       85      100      116      121      122      123
 [25]      132      136      150      155      160      168      168      188
 [33]      190      195      198      201      203      222      226      227
 [41]      229      230      235      236      245      246      286      310
 [49]      311      323      365      394      425      454      471      501
 [57]      643      657      703      713      767      775      845      953
 [65]      970     1114     1194     1276     1381     1393     1436     1464
 [73]     1715     1802     2189     2220     2283     2349     2484     2622
 [81]     2853     3263     3559     3577     4121     4234     5203     5488
 [89]     6134     6189     6853     7005     8656     8732     9367     9563
 [97]    10198    10510    10554    11135    11297    11454    11903    11933
[105]    12058    12586    12634    12931    13781    14273    14501    14829
[113]    23144    23680    23982    24233    26280    30565    38358    38415
[121]    39271    42531    43962    45900    46377    46508    46648    50394
[129]    51498    57101    58014    64740    70102    71813    72947    80841
[137]    83061    84603    86050    98805   107259   119717   131879   149860
[145]   151084   202996   216779   242838   243792   457184  1072395  1112834
[153]  1222905  1385445  1599929  1879433  2306629  3865433  4353470  7897573
[161] 10407692 14070207
sort(Applicants[["Allocation"]],decreasing=TRUE)[1:10]
 [1] 14070207 10407692  7897573  4353470  3865433  2306629  1879433  1599929
 [9]  1385445  1222905 

attach(mtcars)
str(mtcars)
'data.frame':	32 obs. of  11 variables:
 $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
 $ cyl : num  6 6 4 6 8 6 8 4 4 6 ...
 $ disp: num  160 160 108 258 360 ...
 $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
 $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
 $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
 $ qsec: num  16.5 17 18.6 19.4 17 ...
 $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
 $ am  : num  1 1 1 0 0 0 0 0 0 0 ...
 $ gear: num  4 4 4 3 3 3 3 4 4 4 ...
 $ carb: num  4 4 1 1 2 1 4 2 2 4 ...  
 newdata <- mtcars[order(mpg),] 
head(newdata)
                     mpg cyl disp  hp drat    wt  qsec vs am gear carb
Cadillac Fleetwood  10.4   8  472 205 2.93 5.250 17.98  0  0    3    4
Lincoln Continental 10.4   8  460 215 3.00 5.424 17.82  0  0    3    4
Camaro Z28          13.3   8  350 245 3.73 3.840 15.41  0  0    3    4
Duster 360          14.3   8  360 245 3.21 3.570 15.84  0  0    3    4
Chrysler Imperial   14.7   8  440 230 3.23 5.345 17.42  0  0    3    4
Maserati Bora       15.0   8  301 335 3.54 3.570 14.60  0  1    5    8
newerdata <- mtcars[order(mpg,decreasing=TRUE),]
head(newerdata)
                mpg cyl  disp  hp drat    wt  qsec vs am gear carb
Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
Fiat 128       32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
Honda Civic    30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
Lotus Europa   30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
Fiat X1-9      27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
Porsche 914-2  26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
 
 
Allocations[Allocations$Name =="New Zealand Aluminium Smelters Limited",]

# Base R separate allocation of emissions units data into years
nzu2010 <- head(Allocations[Allocations$Year =="2010",]) 
names(nzu2010)

# separate allocation of emissions units data into years
nzu2010 <- filter(Allocations, Year =="2010")
nzu2011 <- filter(Allocations, Year =="2011")
nzu2012 <- filter(Allocations, Year =="2012")
nzu2013 <- filter(Allocations, Year =="2013")
nzu2014 <- filter(Allocations, Year =="2014")
nzu2015 <- filter(Allocations, Year =="2015")
nzu2016 <- filter(Allocations, Year =="2016")
nzu2017 <- filter(Allocations, Year =="2017")
nzu2018 <- filter(Allocations, Year =="2018")
nzu2019 <- filter(Allocations, Year =="2019") 
nzu2020 <- filter(Allocations, Year =="2020") 
sum(nzu2018[["Allocation"]])
[1] 6744229

# Each year, from May, the EPA makes a 'provisional' allocation of emssion units to selected industries. see https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/ I want to estimate the market value of free allocation of units. I understand that the deadline for a provisional allocation is 30 April of each year so I assume the transfer of allocation is made in May of each year. There is an online 'open data' Github repository of New Zealand Unit (NZU) prices going back to May 2010. https://github.com/theecanmole/nzu
# The NZU repository has it's own citation and DOI: Theecanmole. (2016). New Zealand emission unit (NZU) monthly prices 2010 to 2016: V1.0.01 [Data set]. Zenodo. http://doi.org/10.5281/zenodo.221328
# I will add a NZU market price value at the May average price from 2010 to 2019 

nzu2010[["Value"]] <- nzu2010[["Allocation"]]*17.58
nzu2011[["Value"]] <- nzu2011[["Allocation"]]*19.84
nzu2012[["Value"]] <- nzu2012[["Allocation"]]*6.23
nzu2013[["Value"]] <- nzu2013[["Allocation"]]*1.94
nzu2014[["Value"]] <- nzu2014[["Allocation"]]*4.08
nzu2015[["Value"]] <- nzu2015[["Allocation"]]*5.34
nzu2016[["Value"]] <- nzu2016[["Allocation"]]*14.63
nzu2017[["Value"]] <- nzu2017[["Allocation"]]*16.96
nzu2018[["Value"]] <- nzu2018[["Allocation"]]*21.28
nzu2019[["Value"]] <- nzu2019[["Allocation"]]*25.29 
nzu2020[["Value"]] <- nzu2020[["Allocation"]]*24.84

# combine all year data together into 1 dataframe - I use rbind as all the column names are consistent
Allocations <- rbind(nzu2010,nzu2011,nzu2012,nzu2013,nzu2014,nzu2015,nzu2016,nzu2017,nzu2018,nzu2019,nzu2020)

# check the new dataframe
str(Allocations)
'data.frame':	1207 obs. of  5 variables:
 $ Year      : int  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Activity  : chr  "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Name      : chr  "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Allocation: int  210421 47144 3653 4712 948 93275 16818 34 39164 4958 ...
 $ Value     : num  3699201 828792 64220 82837 16666 ...  

tibble [31 × 9] (S3: tbl_df/tbl/data.frame)
 $ Year                                           : chr [1:31] "1990" "1991" "1992" "1993" ...
 $ Energy                                         : num [1:31] 23878 24368 26228 25763 26082 ...
 $ Industrial processes and product use (IPPU)    : num [1:31] 3580 3729 3374 3213 3083 ...
 $ Agriculture                                    : num [1:31] 33793 34023 33571 33956 35133 ...
 $ Waste                                          : num [1:31] 3943 4053 4155 4258 4142 ...
 $ Tokelau (gross emissions)                      : num [1:31] 3.17 3.28 3.24 3.21 3.17 ...
 $ Land use, land-use change and forestry (LULUCF): num [1:31] -21229 -23277 -23044 -23842 -23634 ...
 $ Net emissions (with LULUCF)                    : num [1:31] 43968 42899 44288 43353 44810 ...
 $ Gross emissions (without LULUCF)               : num [1:31] 65197 66176 67332 67194 68444 ...

str(crfsummarydatasector)
tibble [31 × 9] (S3: tbl_df/tbl/data.frame)
 $ Year           : num [1:31] 1990 1991 1992 1993 1994 ...
 $ Energy         : num [1:31] 23878 24368 26228 25763 26082 ...
 $ Industry       : num [1:31] 3580 3729 3374 3213 3083 ...
 $ Agriculture    : num [1:31] 33793 34023 33571 33956 35133 ...
 $ Waste          : num [1:31] 3943 4053 4155 4258 4142 ...
 $ Tokelau        : num [1:31] 3.17 3.28 3.24 3.21 3.17 ...
 $ LULUCF         : num [1:31] -21229 -23277 -23044 -23842 -23634 ...
 $ Net Emissions  : num [1:31] 43968 42899 44288 43353 44810 ...
 $ Gross Emissions: num [1:31] 65197 66176 67332 67194 68444 .. 

# create csv file of data
write.table(crfsummarydatasector, file = "crfsummarydatasector.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 

# read in csv file
crfsummarydatasector<-read.csv("crfsummarydatasector.csv")

------------------------------------------------------------------
# back to EPA allocations data
# check the data frame
str(Allocations)
'data.frame':	1207 obs. of  5 variables:
 $ Year      : int  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Activity  : chr  "Aluminium smelting" "Burnt lime" "Burnt lime" "Burnt lime" ...
 $ Name      : chr  "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Allocation: int  210421 47144 3653 4712 948 93275 16818 34 39164 4958 ...
 $ Value     : num  3699201 828792 64220 82837 16666 ...  
 
glimpse(Allocations)
Rows: 1,207
Columns: 5
$ Activity   <chr> "Aluminium smelting", "Burnt lime", "Burnt lime", "Burnt li…
$ Name  <chr> "New Zealand Aluminium Smelters Limited", "Graymont (NZ) Li…
$ Year       <int> 2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010, 2010,…
$ Allocation <int> 210421, 47144, 3653, 4712, 948, 93275, 16818, 34, 39164, 49…
$ Value      <dbl> 3699201.18, 828791.52, 64219.74, 82836.96, 16665.84, 163977… 

names(Allocations)
[1] "Year"       "Activity"   "Name"       "Allocation" "Value"

# How many activities receive free units and how many units for each industrial Activity? 26 activities

Activities <- aggregate(Allocation ~ Activity, Allocations, sum)
str(Activities)
'data.frame':	26 obs. of  2 variables:
 $ Activity  : chr  "Aluminium smelting" "Burnt lime" "Carbamide (urea)" "Carbon steel from cold ferrous feed" ...
 $ Allocation: int  10407692 1493104 2306629 240048 1112834 120302 5383349 13545 38342 80300 ..
summary(Activities)
  Activity           Allocation      
 Length:26          Min.   :   13545  
 Class :character   1st Qu.:  134646  
 Mode  :character   Median :  409914  
                    Mean   : 2115458  
                    3rd Qu.: 1873027  
                    Max.   :14166823

                    # What are the first five activities receiving free emission units ?
head((Activities)) 
                            Activity Allocation
1                  Aluminium smelting   10407692
2                          Burnt lime    1493104
3                    Carbamide (urea)    2306629
4 Carbon steel from cold ferrous feed     240048
5                         Cartonboard    1112834
6                        Caustic soda     120302 

# sort /order data by units allocated decreasing 
https://www.statmethods.net/management/sorting.html

attach(Activities)
# order by largest to smallest
Activities <- Activities[order(Allocation,decreasing=TRUE),]
# create csv file of data
write.table(Activities, file = "Activities.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 

# print
Activities
                                      Activity Allocation
17 Iron and steel manufacturing from iron sand   14166823
1                           Aluminium smelting   10407692
20                                    Methanol    7897573
7                        Cementitious products    5383349
19                                 Market pulp    4808292
3                             Carbamide (urea)    2306629
21                                   Newsprint    1879433
22              Packaging and industrial paper    1853810
2                                   Burnt lime    1493104
5                                  Cartonboard    1112834
23                                Protein meal     739299
24                   Reconstituted wood panels     534139
15                            Glass containers     457184
18                                     Lactose     362644
13                              Fresh tomatoes     324290
25                                Tissue paper     243792
4          Carbon steel from cold ferrous feed     240048
11                             Fresh capsicums     205042
16                           Hydrogen peroxide     151084
12                             Fresh cucumbers     129166
6                                 Caustic soda     120302
10                                     Ethanol      80300
9                                    Cut roses      38342
26                                 Whey powder      30054
14                                    Gelatine      23144
8                  Clay bricks and field tiles      13545

Activitiestopten <- head(Activities,10)
head(Activities,10)
Activitiestopten
data.frame:	10 obs. of  2 variables:
 $ Activity  : chr  "Carbon steel from cold ferrous feed" "Iron and steel manufacturing from iron sand" "Fresh cucumbers" "Newsprint" ...
 $ Allocation: int  240048 14166823 129166 1879433 151084 7897573 120302 80300 10407692 4808292 
Activitiestopten 


# How many emissions units have been given away from 2010 to 2020?
sum(Allocations[["Allocation"]])
[1] 55001914 
# 55 million


top10names<-c("NZ Steel", "NZ Aluminium Smelters", "Methanex NZ", "Fletcher Concrete", "Oji Fibre", "Ballance Agri-Nutrients", "Pan Pac Forest Products", "Norske Skog Tasman", "Winstone Pulp", "Graymont","Others")
top10allocation <-c(1782366, 1324556,  945210,  584032,  484322,  325594,  210652,  200556,  151546, 144405,590334 )
palettepair11<-brewer.pal(11, "Paired")

png("nzu-allocations-pie-2020-565.png", width=565, height=424, pointsize = 14)
pie(top10allocation,labels=c(top10names),radius = 0.99,clockwise = FALSE,init.angle=260, col = palettepair11, cex.lab=1.1,cex.main=1.5,main="NZETS free allocation of emission units\nto the Top Ten Emitters 2010 to 2020")
mtext(side=1,cex=0.9,line=2.6,"Source: https://www.epa.govt.nz/industry-areas/\nemissions-trading-scheme/industrial-allocations/decisions/")
mtext(side=1,cex=1,line=0.4,"Of 6.7 million units allocated to industry, 6.2 million (91%) went to 10 companies")
dev.off() 
# How many units were allocated to the top ten applicants?
sum(top10allocation)

Annualallocations
   Year Allocation
1  2010   1.763232
2  2011   3.461556
3  2012   3.451147
4  2013   4.815810
5  2014   4.484100
6  2015   4.369366
7  2016   4.307558
8  2017   5.606415
9  2018   6.744229
10 2019   8.282779
11 2020   7.715722 

# Create .csv formatted data file
write.csv(Annualallocations, file = "Annualallocations.csv", row.names = FALSE)  
# How many units given to NZ Steel each year?

# linear regression 
linearregression <- lm(Allocation ~ Year, Annualallocations)
plot(Annualallocations,type='p',col=2)
lines(abline(linearregression))
lines(abline(lm(Annualallocations[["Allocation"]][2:11]~ c(1:10))))
Call:
lm(formula = Allocation ~ Year, data = Annualallocations)
Residuals:
    Min      1Q  Median      3Q     Max 
-941264 -460427   44732  512937  946231 
Coefficients:
              Estimate Std. Error t value Pr(>|t|)   
(Intercept) -920054286  174545511  -5.271  0.00116 **
Year            458980      86666   5.296  0.00113 **
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 671300 on 7 degrees of freedom
Multiple R-squared:  0.8003,	Adjusted R-squared:  0.7717 
F-statistic: 28.05 on 1 and 7 DF,  p-value: 0.001128 

# eliminate 2010 as it was a half year
Allocations20112020 <- Annualallocations[["Allocation"]][2:11]
Allocations20112020[[Years]] <- c(1:10)
linear2011regression <- lm(Allocation ~ Year, Annualallocations)
plot(years20112020,allocations20112020,ylim=c(0,10),xlim=c(2011,2022))
lines(abline(linear2011regression)) 
lines(abline,h =2020)
summary(linear2011regression)

Allocations[(Allocations[["Name"]]=="New Zealand Steel Development Limited"),c("Year","Allocation")]

'data.frame':	11 obs. of  4 variables:
 $ Year        : num  2010 2011 2012 2013 2014 ...
 $ Allocation  : num  1.76 3.46 3.45 4.82 4.48 ...
 $ unitdiscount: num  0.25 0.5 0.5 0.5 0.5 0.5 0.5 0.67 0.83 1 ...
 $ IndustryGHG : num  4.59 4.63 4.7 4.84 5.01  

IndustryGHG 
[1] 4.591133 4.627387 4.703190 4.836346 5.006981 5.137323 4.883073 4.928440
[9] 4.825074 4.861046 4.618354

# create table that is industry emissions
table1 <- matrix(c(4.591133, 4.627387, 4.703190, 4.836346, 5.006981, 5.137323, 4.883073, 4.928440, 4.825074, 4.861046, 4.618354), 
nrow = 1, ncol=11, byrow=TRUE, dimnames = list(c("NZUs"),
c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")))

# chart of just industry emissions
svg(filename ="Industry-Emissions-barplot-2010-2020-720-540.svg", width = 8, height = 6, pointsize = 14, onefile = FALSE, family = "sans", bg = "white")
#png("Industry-Emissions-2010-2020-560by420-v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table1,ylim=c(0,5.5),las=1,space=c(0.1,1.1), beside = TRUE, col=c("brown")) 
title(cex.main=1.4,main="Industry Sector Emissions 2010 2020",ylab="tonnes GHG CO2-e (millions)")
mtext(side=1,line=2.5,cex=1,expression(paste("Source: MfE GHG Inventory 2020")))
mtext(side=3,line=0,cex=1,expression(paste("Emissions from the Industrial sector were 53 million tonnes from 2010 to 2020")))
#legend("topleft", inset=c(0.0,0.0) ,bty="n",c("Free Allocation of NZUs","Actual Industry Emissions"),fill=c("brown3","#ED731D"))
dev.off() 

str(Annualallocations)
'data.frame':	11 obs. of  2 variables:
 $ Year      : num  2010 2011 2012 2013 2014 ...
 $ Allocation: num  1763232 3461556 3451147 4815810 4484100 ..
max(Annualallocations[["Allocation"]]) 
[1] 8282779 

plot(Annualallocations$Year,Annualallocations[["Allocation"]],type='l',ylim=c(0,8*10^6),las=1, col=c("brown3"))

sum(Annualallocations[["Allocation"]]) 
1] 55.00191 
Annualallocations[["Allocation"]]
[1] 1.763232 3.461556 3.451147 4.815810 4.484100 4.369366 4.307558 5.606415 6.744229 8.282779 7.715722
# create table of emission units allocated to industry 
table2 <- matrix(c( 1.763232, 3.461556, 3.451147, 4.815810, 4.484100, 4.369366, 4.307558, 5.606415, 6.744229, 8.282779, 7.715722),nrow = 1, ncol=11, byrow=TRUE, dimnames = list(c("NZUs"),
c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")))

# create barplot of allocated units
png("Industry-Allocation-2010-2020-560by420-v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table1,las=1,space=c(0.1,1.1), beside = TRUE, col=c("brown3")) 
title(cex.main=1.4,main="Emission Units allocated to Industry 2010 2020",ylab="Units/tonnes GHG CO2-e (millions)")
mtext(side=1,line=2.5,cex=1,expression(paste("Source: EPA Industrial allocation decisions")))
mtext(side=3,line=0,cex=1,expression(paste("From 2010 to 2020 industries were allocated 55 million free emission units")))
#legend("topleft", inset=c(0.0,0.0) ,bty="n",c("Free Allocation of NZUs","Actual Industry Emissions"),fill=c("brown3","#ED731D"))
dev.off() 

# create table that is industrial free allocation and actual emissions 2010 2020
table3 <- matrix(c(1.763232, 3.461556, 3.451147, 4.815810, 4.48410, 4.369366, 4.307558, 5.606415, 6.744229, 8.282779, 7.715722,
                    4.591133, 4.627387, 4.703190, 4.836346, 5.006981, 5.137323, 4.883073, 4.928440, 4.825074, 4.861046, 4.618354), nrow = 2, ncol=11, byrow=TRUE, dimnames = list(c("NZUs","GHGs"),
c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")))

png("Industry-Allocation-2010-2020-560by420-v1.png", bg="white", width=560, height=420,pointsize = 11)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table3,las=1,space=c(0.1,1.1), beside = TRUE, col=c("brown3","#ED731D"))
title(cex.main=1.4,main="Industry unit allocation and Industry GHG emissions",ylab="Units/ tonnes GHG CO2-e (millions)")
mtext(side=1,line=2.5,cex=1,expression(paste("Source: MfE GHG Inventory 1990 2020, EPA Industrial allocation decisions")))
#mtext(side=3,line=0,cex=0.9,expression(paste("2010 to 2018 industry emissions 44 million tonnes - free units allocated 39 million")))
legend("topleft", inset=c(0.0,0.0) ,bty="n",c("Allocation of units to industry 39 million tonnes","Actual industry emissions 44 million tonnes"),fill=c("brown3","#ED731D"))
dev.off()

  

# create table that is industrial free allocation NZUs, actual emissions and emissions permitted by NZUs 2010 2020
table4 <- matrix(c(1.763232, 3.461556, 3.451147, 4.815810, 4.484100, 4.369366, 4.307558, 5.606415, 6.744229, 8.282779, 7.715722, 
                    4.591133, 4.627387, 4.703190, 4.836346, 5.006981, 5.137323, 4.883073, 4.928440, 4.825074, 4.861046, 4.618354,
                    7.052928, 6.923112, 6.902294, 9.631620, 8.968200, 8.738732, 8.615116, 8.367784, 8.125577, 8.282779, 7.715722
	               ), nrow = 3, ncol=11, byrow=TRUE, dimnames = list(c("NZUs","GHGs","Allowed"),
c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")))

png("Industry-Allocation-GHGsallowed-2020-2018-560by420-v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table4,ylim=c(0,11.5),las=1,space=c(0.1,1.1), beside = TRUE, col=c("brown3","#ED731D","#F0E442"))
title(cex.main=1.4,main="Emissions allowed by allocation of units 2010 2020",ylab="Units/ tonnes GHG CO2-e (millions)")
mtext(side=1,line=2.5,cex=1,expression(paste("Source: MfE GHG Inventory 1990 2020, EPA Industrial allocation decisions")))
legend("topleft", inset=c(0.0,0.0) ,bty="n",c("Allocation of units to industry 55mt","Actual industry emissions 53mt","Emissions footprint of allocation 89mt"),fill=c("brown3","#ED731D","#F0E442"))
dev.off()

# create table that is just actual emissions and emissions permitted by NZUs 2010 2018
itable5 <- matrix(c(1.763232, 3.461556, 3.451147, 4.815810, 4.48410, 4.369366, 4.307558, 5.606415, 6.744229, 
                    3.526464, 6.923112, 6.902294, 9.63162, 8.968200, 8.738732, 8.615116, 8.367784, 8.125577    
	               ), nrow = 2, ncol=9, byrow=TRUE, dimnames = list(c("GHGs","Allowed"),
c("2010","2011","2012","2013","2014","2015","2016","2017","2018")))

png("Industry-Allocation-GHGsallowed-2010-2018-560by420-v2.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(itable5,ylim=c(0,12), las=1,space=c(0.1,1.1), beside = TRUE, col=c("brown3","#ED731D"))
title(cex.main=1.4,main="Actual industry emissions vs emissions represented by \nindustrial allocation of units 2010 to 2018",ylab="tonnes GHG CO2-e (millions)")
mtext(side=1,line=2.5,cex=1,expression(paste("Source: MfE GHG Inventory 1990 2018, EPA Industrial allocation decisions")))
legend(c(2,12), inset=c(0,0,0,0) ,bty="n",c("Actual industry emissions 44 million tonnes","Emissions permited by free allocation 70 million tonnes"),fill=c("brown3","#ED731D"))
dev.off()
str(Annualallocations) 
'data.frame':	11 obs. of  5 variables:
 $ Year        : num  2010 2011 2012 2013 2014 ...
 $ Allocation  : num  1.76 3.46 3.45 4.82 4.48 ...
 $ unitdiscount: num  0.25 0.5 0.5 0.5 0.5 0.5 0.5 0.67 0.83 1 ...
 $ IndustryGHG : num  4.59 4.63 4.7 4.84 5.01 ...
 $ Permitted   : num  7.05 6.92 6.9 9.63 8.97 ..  
summary(Annualallocations)
Min.   :2010   Min.   :1.763   Min.   :0.2500   Min.   :4.591  
 1st Qu.:2012   1st Qu.:3.885   1st Qu.:0.5000   1st Qu.:4.665  
 Median :2015   Median :4.484   Median :0.5000   Median :4.836  
 Mean   :2015   Mean   :5.000   Mean   :0.6136   Mean   :4.820  
 3rd Qu.:2018   3rd Qu.:6.175   3rd Qu.:0.7500   3rd Qu.:4.906  
 Max.   :2020   Max.   :8.283   Max.   :1.0000   Max.   :5.137  
   Permitted    
 Min.   :6.902  
 1st Qu.:7.384  
 Median :8.283  
 Mean   :8.120  
 3rd Qu.:8.677  
 Max.   :9.632  
  
png("Industry-Allocation-GHGs-allowed-line-2010-2020-560by420-v2.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(2.7,2.7,1,1)+0.1)

plot(Annualallocations[["Year"]],Annualallocations[["Permitted"]],ylim=c(0,10), xlim=c(2010,2020),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0, lwd = 1, at = c(2010:2020), labels = c(2010:2020), tick = TRUE)
axis(side=2, tck=0.01, las=2, line = NA,lwd = 1, at = c(0:8), labels = c(0:8),tick = TRUE)
axis(side=4, tck=0.01, at = c(0:8), labels = FALSE, tick = TRUE)
box(lwd=1)
lines(Annualallocations[["Year"]],Annualallocations[["Permitted"]],col="#7570b3",lwd=1)
points(Annualallocations[["Year"]],Annualallocations[["Permitted"]],col="#7570b3",pch=16)

lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#1b9e77",lwd=1)
points(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#1b9e77",cex=1,pch=15)
lines(Annualallocations[["Year"]],Annualallocations[["IndustryGHG"]],col="#d95f02",lwd=1)
points(Annualallocations[["Year"]],Annualallocations[["IndustryGHG"]],col="#d95f02",cex=1,pch=14)

lines(Annualallocations[["Year"]],Annualallocations[["Industry"]]/1000,col="#7570b3",lwd=1)
#points(Annualallocations[["Year"]],Annualallocations[["Industrial"]]/1000,col="#7570b3",cex=1,pch=9)
lines(Annualallocations[["Years"]],Annualallocations[["Waste"]]/1000,col="#e7298a",lwd=1,lty=2)
#points(Annualallocations[["Years"]],Annualallocations[["Waste"]]/1000,col="#e7298a",cex=1,pch=10)
lines(Annualallocations[["Years"]],Annualallocations[["LULUCF"]]/1000,col="#66a61e",lwd=1)
points(Annualallocations[["Years"]],Annualallocations[["LULUCF"]]/1000,col="#66a61e",cex=1,pch=17)
abline(h=0,col=1,lwd=1,lty=1)
text(1990,50,adj=0,"Net Emissions + 65%",col=1,cex=1)
text(2017,43,adj=1,"NZUs + 14%",col=1,cex=1)
text(2017,26,adj=1,"Energy + 38%",col=1,cex=1)
text(1990,10,adj=0,"Waste + 2%",col=1,cex=1)
text(2017,10,adj=1,"Industry + 39%",col=1,cex=1)
text(2017,-18,adj=1,"Land Use Land Use Change and Forestry Removals -23%",col=1,cex=1)
mtext(side=1,line=-7.5,cex=0.8,"Data: New Zealand’s Greenhouse Gas Inventory 1990 – 2017, MfE 2019 Report ME 1411 ")
mtext(side=3,cex=1.5, line=-3.3,expression(paste("New Zealand Greenhouse Gas Emissions \nby Sector 1990 to 2017")) )
mtext(side=2,cex=0.9, line=-1.5,expression(paste("million tonnes C", O[2], "-e")))
mtext(side=4,cex=0.75, line=0.05,R.version.string)
dev.off()


# check last 5 years of Industry emissions from NZ GHG inventory stated in Kilotonnes
tail(crfsummarydatasector[["Industry"]]) 
[1] 4987.284 5189.651 5037.535 5136.064 5186.913 5115.907 

# check last all 30 years of Industry emissions from NZ GHG inventory stated in Kilotonnes
crfsummarydatasector[["Industry"]] 
 [1] 3579.924 3728.611 3374.093 3213.464 3082.804 3174.432 3374.129 3234.767
 [9] 3261.323 3398.640 3443.222 3558.481 3680.456 3916.535 3952.997 4061.648
[17] 4171.177 4420.973 4320.111 4193.182 4543.708 4632.152 4672.928 4819.442
[25] 4987.284 5189.651 5037.535 5136.064 5186.913 5115.907


# last ten years of ETS and free allocation of units
crfsummarydatasector[["Year"]][21:30]
[1] "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"

# check last 10 years of Industrial emissions from inventory 2010  2019

crfsummarydatasector[["Industry"]][21:30]
[1] 4543.708 4632.152 4672.928 4819.442 4987.284 5189.651 5037.535 5136.064
[9] 5186.913 5115.907 
 
# create object that is industry emissions 10 years to 2019 restated in million tonnes 
IndustryGHG <- crfsummarydatasector[["Industry"]][21:30]/10^3

# print object to screen
IndustryGHG 
[1] 4.543708 4.632152 4.672928 4.819442 4.987284 5.189651 5.037535 5.136064
[9] 5.186913 5.115907

# what were actual emissions from 2010 to 2019? 
sum(IndustryGHG)
[1] 49.32158 

# create variable that is the 'two-for-one' discount - 2 tonnes = 1 unit to surrender  https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/participating-in-the-ets/surrendering-units/
# "Phase out of the '1 for 2' surrender obligation, Prior to 2017, non-forestry participants had to surrender one eligible unit for every two tonnes of emissions they reported in their Annual emissions return, effectively a 50% surrender obligation. 2017 - surrender 1 unit for 1.5 whole tonnes of emissions 2018 - surrender 1 unit for 1.2 whole tonnes of emissions, 2019 - surrender 1 unit for 1 whole tonne of emissions 

unitdiscount <- c(0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.67,0.83,1)

# create variable that is the emissions permitted by each years allocation of free units in mts i.e. 2 tonnes for 1 NZU
AllocationGHG <- Annualallocations[["Allocation"]]/unitdiscount

cbind(Annualallocations,IndustryGHG,unitdiscount,AllocationGHG) 

IndustryAllocationGHG20102019 <- cbind(Annualallocations,IndustryGHG,unitdiscount,AllocationGHG)

# print dataframe to screen 
IndustryAllocationGHG20102019
Year Allocation IndustryGHG unitdiscount AllocationGHG
1  2010   1.763232    4.543708         0.25      3.526464
2  2011   3.461556    4.632152         0.50      6.923112
3  2012   3.451147    4.672928         0.50      6.902294
4  2013   4.815810    4.819442         0.50      9.631620
5  2014   4.484100    4.987284         0.50      8.968200
6  2015   4.369366    5.189651         0.50      8.738732
7  2016   4.307558    5.037535         0.50      8.615116
8  2017   5.606415    5.136064         0.67      8.367784
9  2018   6.744229    5.186913         0.83      8.125577
10 2019   8.282779    5.115907         1.00      8.282779 

# create table that is only industrial free allocation 2010 to 2019  
# possible colors col=c("#fde0dd","#fa9fb5","#c51b8a")) # colours are pink/mauve/purple

# very dark gray
barplot(table1,las=1,space=c(0.1,1.1), beside = TRUE, col=c("gray10")) 
# very light gray
barplot(table1,las=1,space=c(0.1,1.1), beside = TRUE, col=c("gray90")) 

table1 <- matrix(c(1.763232, 3.461556, 3.451147, 4.815810, 4.48410, 4.369366, 4.307558, 5.606415, 6.744229,8.282779), 
nrow = 1, ncol=10, byrow=TRUE, dimnames = list(c("NZUs"),
c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019")))

png("Industry-Allocation-2010-2019-560by420-v1.png", bg="white", width=560, height=420,pointsize = 14)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table1,las=1,space=c(0.1,1.1), beside = TRUE, col=c("gray50")) 
title(cex.main=1.3,main="Allocation of free emission units to Industry 2010 to 2019",ylab="Units/tonnes GHG CO2-e (millions)")
mtext(side=1,line=2.5,cex=1,expression(paste("Source: EPA Industrial allocation decisions")))
mtext(side=3,line=0,cex=0.9,expression(paste("From 2010 to 2019 industries were allocated 47 million free units")))
dev.off() 


# How many units were given to New Zealand Steel Development Limited each year?

Allocations[(Allocations[["Name"]]=="New Zealand Steel Development Limited"),c("Year","Allocation")]
    Year Allocation
108  2010     494704
258  2011     989304
397  2012    1003730
521  2013    1029352
631  2014    1073489
739  2015    1067501
833  2016    1048116
921  2017    1432496
1008 2018    1782366
     2019    2118983
     
# How many units were given to greenhouse horticulture in total?
sum(Allocations[(Allocations[["Activity"]]==c("Cut roses","Fresh capsicums","Fresh tomatoes"),"Allocation"])
[1] 
# 10 million

Allocations[(Allocations[["Activity"]]==c("Cut roses","Fresh capsicums","Fresh tomatoes"),"Allocation"]

# How many units were given to New Zealand Steel Development Limited in total?
sum(Allocations[(Allocations[["Name"]]=="New Zealand Steel Development Limited"),"Allocation"])
[1] 12060186
# 12 million

# What was the market value of the units given to New Zealand Steel Development Limited in total?
sum(Allocations[(Allocations[["Name"]]=="New Zealand Steel Development Limited"),c("Value")])
[1] 124212977
# 124 million dollars

# What was the market value of the units given to New Zealand Steel Development Limited each year?
Allocations[(Allocations[["Name"]]=="New Zealand Steel Development Limited"),c("Year","Value")]
    Year    Value
108  2010  8696896
258  2011 19627791
397  2012  6253238
521  2013  1996943
631  2014  4379835
739  2015  5700455
833  2016 15333937
921  2017 24295132
1008 2018 37928748

# How many units given to NZ Steel each year?
Allocations[(Allocations[["Name"]]=="New Zealand Steel Development Limited"),c("Year","Allocation")]
 Year Allocation
   <dbl>      <dbl>
 1  2010     494704
 2  2011     989304
 3  2012    1003730
 4  2013    1029352
 5  2014    1073489
 6  2015    1067501
 7  2016    1048116
 8  2017    1432496
 9  2018    1782366
10  2019    2118983
11  2020    2030166 

NZsteel <- Allocations[(Allocations[["Name"]]=="New Zealand Steel Development Limited"),c("Year","Allocation")] 
str(NZsteel) 
tibble [11 × 2] (S3: tbl_df/tbl/data.frame)
 $ Year      : num [1:11] 2010 2011 2012 2013 2014 ...
 $ Allocation: num [1:11] 494704 989304 1003730 1029352 1073489 ... 

NZaluminium <- Allocations[(Allocations[["Name"]]=="New Zealand Aluminium Smelters Limited"),c("Year","Allocation")] 
 
# NZaluminium <- filter(Allocations,c("Year","Allocation"), Name == c("New Zealand Aluminium Smelters Limited"))
str(NZaluminium)
tibble [11 × 2] (S3: tbl_df/tbl/data.frame)
 $ Year      : num [1:11] 2010 2011 2012 2013 2014 ...
 $ Allocation: num [1:11] 210421 437681 301244 1524172 755987 ... 
 
hothouse2019 <- filter(nzu2019, Activity == c("Cut roses","Fresh capsicums","Fresh cucumbers","Fresh tomatoes")) 

# How many by Activity ?
activitysum <- aggregate(Allocation ~ Activity, Allocations, sum) 
str(activitysum) 
'data.frame':	26 obs. of  2 variables:
 $ Activity  : chr  "Aluminium smelting" "Burnt lime" "Carbamide (urea)" "Carbon steel from cold ferrous feed" ...
 $ Allocation: num  10407692 1493104 2306629 240048 1112834 ... 
# How many by Applicants ?
applicantsum <- aggregate(Allocation ~ Name, Allocations, sum)
str(applicantsum) 
'data.frame':	162 obs. of  2 variables:
 $ Name : chr  "ACI OPERATIONS NZ LIMITED" "Affco New Zealand Limited" "Alliance Group Limited" "Alwyn Ernest Inger, Anne Marie Inger" ...
 $ Allocation: num  457184 84603 80841 2220 70102 ... 
 
 # Create .csv formatted data file
write.csv(activitysum, file = "nzu-allocation-activities.csv", row.names = FALSE)
write.csv(applicantsum, file = "nzu-allocation-applicants.csv", row.names = FALSE)

brewer.pal(2, "Paired")
[1] "#A6CEE3" "#1F78B4" "#B2DF8A"
Warning message:
In brewer.pal(2, "Paired") :
  minimal value for n is 3, returning requested palette with 3 different levels

  
glasshouse[order(glasshouse$Allocation),]

# create table that is NZ AL allocation baseline Climate Change (Eligible Industrial Activities) Regulations 2010 No 7
# https://www.legislation.govt.nz/regulation/public/2010/0189/latest/DLM3075118.html
baselines <-c(2.645,2.726,2.062,10.441,5.136,5.152,5.160, 5.142,5.184,5.366,5.194,2.120,2.005)
str(baselines)
num [1:13] 2.65 2.73 2.06 10.44 5.14  

nzalbaseline <- matrix(baselines, nrow = 1, ncol=13, byrow=TRUE, dimnames = list(c("NA"),
c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022")))

svg(filename ="NZAL-Allocation-baseline-2010-2022-720-540.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white")
#png("NZAL-Allocation-baseline-2010-2022-560by420-v1.png", bg="white", width=560, height=420,pointsize = 11)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(nzalbaseline,ylim=c(0,11),las=1,space=c(0.1,1.1), beside = TRUE, col=c(rep("#ED731D",12),"red"))
title(cex.main=1.6,main="Aluminium Allocation Baseline Factor 2010 - 2022",ylab="Units per tonne aluminium produced",xlab="")
mtext(side=1,line=2.5,cex=1,expression(paste("Source: Climate Change (Eligible Industrial Activities) Regulations 2010 No 7")))
mtext(side=3,line=0,cex=0.9,expression(paste("What happened in 2013? The allocation factor is five times more than emissions per tonne aluminium")))
legend("topright", inset=c(0.0,0.0) ,bty="n",cex=1.2,c("Final allocation","Provisional allocation"),fill=c("#ED731D","red"))
dev.off()
