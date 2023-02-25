# load applications
library(readxl)
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
# make a csv file of allocations data
write.table(Allocations, file = "Allocations.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE) 
# read in csv file if I need to later
#Allocations<-read.csv("Allocations.csv")

# How many emissions units have been given away from 2010 to 2020?
sum(Allocations[["Allocation"]])
[1] 55001914 
# 55 million

# How many emission units were allocated for each year and save as a dataframe
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

------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------
# download detailed emissions by category from Ministry for the Environment

download.file("https://environment.govt.nz/assets/publications/GhG-Inventory/Time-series-emissions-data-by-category.xlsx","Time-series-emissions-data-by-category-2020.xlsx")
trying URL 'https://environment.govt.nz/assets/publications/GhG-Inventory/Time-series-emissions-data-by-category.xlsx'
Content type 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' length 1567250 bytes (1.5 MB)
==================================================
downloaded 1.5 MB

# check names of worksheets
excel_sheets("Time-series-emissions-data-by-category-2020.xlsx")
[1] "All gases" "CO2"       "CH4"       "N2O"       "HFCs"      "PFCs"     
[7] "SF6"  

# read in inventory electricity generation emissions data byselecting electricity row 17 and row 18 "1.A.1.a  Public Electricity and Heat Production]" the row above 
emissions <- read_excel("Time-series-emissions-data-by-category-2020.xlsx", sheet = "All gases",skip=10,range ="C11:AG17",col_types = c("guess")) 

str(emissions) 
tibble [6 × 31] (S3: tbl_df/tbl/data.frame)
 $ 1990: num [1:6] 43968 65197 23878 22449 5987 ....  
class(emissions) 
[1] "tbl_df"     "tbl"        "data.frame" 
dim(emissions) 
[1]  6 31 
head(emissions,2)
# A tibble: 2 × 31
  `1990` `1991` `1992` `1993` `1994` `1995` `1996` `1997` `1998` `1999` `2000`
   <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
1 43968. 42899. 44288. 43353. 44810. 46567. 49207. 51404. 48563. 47557. 48580.
2 65197. 66176. 67332. 67194. 68444. 69013. 71191. 74027. 71822. 73576. 75515.
# … with 20 more variables: `2001` <dbl>, `2002` <dbl>, `2003` <dbl>,
#   `2004` <dbl>, `2005` <dbl>, `2006` <dbl>, `2007` <dbl>, `2008` <dbl>,
#   `2009` <dbl>, `2010` <dbl>, `2011` <dbl>, `2012` <dbl>, `2013` <dbl>,
#   `2014` <dbl>, `2015` <dbl>, `2016` <dbl>, `2017` <dbl>, `2018` <dbl>,
#   `2019` <dbl>, `2020` <dbl>
# electricity generation emissions are 6 row
emissions[6,]
A tibble: 1 × 31
  `1990` `1991` `1992` `1993` `1994` `1995` `1996` `1997` `1998` `1999` `2000`
   <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
1  3490.  3917.  5035.  4136.  3305.  3032.  4009.  5936.  4407.  5677.  5351. 


# A tibble: 1 × 31
emissions <- as.numeric(emissions[6,])
# convert from kts to million tonnes
emissions <- emissions/10^3
str(emissions) 
 num [1:31] 3.49 3.92 5.03 4.14 3.3 ...
# create year vector 
year <- c(1990:2020)

# create dataframe
electricityemissions2020 <- as.data.frame(cbind(year,emissions)) 

#check data frame
str(electricityemissions2020) 
'data.frame':	31 obs. of  2 variables:
 $ year     : num  1990 1991 1992 1993 1994 ...
 $ emissions: num  3.49 3.92 5.03 4.14 3.3 ... 

# save data
write.table(electricityemissions2020, file = "electricityemissions2020.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE)
# look at data for 2010 to 2020
electricityemissions2020[21:31,] 
  year emissions
21 2010  5.565628
22 2011  5.046879
23 2012  6.454129
24 2013  5.207118
25 2014  4.245071
26 2015  4.039734
27 2016  3.060460
28 2017  3.625903
29 2018  3.481471
30 2019  4.216066
31 2020  4.617553 

# read in annual allocations and e footprint data
Annualallocations <- read.csv("Annualallocations.csv")
# add electricity generation emissions 2010 to 2020 to allocations
Annualallocations1 <- cbind(Annualallocations, emissions[21:31])
str(Annualallocations1)
'data.frame':	11 obs. of  3 variables:
 $ Year            : int  2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 ...
 $ Allocation      : num  1.76 3.46 3.45 4.82 4.48 ...
 $ emissions[21:31]: num  5.57 5.05 6.45 5.21 4.25 ...
names(Annualallocations1[3]) <- c("ElectricityGHG")
names(Annualallocations1) <- c("Year", "Allocation","ElectricityGHG")
names(Annualallocations1) <- c("Year", "Allocation", "IndustryGHG", "unitdiscount", "AllocatedGHG", "ElectricityGHG")

'data.frame':	11 obs. of  6 variables:
 $ Year          : int  2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 ...
 $ Allocation    : num  1.76 3.46 3.45 4.82 4.48 ...
 $ IndustryGHG   : num  4.59 4.63 4.7 4.84 5.01 ...
 $ unitdiscount  : num  0.25 0.5 0.5 0.5 0.5 0.5 0.5 0.67 0.83 1 ...
 $ AllocatedGHG  : num  7.05 6.92 6.9 9.63 8.97 ...
 $ ElectricityGHG: num  5566 5047 6454 5207 4245 ... 
