
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
lines(Annualallocations[["Year"]],Annualallocations[["Allocation"]],col="#E7298A",lwd=1,lty=1) # shocking pink/Cerise
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
legend("right",bty="n",c("Upper limit 95%","Linear trend","Lower limit 95%"),col="#E7298A",lwd=c(1,2,1),lty=2)
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
