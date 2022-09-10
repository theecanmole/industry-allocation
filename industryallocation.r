New Zealand’s historical and projected greenhouse gas emissions from 1990 to 2050 using AR5 values
https://environment.govt.nz/what-government-is-doing/areas-of-work/climate-change/emissions-reduction-targets/new-zealands-projected-greenhouse-gas-emissions-to-2050/
Data
https://environment.govt.nz/assets/2050-historical-and-projected-sectoral-emissions-data-March_2022-2.xlsx


NZ-ETS-settings-2023-2027-final-report-web-27-July-2022
page 38 of NZ-ETS-settings-2023-2027-final-report-web-27-July-2022
Our forecast of industrial free allocation volumes per year for 2023-2027 is given in the table below.
6.4 6.3 6.3 6.2 6.1

https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/


expand 2020 final allocation decisions
Silver Fern Farms 0
New Zealand Steel Development Limited 2,030,166

https://environment.govt.nz/publications/new-zealands-greenhouse-gas-inventory-1990-2020/
https://environment.govt.nz/assets/publications/GhG-Inventory/Summary-emissions-data.xlsx

https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/eligibility/
https://www.nzherald.co.nz/business/opinion-fairly-sharing-the-burden-is-necessary-for-climate-success/LT2DSAYNPOB4M5J77BMPXQUMJU/
library(tidyr)
library(readxl)
library(dplyr)
getwd()

[1] "/media/user/RED/Industry-allocation" 

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

# rename column variables
colnames(Allocations) <- c("Activity","Name","Year", "Allocation") 
# can I reorder columns easily in base R? Yes.
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
#write.table(Allocations, file = "Allocations.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 
# read in csv file
Allocations<-read.csv("Allocations.csv")
names(Allocations)
[1] "Year"       "Activity"   "Name"       "Allocation"

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
 $ Gross emissions (without LULUCF)               : num [1:31] 65197 66176 67332 67194 68444 ...

# make Year a numeric vector
crfsummarydatasector[["Year"]] <- as.numeric(crfsummarydatasector[["Year"]]) 

# revise and shorten column names
colnames(crfsummarydatasector) <- c("Year", "Energy", "Industry", "Agriculture", "Waste", "Tokelau","LULUCF", "Net Emissions", "Gross Emissions")

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
head(Allocations)
            Activity                                Name Year Allocation
1 Aluminium smelting   New Zealand Aluminium Smelters Limited 2010     210421
2         Burnt lime                    Graymont (NZ) Limited 2010      47144
3         Burnt lime             Holcim (New Zealand) Limited 2010       3653
4         Burnt lime               Perry Resources (2008) Ltd 2010       4712
5         Burnt lime   Websters Hydrated Lime Company Limited 2010        948
6   Carbamide (urea) Ballance Agri-Nutrients (Kapuni) Limited 2010      93275 
names(Allocations)
[1] "Year"       "Activity"   "Name"       "Allocation" "Value"

Allocations2 <- Allocations[,c("Year","Name","Allocation","Value")]  
 
str(Allocations2) 
'data.frame':	1207 obs. of  4 variables:
 $ Year      : int  2010 2010 2010 2010 2010 2010 2010 2010 2010 2010 ...
 $ Name      : chr  "New Zealand Aluminium Smelters Limited" "Graymont (NZ) Limited" "Holcim (New Zealand) Limited" "Perry Resources (2008) Ltd" ...
 $ Allocation: int  210421 47144 3653 4712 948 93275 16818 34 39164 4958 ...
 $ Value     : num  3699201 828792 64220 82837 16666 ...   

# Convert long to wide https://www.youtube.com/watch?v=TYUyXrwmPOM

Allocationswide <- pivot_wider(data = Allocations,names_from ="Name",values_from="Allocation") 
Warning message:
Values from `Allocation` are not uniquely identified; output will contain list-cols.
* Use `values_fn = list` to suppress this warning.
* Use `values_fn = {summary_fun}` to summarise duplicates.
* Use the following dplyr code to identify duplicates.
  {data} %>%
    dplyr::group_by(Year, Name) %>%
    dplyr::summarise(n = dplyr::n(), .groups = "drop") %>%
    dplyr::filter(n > 1L) 

names(Allocationswide)
  [1] "Year"                                                                               
  [2] "New Zealand Aluminium Smelters Limited"                                             
  [3] "Graymont (NZ) Limited"                                                              
  [4] "Holcim (New Zealand) Limited"                                                       
  [5] "Perry Resources (2008) Ltd"    
 head(Allocationswide,1)
# A tibble: 1 × 163
   Year `New Zealand Alumin…` `Graymont (NZ)…` `Holcim (New Z…` `Perry Resourc…`
  <int> <list>                <list>           <list>           <list>          
1  2010 <int [1]>             <int [1]>        <int [2]>        <int [1]>       
# … with 158 more variables: `Websters Hydrated Lime Company Limited` <list>,
#   `Ballance Agri-Nutrients (Kapuni) Limited` <list>, 

  
Allocation %>% pivot_wider(names_from ="Name",values_from="Allocation")

head(Allocations %>% pivot_wider(names_from ="Name",values_from="Allocation"))
# A tibble: 6 × 164
   Year Activity              `New Zealand A…` `Graymont (NZ)…` `Holcim (New Z…`
  <int> <chr>                            <int>            <int>            <int>
1  2010 Aluminium smelting              210421               NA               NA
2  2010 Burnt lime                          NA            47144             3653
3  2010 Carbamide (urea)                    NA               NA               NA
4  2010 Carbon steel from co…               NA               NA               NA
5  2010 Cartonboard                         NA               NA               NA
6  2010 Caustic soda                        NA               NA               NA
# … with 159 more variables: `Perry Resources (2008) Ltd` <int>, 

head(pivot_wider(Allocations,id_cols=c("Year","Name","Allocation"), names_from ="Name",values_from="Allocation"))
head(pivot_wider(Allocations, names_from ="Name",values_from="Allocation"))
# A tibble: 6 × 164
   Year Activity              `New Zealand A…` `Graymont (NZ)…` `Holcim (New Z…`
  <int> <chr>                            <int>            <int>            <int>
1  2010 Aluminium smelting              210421               NA               NA
2  2010 Burnt lime                          NA            47144             3653 
head(pivot_wider(Allocations, id_cols=c(1,3,4), names_from ="Name",values_from="Allocation",names_sort=TRUE))
# create new dataframe that is allocations by applicant
Namesallocations <-pivot_wider(Allocations,id_cols=NULL, names_from ="Name",values_from="Allocation")
dim(Namesallocations)
[1] 275 164 
head(Namesallocations)
# A tibble: 6 × 164
   Year Activity              `New Zealand A…` `Graymont (NZ)…` `Holcim (New Z…`
  <int> <chr>                            <int>            <int>            <int>
1  2010 Aluminium smelting              210421               NA               NA
2  2010 Burnt lime                          NA            47144             3653
3  2010 Carbamide (urea)                    NA               NA               NA
4  2010 Carbon steel from co…               NA               NA               NA
5  2010 Cartonboard                         NA               NA               NA 
head(Namesallocations[,-2])
# A tibble: 6 × 163
   Year `New Zealand Alumin…` `Graymont (NZ)…` `Holcim (New Z…` `Perry Resourc…`
  <int>                 <int>            <int>            <int>            <int>
1  2010                210421               NA               NA               NA
2  2010                    NA            47144             3653             4712
3  2010                    NA               NA               NA               NA
4  2010                    NA               NA               NA               NA 
# Create .csv formatted data file
write.csv(Namesallocations, file = "Namesallocations.csv", row.names = FALSE) 

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


# How many Applicants are receiving free emission units? 162
Applicants <- aggregate(Allocation ~ Name, Allocations, sum)
str(Applicants)
'data.frame':	162 obs. of  2 variables:
 $ Name : chr  "ACI OPERATIONS NZ LIMITED" "Affco New Zealand Limited" "Alliance Group Limited" "Alwyn Ernest Inger, Anne Marie Inger" 
 $ Allocation: int  457184 84603 80841 2220 70102 34 1381 245 243792 60 ...

# How many emissions units have been given away from 2010 to 2020?
sum(Allocations[["Allocation"]])
[1] 55001914 
# 55 million

top10names<-c("NZ Steel", "NZ Aluminium Smelters", "Methanex NZ", "Fletcher Concrete", "Oji Fibre", "Ballance Agri-Nutrients", "Pan Pac Forest Products", "Norske Skog Tasman", "Winstone Pulp", "Graymont","Others")
top10allocation <-c(1782366, 1324556,  945210,  584032,  484322,  325594,  210652,  200556,  151546, 144405,590334 )
palettepair11<-brewer.pal(11, "Paired")
png("nzu-allocations-pie-2018-565.png", width=565, height=424, pointsize = 14)
pie(top10allocation,labels=c(top10names),radius = 0.99,clockwise = FALSE,init.angle=260, col = palettepair11, cex.lab=1.1,cex.main=1.5,main="NZETS free allocation of emission units\nto the Top Ten Emitters 2018")
mtext(side=1,cex=0.9,line=2.6,"Source: https://www.epa.govt.nz/industry-areas/\nemissions-trading-scheme/industrial-allocations/decisions/")
mtext(side=1,cex=1,line=0.4,"Of 6.7 million units allocated to industry, 6.2 million (91%) went to 10 companies")
dev.off() 

# How many emission units were allocated for each year

annualallocations <- aggregate(Allocations[["Allocation"]] ~ Year, Allocations, sum)

# check the data frame
str(annualallocations) 
'data.frame':	11 obs. of  2 variables:
 $ Year                       : num  2010 2011 2012 2013 2014 ...
 $ Allocations[["Allocation"]]: num  1763232 3461556 3451147 4815810 4484100

# rename column variables
colnames(annualallocations) <- c("Year", "Allocation") 

# restate to 10^6 (millions) 
annualallocations["Allocation"] <- annualallocations[["Allocation"]]/10^6

str(annualallocations) 
'data.frame':	11 obs. of  2 variables:
 $ Year      : num  2010 2011 2012 2013 2014 ...
 $ Allocation: num  1.76 3.46 3.45 4.82 4.48 ...

annualallocations
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
write.csv(annualallocations, file = "annualallocations.csv", row.names = FALSE)  
# How many units given to NZ Steel each year?

# linear regression 
linearregression <- lm(Allocation ~ Year, annualallocations)
plot(annualallocations,type='p',col=2)
lines(abline(linearregression))
lines(abline(lm(annualallocations[["Allocation"]][2:11]~ c(1:10))))
Call:
lm(formula = Allocation ~ Year, data = annualallocations)
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

# eliminate 2010 as it was ahalf year
allocations20112020 <- annualallocations[["Allocation"]][2:11]
years20112020 <- c(2011:2020)
linear2011regression <- lm(Allocation ~ Year, annualallocations)
plot(years20112020,allocations20112020,ylim=c(0,10),xlim=c(2011,2022))
lines(abline(linear2011regression)) 
lines(abline,h =2020)
summary(linear2011regression)

Allocations[(Allocations[["Name"]]=="New Zealand Steel Development Limited"),c("Year","Allocation")]

# check Industry sector emissions from GHG Inventory
str(crfsummarydatasector[["Industry"]])
num [1:31] 3580 3729 3374 3213 3083 ... 
# check last 6 years of Industry emissions from NZ GHG inventory stated in Kilotonnes
tail(crfsummarydatasector[["Industry"]]) 
[1] 5137.323 4883.073 4928.440 4825.074 4861.046 4618.354

crfsummarydatasector[["Year"]] 
[1] 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004
[16] 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
[31] 2020 

tail(crfsummarydatasector[["Year"]])
[1] 2015 2016 2017 2018 2019 2020

crfsummarydatasector[["Year"]][21:31]
[1] 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020

crfsummarydatasector[["Industry"]] 
 [1] 3579.924 3728.611 3374.093 3213.464 3082.804 3174.432 3365.549 3253.357
 [9] 3237.013 3412.940 3443.222 3558.481 3680.456 3916.535 3952.997 4061.648
[17] 4171.177 4431.190 4322.440 4274.591 4591.133 4627.387 4703.190 4836.346
[25] 5006.981 5137.323 4883.073 4928.440 4825.074 4861.046 4618.354 

# check last 11 years of Industry emissions from inventory 2010 2020

crfsummarydatasector[["Industry"]][21:31]
  
# create vector that is industry emissions 11 years to 2020 restated in million tonnes 
IndustryGHG <- crfsummarydatasector[["Industry"]][21:31]/10^3

IndustryGHG 
[1] 4.591133 4.627387 4.703190 4.836346 5.006981 5.137323 4.883073 4.928440
 [9] 4.825074 4.861046 4.618354

# what were actual emissions from 2009 to 2020? 
sum(IndustryGHG)
[1] 53.01835 

# create vector that is the '1 for 2' discount given for surrendering units emissions; 1 NZU for 2 tonnes GHG

# create variable that is the 'two-for-one' discount - 2 tonnes = 1 unit to surrender  
https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/participating-in-the-ets/surrendering-units/

# "Phase out of the '1 for 2' surrender obligation, Prior to 2017, non-forestry participants had to surrender one eligible unit for every two tonnes of emissions they reported in their annual emissions return, effectively a 50% surrender obligation. 2017 - 1 unit for each 1.5 whole tonnes of emissions 2018 - 1 unit for each 1.2 whole tonnes of emissions 2019 - 1 unit for each 1 whole tonne of emissions"
# 2010 was a half year for ETS so the 'discount' for calculating emissions liability under the ETS is .5 x .5 = 0.25

unitdiscount <- c(0.25,0.5,0.5,0.5,0.5,0.5,0.5,0.67,0.83,1,1)
str(unitdiscount)
num [1:11] 0.25 0.5 0.5 0.5 0.5 0.5 0.5 0.67 0.83 1 1


# add unit discount variable to the data frame
annualallocations[["unitdiscount"]] <- unitdiscount

# add Industry sector emissions to data frame 
annualallocations[["IndustryGHG"]] <- IndustryGHG 

str(annualallocations)
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
svg(filename ="annualallocations_720-540.svg", width = 8, height = 6, pointsize = 14, onefile = FALSE, family = "sans", bg = "white")

png("Industry-Emissions-2010-2020-560by420-v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table1,las=1,space=c(0.1,1.1), beside = TRUE, col=c("brown3")) 
title(cex.main=1.4,main="Industry Sector Emissions 2010 2020",ylab="tonnes GHG CO2-e (millions)")
mtext(side=1,line=2.5,cex=1,expression(paste("Source: MfE GHG Inventory 2020")))
mtext(side=3,line=0,cex=1,expression(paste("Emissions from the Industrial sector were 53 million tonnes from 2010 to 2020")))
#legend("topleft", inset=c(0.0,0.0) ,bty="n",c("Free Allocation of NZUs","Actual Industry Emissions"),fill=c("brown3","#ED731D"))
dev.off() 

plot(annualallocations,type='l')  

sum(annualallocations[["Allocation"]]) 
1] 55.00191 
annualallocations[["Allocation"]]
[1] 1.763232 3.461556 3.451147 4.815810 4.484100 4.369366 4.307558 5.606415 6.744229 8.282779 7.715722
# create table of emission units allocated to industry 
table2 <- matrix(c( 1.763232, 3.461556, 3.451147, 4.815810, 4.484100, 4.369366, 4.307558, 5.606415, 6.744229, 8.282779, 7.715722),nrow = 1, ncol=11, byrow=TRUE, dimnames = list(c("NZUs"),
c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")))
# create barplot of allocated units
png("Industry-Allocation-2010-2020-560by420-v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(4, 4, 4, 1)+0.1)
barplot(table2,las=1,space=c(0.1,1.1), beside = TRUE, col=c("brown3")) 
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
mtext(side=1,line=2.5,cex=1,expression(paste("Source: MfE GHG Inventory 1990 2018, EPA Industrial allocation decisions")))
#mtext(side=3,line=0,cex=0.9,expression(paste("2010 to 2018 industry emissions 44 million tonnes - free units allocated 39 million")))
legend("topleft", inset=c(0.0,0.0) ,bty="n",c("Allocation of units to industry 39 million tonnes","Actual industry emissions 44 million tonnes"),fill=c("brown3","#ED731D"))
dev.off()

  
# create variable that is the emissions permitted by the allocation of emission units in mts i.e. 2 tonnes for 1 NZU
annualallocations[["Permitted"]] <- annualallocations[["Allocation"]] / annualallocations[["unitdiscount"]] 

# check dataframe
str(annualallocations) 
'data.frame':	11 obs. of  5 variables:
 $ Year        : num  2010 2011 2012 2013 2014 ...
 $ Allocation  : num  1.76 3.46 3.45 4.82 4.48 ...
 $ unitdiscount: num  0.25 0.5 0.5 0.5 0.5 0.5 0.5 0.67 0.83 1 ...
 $ IndustryGHG : num  4.59 4.63 4.7 4.84 5.01 ...
 $ Permitted   : num  7.05 6.92 6.9 9.63 8.97 ... 
 
annualallocations[["Allocation"]] 
[1] 1.763232 3.461556 3.451147 4.815810 4.484100 4.369366 4.307558 5.606415 6.744229 8.282779 7.715722
sum(annualallocations[["Allocation"]]) 
[1] 55.00191 
# What are the Industry sector emissions ?
IndustryGHG
[1] 4.591133 4.627387 4.703190 4.836346 5.006981 5.137323 4.883073 4.928440 4.825074 4.861046 4.618354 
sum(IndustryGHG) 
[1] 53.01835 
# check the actual emissions permitted by the free units after factoring in the two for one discount 
annualallocations[["Permitted"]]
 [1] 7.052928 6.923112 6.902294 9.631620 8.968200 8.738732 8.615116 8.367784 8.125577 8.282779 7.715722
# what is the total emissions 2010 to 2020 permitted by the units? 
sum(annualallocations[["Permitted"]]) 
[1] 89.32386 

# create table that is industrial free allocation NZUs, actual emissions and emissions permitted by NZUs 2010 2018
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
legend("topleft", inset=c(0.0,0.0) ,bty="n",c("Allocation of units to industry 55mt","Actual industry emissions 53mt","Emissions permited by allocation 89mt"),fill=c("brown3","#ED731D","#F0E442"))
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
str(annualallocations) 
'data.frame':	11 obs. of  5 variables:
 $ Year        : num  2010 2011 2012 2013 2014 ...
 $ Allocation  : num  1.76 3.46 3.45 4.82 4.48 ...
 $ unitdiscount: num  0.25 0.5 0.5 0.5 0.5 0.5 0.5 0.67 0.83 1 ...
 $ IndustryGHG : num  4.59 4.63 4.7 4.84 5.01 ...
 $ Permitted   : num  7.05 6.92 6.9 9.63 8.97 ..  
summary(annualallocations)
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

plot(annualallocations[["Year"]],annualallocations[["Permitted"]],ylim=c(0,10), xlim=c(2010,2020),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0, lwd = 1, at = c(2010:2020), labels = c(2010:2020), tick = TRUE)
axis(side=2, tck=0.01, las=2, line = NA,lwd = 1, at = c(0:8), labels = c(0:8),tick = TRUE)
axis(side=4, tck=0.01, at = c(0:8), labels = FALSE, tick = TRUE)
box(lwd=1)
lines(annualallocations[["Year"]],annualallocations[["Permitted"]],col="#7570b3",lwd=1)
points(annualallocations[["Year"]],annualallocations[["Permitted"]],col="#7570b3",pch=16)

lines(annualallocations[["Year"]],annualallocations[["Allocation"]],col="#1b9e77",lwd=1)
points(annualallocations[["Year"]],annualallocations[["Allocation"]],col="#1b9e77",cex=1,pch=15)
lines(annualallocations[["Year"]],annualallocations[["IndustryGHG"]],col="#d95f02",lwd=1)
points(annualallocations[["Year"]],annualallocations[["IndustryGHG"]],col="#d95f02",cex=1,pch=14)

lines(annualallocations[["Year"]],annualallocations[["Industry"]]/1000,col="#7570b3",lwd=1)
#points(annualallocations[["Year"]],annualallocations[["Industrial"]]/1000,col="#7570b3",cex=1,pch=9)
lines(annualallocations[["Years"]],annualallocations[["Waste"]]/1000,col="#e7298a",lwd=1,lty=2)
#points(annualallocations[["Years"]],annualallocations[["Waste"]]/1000,col="#e7298a",cex=1,pch=10)
lines(annualallocations[["Years"]],annualallocations[["LULUCF"]]/1000,col="#66a61e",lwd=1)
points(annualallocations[["Years"]],annualallocations[["LULUCF"]]/1000,col="#66a61e",cex=1,pch=17)
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
# "Phase out of the '1 for 2' surrender obligation, Prior to 2017, non-forestry participants had to surrender one eligible unit for every two tonnes of emissions they reported in their annual emissions return, effectively a 50% surrender obligation. 2017 - surrender 1 unit for 1.5 whole tonnes of emissions 2018 - surrender 1 unit for 1.2 whole tonnes of emissions, 2019 - surrender 1 unit for 1 whole tonne of emissions 

unitdiscount <- c(0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.67,0.83,1)

# create variable that is the emissions permitted by each years allocation of free units in mts i.e. 2 tonnes for 1 NZU
AllocationGHG <- annualallocations[["Allocation"]]/unitdiscount

cbind(annualallocations,IndustryGHG,unitdiscount,AllocationGHG) 

IndustryAllocationGHG20102019 <- cbind(annualallocations,IndustryGHG,unitdiscount,AllocationGHG)

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
