if (!file.exists("data")) {
        dir.create("data")
}

# Week 1 Quiz

# 1.
library(data.table)
communityData = read.table("./data/getdata-data-ss06hid.csv", header = TRUE, sep = ",")
communityDataTable = data.table(communityData)
head(communityDataTable)

communityDataTable[communityDataTable$VAL==24, .N, by=VAL]
#    VAL  N
#1:  24 53

# anden måde
communityDataTable[, table(VAL)]
# VAL
# 1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24 
# 75  42  33  30  26  29  23  70  99 119 152 199 233 495 483 486 357 502 232 312 164 159  47  53 


# 3.
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile="./data/getdata-data-DATA.gov_NGAP.xlsx", mode='wb') # mode wb er vigtigt
dateDownloaded <- date()

install.packages("xlsx")
install.packages("rJava")
library(rJava)
library(xlsx)

rowIndex <- 18:23
colIndex <- 7:15
dat = read.xlsx("./data/getdata-data-DATA.gov_NGAP.xlsx", rowIndex = rowIndex, colIndex = colIndex, sheetIndex = 1)
sum(dat$Zip*dat$Ext,na.rm=T)
# [1] 36534720

# 4. 
install.packages("XML")
library(XML)
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileUrl, useInternalNodes = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
zipCodes = data.table(xpathSApply(rootNode, "//zipcode", xmlValue)) # det er måske ikke den helt "rigtige" måde men jeg fandt ikke et xPath-udtryk der kunne give et count
zipCodes[zipCodes$V1=='21231', .N, by=V1] 

# 5.
fileUrl5 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
destfile="./data/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl5, destfile="./data/getdata%2Fdata%2Fss06pid.csv")
dateDownloaded <- date()
DT <- fread(destfile)

# Herunder måler vi performance (kørselstider)
ptm <- proc.time()
rowMeans(DT)[DT$SEX==1];rowMeans(DT)[DT$SEX==2]
proc.time() - ptm

ptm <- proc.time()
tapply(DT$pwgtp15,DT$SEX,mean)
proc.time() - ptm

ptm <- proc.time()
DT[,mean(pwgtp15),by=SEX]
proc.time() - ptm

ptm <- proc.time()
mean(DT$pwgtp15,by=DT$SEX)
proc.time() - ptm

ptm <- proc.time()
mean(DT[DT$pwgtp15==1,]$pwgtp15);mean(DT[DT$SEX==2,]$pwgtp15)
proc.time() - ptm

ptm <- proc.time()
sapply(split(DT$pwgtp15,DT$SEX),mean)
proc.time() - ptm
