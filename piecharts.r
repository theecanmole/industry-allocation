Applicants <- read.csv( file = "Applicants.csv")

str(Applicants)
'data.frame':	162 obs. of  2 variables:
 $ Name      : chr  "New Zealand Steel Development Limited" "New Zealand Aluminium Smelters Limited" "Methanex New Zealand Ltd" "Fletcher Concrete and Infrastructure Limited" ...
 $ Allocation: int  14070207 10407692 7897573 4353470 3865433 2306629 1879433 1599929 1385445 1222905 ... 
 
quantile(Applicants[["Allocation"]],0.75) 
75% 41716 

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

slices <-c(slicestopten, therest) 
slices 
[1] 14.070207 10.407692  7.897573  4.353470  3.865433  2.306629  1.879433
 [8]  1.599929  1.385445  1.222905  6.013198
sum(slices)
[1] 55.00191 

total <-sum(Applicants[["Allocation"]]/10^6)

# What percent of units went to the bottom 150 companies?
therest / total
6.013198 / 55.00191 * 100
[1] 10.93271
# What percent of units went to top ten industries
sumslicestopten / total * 100 
[1] 89.06729 

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
 [1] "NZ Steel 26%"           "NZ Aluminium 19%"       "Methanex 14%"          
 [4] "Fletcher 8%"            "Oji Fibre 7%"           "Ballance 4%"           
 [7] "Norske skog 3%"         "Pan Pac Forest 3%"      "Graymont 3%"           
[10] "Winstone 2%"            "The rest 152 firms 11%" 
# select some colours for charts
palettepair11<-brewer.pal(11, "Paired")
palettepair11 
[1] "#A6CEE3" "#1F78B4" "#B2DF8A" "#33A02C" "#FB9A99" "#E31A1C" "#FDBF6F" "#FF7F00" "#CAB2D6" "#6A3D9A" "#FFFF99"
pair11 <- c(rep(1, 11))
pair11
[1] 1 1 1 1 1 1 1 1 1 1 1
names(pair11)<- palettepair11
pair11 
#A6CEE3 #1F78B4 #B2DF8A #33A02C #FB9A99 #E31A1C #FDBF6F #FF7F00 #CAB2D6 #6A3D9A 
      1       1       1       1       1       1       1       1       1       1 
#FFFF99 
      1
pie(pair11, col= palettepair11)

png("Allocations-pie-percent-2010-2020-720.png", width=565, height=565, pointsize = 12)
#png("Allocations-pie-percent-pie-2010-2020-720.png", width=720, height=720, pointsize = 14)
#svg(filename ="Allocations-pie-precent-2010-2020_720-720.svg", width = 8, height = 8, pointsize = 14, onefile = FALSE, family = "sans", bg = "white")
pie(slices,radius=0.9,clockwise =TRUE,labels = labels, col=palettepair11, main=expression(paste("Recipients of Industrial Allocation 2010 to 2020")))
mtext(side=1,cex=0.9,line=1.9,"Data: https://www.epa.govt.nz/industry-areas/emissions-trading-scheme/industrial-allocations/decisions/")
mtext(side=1,cex=1,line=0.5,"Of 55 million emission units allocated to industry between 2010 and 2020\n89% went to ten companies")
dev.off()

===================================================

pie(Activities[["Allocation"]],radius=0.9,clockwise =TRUE,labels = Activities[["Activities"]], col=palettepair11, main=expression(paste("Activities of Industrial Allocation 2010 to 2020 by percent"))) 

Activities[["Allocation"]][1:10]
[1] 14166823 10407692  7897573  5383349  4808292  2306629  1879433  1853810
 [9]  1493104  1112834
Activities[["Activity"]][1:10]
[1] "Iron and steel manufacturing from iron sand"
 [2] "Aluminium smelting"                         
 [3] "Methanol"                                   
 [4] "Cementitious products"                      
 [5] "Market pulp"                                
 [6] "Carbamide (urea)"                           
 [7] "Newsprint"                                  
 [8] "Packaging and industrial paper"             
 [9] "Burnt lime"                                 
[10] "Cartonboard"   

A1 <- Activities[["Allocation"]][1:10]/10^6
A1
[1] 14.166823 10.407692  7.897573  5.383349  4.808292  2.306629  1.879433
 [8]  1.853810  1.493104  1.112834
alabel <- c(Activities[["Activity"]][1:10])
alabel
[1] "Iron and steel manufacturing from iron sand"
 [2] "Aluminium smelting"                         
 [3] "Methanol"                                   
 [4] "Cementitious products"                      
 [5] "Market pulp"                                
 [6] "Carbamide (urea)"                           
 [7] "Newsprint"                                  
 [8] "Packaging and industrial paper"             
 [9] "Burnt lime"                                 
[10] "Cartonboard" 
str(alabel)
chr [1:10] "Iron and steel manufacturing from iron sand" ...

pie(A1,radius=0.9,clockwise =TRUE,labels = alabel, col=palettepair11, main=expression(paste("Activities of Industrial Allocation 2010 to 2020 by percent"))) 

total <- sum(Activities[["Allocation"]]) 
total
[1] 55001914
therest <- total - sum(Activities[["Allocation"]][1:10])
therest
therest
[1] 3692375
therest <- therest/10^6
A2 <-c(A1 ,therest)
A2
A2
 [1] 14.166823 10.407692  7.897573  5.383349  4.808292  2.306629  1.879433
 [8]  1.853810  1.493104  1.112834  3.692375
 
alabel <-c(alabel,"The Rest")
alabel
[1] "Iron and steel manufacturing from iron sand"
 [2] "Aluminium smelting"                         
 [3] "Methanol"                                   
 [4] "Cementitious products"                      
 [5] "Market pulp"                                
 [6] "Carbamide (urea)"                           
 [7] "Newsprint"                                  
 [8] "Packaging and industrial paper"             
 [9] "Burnt lime"                                 
[10] "Cartonboard"                                
[11] "The Rest"  
alabel[1]
[1] "Iron and steel manufacturing from iron sand" 
alabel[1] <-c("Steel smelting")
alabel[8] <-c("Paper")
alabel[4] <-c("Cement")

percent <- round(A2/sum(A2)*100)
alabel <- paste(alabel, percent) # add percents to labels
alabel <- paste(alabel,"%",sep="") # add "%" to labels
 
 
pie(A2,radius=0.9,clockwise =TRUE,labels = alabel, col=palettepair11, main=expression(paste("Activities of Industrial Allocation 2010 to 2020"))) 
