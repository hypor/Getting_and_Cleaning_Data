setwd("c:/JHU/Getting_and_Cleaning_Data")

######load libraries######
#install.packages("RCurl")
#install.packages("xlsx")
#install.packages("rJava")
#install.packages("XML")
#install.packages("data.table")
library(RCurl)
library(rJava)
library(xlsx)
library(XML)
library(data.table)

######Error using lecture note commands####
#Set global instructions for RCurl to turn off SSL authentication#
options(RCurlOptions = list(cainfo=system.file("CurlSSL","cacert.pem",package="RCurl")))

######Question 1 & 2 - American Community Survey, how many properties worth > 1mio#####
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
ACSurvey <- read.csv(textConnection(getURL(fileURL)))
write.csv(ACSurvey,file= "ACSurvey.csv")

#explore data
str(ACSurvey)
table(ACSurvey$VAL)

#read in data
ACSData <- read.table("ACSurvey.csv", sep=",", header=TRUE)

#tidy data violation
ACSurvey$FES

######Question 3 - Excel with Nat Gas Acquisition Prog########

#read rows 18-23, columns 7-15 into R
rowIndex <- 18:23
colIndex <- 7:15
dat <- read.xlsx("./data/getdata-data-DATA.gov_NGAP.xlsx",sheetIndex=1, colIndex=colIndex, rowIndex=rowIndex)
sum(dat$Zip*dat$Ext,na.rm=T)

######Question 4 - Baltimore Restaurant XML#######

#lecture commands have problem again, let's try using RCurl since its https
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
fetchXML <- getURL(fileURL)
doc <- xmlParse(fetchXML)

#exploring XML data
rootNode <-xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode[[1]]
xpathSApply(rootNode,"//zipcode",xmlValue)

#extract content by attributes and store as variable
zipcodes <- xpathSApply(doc,"//zipcode",xmlValue)
table(zipcodes)

######Question 5 - American Community Survey 2006 microdata########
#practicing fread
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
DT = fread(fileURL)


#fastest way to calculate average value of pwgtp15 broken down by sex
DT[,mean(pwgtp15),by=SEX]
