
# line chart of units allocated to industry with linear regression
linearregression <- lm(Allocation/10^6 ~ Year, Annualallocations)

summary(linearregression)

Call:
lm(formula = Allocation/10^6 ~ Year, data = Annualallocations)

Residuals:
     Min       1Q   Median       3Q      Max 
-1.54311 -0.68289 -0.01754  0.70723  1.83273 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -827.49072  143.95512  -5.748 0.000129 ***
Year           0.41305    0.07141   5.784 0.000122 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.9633 on 11 degrees of freedom
Multiple R-squared:  0.7526,	Adjusted R-squared:  0.7301 
F-statistic: 33.46 on 1 and 11 DF,  p-value: 0.000122


# The industrial allocations have increased by 0.4 million units a year

predict(linearregression,interval="confidence",level=0.95)
confidencelimits <- predict(linearregression,interval="confidence",level=0.95)
confidencelimitsdata <- data.frame(confidencelimits)
confidencelimitsdata[["Year"]] <- 2010:2022
confidencelimitsdata
        fit      lwr      upr Year
1  2.732632 1.621315 3.843949 2010
2  3.145678 2.164190 4.127167 2011
3  3.558725 2.697902 4.419547 2012
4  3.971771 3.218040 4.725503 2013
5  4.384818 3.718028 5.051608 2014
6  4.797864 4.189171 5.406558 2015
7  5.210911 4.622857 5.798964 2016
8  5.623957 5.015264 6.232651 2017
9  6.037004 5.370213 6.703794 2018
10 6.450050 5.696318 7.203782 2019
11 6.863096 6.002274 7.723919 2020
12 7.276143 6.294654 8.257631 2021
13 7.689189 6.577872 8.800506 2022

svg(filename ="Industrial-Allocation-line-2010-2022-720-540.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white") 
png("Industrial-Allocation-line-2010-2022-560by420.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(2.7,2.7,1,1)+0.1)
plot(Annualallocations[["Year"]],Annualallocations[["Allocation"]]/10^6,ylim=c(0,10), xlim=c(2010,2022),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0, lwd = 1, at = c(2010:2022), labels = c(2010:2022), tick = TRUE)
axis(side=2, tck=0.01, las=2, line = NA,lwd = 1, at = c(0:8), labels = c(0:8),tick = TRUE)
axis(side=4, tck=0.01, at = c(0:8), labels = FALSE, tick = TRUE)
box(lwd=1)
lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]]/10^6,col="#E7298A",lwd=1,lty=1) # shocking pink/Cerise
points(Annualallocations[["Year"]],Annualallocations[["Allocation"]]/10^6,col="#E7298A",pch=19)
mtext(side=1,line=-1.5,cex=1,"Source: EPA industrial allocation decisions")
mtext(side=3,cex=1.5, line=-2.2,expression(paste("Emission units allocated to industry 2010 to 2022")) )
mtext(side=2,cex=1, line=-1.5,expression(paste("million units")))
mtext(side=3,line=-3.5,cex=1,expression(paste("From 2010 to 2022 67 million free emission units were given to industries")))
#mtext(side=3,line=-5,cex=1,expression(paste("An increasing linear trend of 0.4 million units per year")))
mtext(side=4,cex=0.75, line=0.05,R.version.string)
dev.off()

svg(filename ="Industrial-Allocation-line-2010-2022-720-540v1.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white") 
#png("Industrial-Allocation-line-2010-2022-560by420v1.png", bg="white", width=560, height=420,pointsize = 12)
par(mar=c(2.7,2.7,1,1)+0.1)
plot(Annualallocations[["Year"]],Annualallocations[["Allocation"]]/10^6,ylim=c(0,10), xlim=c(2010,2022),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0, lwd = 1, at = c(2010:2022), labels = c(2010:2022), tick = TRUE)
axis(side=2, tck=0.01, las=2, line = NA,lwd = 1, at = c(0:8), labels = c(0:8),tick = TRUE)
axis(side=4, tck=0.01, at = c(0:8), labels = FALSE, tick = TRUE)
box(lwd=1)
lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]]/10^6,col="#E7298A",lwd=1,lty=1) # shocking pink/Cerise
points(Annualallocations[["Year"]],Annualallocations[["Allocation"]]/10^6,col="#E7298A",pch=19)
mtext(side=1,line=-1.5,cex=1,"Source: EPA industrial allocation decisions")
mtext(side=3,cex=1.5, line=-2.2,expression(paste("Emission units allocated to industry 2010 to 2022")) )
mtext(side=2,cex=1, line=-1.5,expression(paste("million units")))
mtext(side=3,line=-3.5,cex=1,expression(paste("From 2010 to 2022 67 million free emission units were given to industries")))
mtext(side=3,line=-5,cex=1,expression(paste("An increasing linear trend of 0.4 million units per year")))
mtext(side=4,cex=0.75, line=0.05,R.version.string)
abline(linearregression,col="#E7298A",lty=2,lwd=2)
lines(confidencelimitsdata[["Year"]],confidencelimitsdata[["lwr"]],col="#E7298A",lwd=1,lty=2) # shocking pink
lines(confidencelimitsdata[["Year"]],confidencelimitsdata[["upr"]],col="#E7298A",lwd=1,lty=2) # shocking pink
legend(2010,8,bty="n",c("Upper limit 95%","Linear trend","Lower limit 95%"),col="#E7298A",lwd=c(1,2,1),lty=2)
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
