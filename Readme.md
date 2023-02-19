# Industrial allocation - free emissions units given to emitter industries in New Zealand 2010 to 2020 

## 3 November 2022

What is Industrial Allocation under the New Zealand Emissions Trading Scheme?

The Ministry for the Environment says [Allocations of New Zealand Units are given to businesses carrying out certain activities](https://environment.govt.nz/what-government-is-doing/areas-of-work/climate-change/ets/participating-in-the-nz-ets/overview-industrial-allocation/).
  
I prefer what Motu Research say. That one (out of five) ways of allocating emissions units in an emissions trading scheme is industrial allocation which Motu define as [Receiving them for free](https://www.motu.nz/assets/Documents/our-research/environment/climate-change-mitigation/emissions-trading/A-Guide-to-the-New-Zealand-Emissions-Trading-System-2018-Motu-Research.pdf)

I have posted in detail about industrial allocation to [New Zealand Steel](https://rwmjohnson.blogspot.com/search/label/New%20Zealand%20Steel) and to [New Zealand Aluminium Smelters Limited](https://rwmjohnson.blogspot.com/search/label/NZ%20Aluminium%20Smelters)

However, I want to look at [Industrial Allocation](https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/) in the round. How many emissions units have been given away since 2010? Is it a big number?

The Environmental Protection Authority annually publish the [final allocation](https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/) of emissions units. So some analysis can be done.

Load applications
```{r}
library(readxl)
library(RColorBrewer)
```
Obtain emission unit allocation to industry data from EPA Industrial Allocation webpage
```{r}
download.file("https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx", "Industrial-Allocations-Final-Decisions.xlsx") 
trying URL 'https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Reports/Industrial-Allocations/Industrial-Allocations-Final-Decisions.xlsx'
Content type 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' length 56684 bytes (55 KB)
==================================================
downloaded 55 KB 
```
Check how many worksheets
```{r}
excel_sheets("Industrial-Allocations-Final-Decisions.xlsx")
[1] "IA Final Decisions"
```
```{r}
Allocations <- read_excel("Industrial-Allocations-Final-Decisions.xlsx", sheet = "IA Final Decisions",skip=3)
```
Rename column variables and reorder columns
```{r}
colnames(Allocations) <- c("Activity","Name","Year", "Allocation") 
Allocations <- Allocations[,c("Year","Activity","Name","Allocation")] 
names(Allocations)
[1] "Year"       "Activity"   "Name"  "Allocation" 
```
Make csv file of allocations data
```{r}
write.table(Allocations, file = "Allocations.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 
```
Read in csv file
```{r}
Allocations<-read.csv("Allocations.csv")
```
How many emissions units have been given away from 2010 to 2020?
```{r}
sum(Allocations[["Allocation"]])
[1] 55001914 
```
The total is 55 million

Create datframe of how many emission units were allocated for each year
```{r}
Annualallocations <- aggregate(Allocations[["Allocation"]] ~ Year, Allocations, sum)
```
Check the data frame
```{r}
str(Annualallocations) 
'data.frame':	11 obs. of  2 variables:
 $ Year                       : num  2010 2011 2012 2013 2014 ...
 $ Allocations[["Allocation"]]: num  1763232 3461556 3451147 4815810 4484100
```
Rename column variables
```{r}
colnames(Annualallocations) <- c("Year", "Allocation") 
```
Restate to 10^6 (millions) 
```{r}
Annualallocations["Allocation"] <- Annualallocations[["Allocation"]]/10^6
```
```{r}
str(Annualallocations) 
'data.frame':	11 obs. of  2 variables:
 $ Year      : num  2010 2011 2012 2013 2014 ...
 $ Allocation: num  1.76 3.46 3.45 4.82 4.48 ... 
```
Create table that is industrial allocation of emission units
```{r}
Annualallocations[["Allocation"]] 
[1] 1.763232 3.461556 3.451147 4.815810 4.484100 4.369366 4.307558 5.606415
 [9] 6.744229 8.282779 7.715722
``` 
```{r}
table1 <- matrix(c(Annualallocations[["Allocation"]]), nrow = 1, ncol=11, byrow=TRUE, dimnames = list(c("NZUs"),c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")))
```
```{r}
table1
         2010     2011     2012    2013   2014     2015     2016     2017
NZUs 1.763232 3.461556 3.451147 4.81581 4.4841 4.369366 4.307558 5.606415
         2018     2019     2020
NZUs 6.744229 8.282779 7.715722 
```
Select some colours for charts
```{r}
brewer.pal("Dark2",n=3)
[1] "#1B9E77" "#D95F02" "#7570B3"  # teal khaki mauve/blue
```
Chose colourn for bars - blue blue/mauve "#7570b3" Deluge - check what it looks like
```{r}
barplot(matrix(c(5:9),nrow = 1, ncol=5, byrow=F), col= "#7570b3",cex.main=2,main="Colour is Deluge #7570b3",xlab="Deluge #7570b3")
```
Create barplot chart of industrial allocation of emission units in colour 'Deluge' #7570b3"
```{r}
svg(filename ="Industrial-Allocation-barplot-2010-2020-720-540v1.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white")
#png("Industrial-Allocation-barplot-2010-2020-560by420-v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table1,ylim=c(0,9),las=1,space=c(0.1,1.1), beside = TRUE, col=c("#7570b3"))  
title(cex.main=1.4,main="Emission units allocated to industry 2010 to 2020",ylab="emission units (millions)")
mtext(side=1,line=2.5,cex=0.8,expression(paste("Source: EPA Industrial allocation decisions \nhttps://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")))
mtext(side=3,line=0,cex=1,expression(paste("From 2010 to 2020 industries were allocated 55 million free emission units")))
dev.off()
```
How many units? The answer is that from 2010 to 2020 fifty five million or 55,001,914 emissions units have been given at no cost to 162 entities from 2010 to 2020.

This bar plot shows the 55 million emissions units allocated year by year.

![](Industrial-Allocation-barplot-2010-2020-720-540v1.svg)

# Industrial allocation exempts from pricing twice as many tonnes of emissions than the total emissions for the Industry sector 

This line chart also shows the 55 million emission units.

![](Industrial-Allocation-line-2010-2020-720-540-v1.svg)

Here is a pie chart of the quantities of free emission units allocated to industries. Note the highly regressive distribution favouring major corporates. Of the 55 million units, 49 million went to ten companies.
![](Allocations-pie-quantity-2010-2020_720-7200.svg)

Here is a pie chart of the percentages of free emission units allocated to industries. Again note the highly regressive distribution favouring major corporates. 89 percent of all units allocated went to ten companies.
![](Allocations-pie-precent-2010-2020_720-720.svg)

Here is a barplot of the 53 million tonnes of actual emissions from the New Zealand industrial sector from the [Greenhouse Gas Inventory](https://environment.govt.nz/facts-and-science/climate-change/measuring-greenhouse-gas-emissions/about-new-zealands-greenhouse-gas-inventory/).

![](Industry-Emissions-barplot-2010-2020-720-540.svg)

Here is a line chart of the 53 million tonnes of actual emissions and the Industrial Allocation - the free allocation of the 55 million emission units.

![](Industrial-Allocation-line-2010-2020-720-540-v2.svg)

So at first glance it appears that the amount of free emission units allocated cancel out the actual industry emissions. This suggests that in a net sense the industry sector emissions are not priced at all under the emissions trading scheme They are more than 'offset' by the allocation of free units. 

So it's the same net result as if the industry sector was completely exempted from the emissions trading scheme requirements to surrender emission units equal to their emissions.

However I am missing a step in my analysis. In my detailed examples for New Zealand Steel and New Zealand Aluminium Smelters, I estimated the actual liability to surrender units by multiplying the Greenhouse Gas Inventory steel and aluminium emissions by a variable representing the "two for one" discount introduced in 2009 by the Hon Dr Nick Smith when he was the Minister for Climate Changes Issues.

On 1 September 2009 with Dr Smith's approval ["Emissions trading bulletin No 11: Summary of the proposed changes to the NZ ETS"](https://environment.govt.nz/publications/emissions-trading-bulletin-no-11-summary-of-the-proposed-changes-to-the-nz-ets/summary/) was published. It stated that the emissions trading scheme would be amended by adding a transition phase lasting to 31 December 2012 which would feature a "progressive obligation".

![](E-Bull-11-Screenshot_2022-12-14_16-24-45.png)

The 'progressive obligation' was effectively a 50% discount on the 'surrender obligation', the quantity of emissions units that emitters had to surrender. Each firms industrial allocation of emission units would in consequence also be halved as well.

![](E-Bull-50percent-Screenshot_2022-12-14_16-26-29.png)

Then in 2012, Minister for Climate Change Issues Tim Groser introduced the [Climate Change Response (Emissions Trading and Other Matters) Amendment Bill](https://www.legislation.govt.nz/bill/government/2012/0052/13.0/DLM4812000.html). This bill extended the life of the "two for one" 'progressive obligation' indefinitely.

Finally, in 2016, Minister for Climate Change Issues Paula Bennett introduced a bill to "phase out" the 'progressive obligation' over three years from 2017 to 2019 by increments from the original "two for one" - 2 units per tonne to 1.5 to 1.2 to 1 unit per tonne of emissions. See the ["EPA document ETS Surrender Obligations One for two phase out factsheet"](https://www.epa.govt.nz/assets/Uploads/Documents/Emissions-Trading-Scheme/Guidance/ETS-Surrender-Obligations-One-for-two-phase-out-factsheet.pdf)

So I need to include a discount variable that is then multiplied by the free emission units allocated to result in the "emissions footprint" of the allocation of units. The discount variable is 0.25 for 2010 (half obligation for half a year),then 0.5 from 2011 to 2016, 0.67 in 2017 ,0.83 in 2018 and finally one for one for 2019 and 2020.

This allows me to estimate of the [carbon footprint](https://www.britannica.com/science/carbon-footprint) or [emissions footprint](https://www.sciencedirect.com/topics/engineering/emission-footprint) of all the units given under Industrial Allocation. As in this chart.

![](Industrial-Allocation-line-2010-2020-720-540-v3.svg)

I can then add the 'emissions footprint' values or the emissions allowed by the free Industrial Allocation units to the chart of allocated emission units and actual industry emissions.

![](Industrial-Allocation-line-2010-2020-720-540-v4.svg)

The chart shows a huge gap between the emissions footprint and the allocated units until 2017 when the two lines start to converge. Then in 2019, the emissions foot print is the same as the units allocated as finally, under the emissions trading scheme, one emission unit does in fact equate to one tonne of emissions. The total of the Industrial Allocation 'emissions footprint' over 2010 to 2020 is 89 million tonnes. Those 89 million tonnes have been exempted or "de-priced" by the emissions trading scheme.

Just a reminder. What is an emission unit? It's a right to emit greenhouse gases to the atmosphere. Owning an emission unit is the same as permission to emit a quantity of greenhouse gases whether from smelting or just from burning coal oil or gas. Being allocated a unit is the same as being told "go for it - you can just burn coal or oil or gas without penalty until a tonne of carbon dioxide is in the atmosphere". It's the opposite of a price on carbon. It's a permit or licence to burn carbon.

How can that possibly be the case? It is because of the [electricity allocation factor](https://web.archive.org/web/20110712151351/http://www.climatechange.govt.nz/emissions-trading-scheme/building/regulatory-updates/eaf-update.html). The 'emissions factors' used in allocation include a factor for upstream ETS related elctricity price increases.

Industrial Allocation therefore "de-prices" and removes the emissions price signal from some energy sector emissions in addition to the direct industry process emissions.

In a net sense Industrial Allocation is worse as a policy to reduce industry emissions than a complete exemption of industry from the emissions trading scheme. In a scenario of 100% exemption, at least all electricity and energy sector carbon emissions would in theory be priced.
