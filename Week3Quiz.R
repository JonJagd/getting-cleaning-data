# 1. 
#The American Community Survey distributes downloadable data about United States communities. 
#Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:

# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

# and load the data into R. The code book, describing the variable names is here:
        
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Create a logical vector that identifies the households on 
# greater than 10 acres 
# who sold more than $10,000 worth of agriculture products. 
# Assign that logical vector to the variable agricultureLogical. 
# Apply the which() function like this to identify the rows of the data 
# frame where the logical vector is TRUE.

# which(agricultureLogical)

# What are the first 3 values that result?

# 125, 238,262

# 236, 238, 262

# 59, 460, 474

# 403, 756, 798

if(!file.exists("./data")){dir.create("./data")}
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,destfile="./data/housing_idaho.csv", mode = "wb")
housingIdaho = read.csv("./data/housing_idaho.csv")
head(housingIdaho)
# følgende linje giver svaret
which(housingIdaho$ACR == "3" & housingIdaho$AGS == "6") # Give the TRUE indices of a logical object, allowing for array indices.
# [1]  125  238  262

# 2. 
# Using the jpeg package read in the following picture of your instructor into R

# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg

# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
# (some Linux systems may produce an answer 638 different for the 30th quantile)

# 10904118 -594524

# -15259150 -10575416

# -16776430 -15390165

# -10904118 -10575416

install.packages("jpeg")
library(jpeg)
source 
summary(readJPEG("./data/getdata-jeff.jpg", native = TRUE))
quantile(readJPEG("./data/getdata-jeff.jpg", native = TRUE), probs=c(0.3,0.80))
# 30%       80% 
# -15259150 -10575416 

# 3. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
        
#        https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Load the educational data from this data set:
        
#        https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

# Match the data based on the country shortcode. How many of the IDs match? 
# Sort the data frame in descending order by GDP rank (so United States is last). 
# What is the 13th country in the resulting data frame?

# Original data sources:
        
#        http://data.worldbank.org/data-catalog/GDP-ranking-table

#        http://data.worldbank.org/data-catalog/ed-stats

# 189 matches, 13th country is St. Kitts and Nevis

# 190 matches, 13th country is St. Kitts and Nevis

# 190 matches, 13th country is Spain

# 234 matches, 13th country is Spain

# 234 matches, 13th country is St. Kitts and Nevis

# 189 matches, 13th country is Spain

if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
fileUrl2 = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl1,destfile="./data/gross_domestic_product.csv", mode = "wb")
download.file(fileUrl2,destfile="./data/educational.csv", mode = "wb")

gdp <- read.csv("./data/gross_domestic_product.csv", skip = 4, nrows = 215)
gdp <- gdp[gdp$X != "" & !is.na(gdp$X.1),] # fjerner rækker uden country code og uden ranking

education <- read.csv("./data/educational.csv")

mergedData = merge(gdp,education,by.x = "X",by.y="CountryCode",all = FALSE) # merger de to data sets
mergedData[, c("X", "X.1", "X.3", "Short.Name")]
sum(!is.na(unique(mergedData$X)))
# [1] 189


library(dplyr)
mergedData$GDPRank <- as.integer(mergedData$X.1)

#mergedData <- arrange(mergedData, desc(mergedData$X.1))

mergedData[, c("X", "X.1", "GDPRank", "X.3")] # 

testingSort <- mergedData[order(-mergedData$GDPRank), ]
testingSort[13, c("X", "X.1", "GDPRank", "X.3")]
#      X X.1 GDPRank                 X.3
# 93 KNA 178     178 St. Kitts and Nevis


# 4. What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?

# 23, 45

# 30, 37

# 23.966667, 30.91304

# 133.72973, 32.96667

# 23, 30

# 32.96667, 91.91304


tapply(mergedData$GDPRank,mergedData$Income.Group,mean) # for hver Income.Group laver den en mean af GDPRank-kolonnen

#             High income: nonOECD    High income: OECD
#          NA             91.91304             32.96667


# 5. Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries
# are Lower middle income but among the 38 nations with highest GDP?

# 5

# 1

# 0

# 13


library(Hmisc)
mergedData$GDPRankQuantile = cut2(mergedData$GDPRank,g=5) # vi opretter en variabel der cutter/grupperer datasættet i 5 kvartiler baseret på deres GDP-rank
table(mergedData$GDPRankQuantile)

mergedData[mergedData$GDPRank == 38, c("X", "X.1", "GDPRank", "X.3", "GDPRankQuantile", "Income.Group")]

table(mergedData$GDPRankQuantile, mergedData$Income.Group)

#             High income: nonOECD High income: OECD Low income Lower middle income Upper middle income
#[  1, 39)  0                    4                18          0                   5                  11
#[ 39, 77)  0                    5                10          1                  13                   9
#[ 77,115)  0                    8                 1          9                  12                   8
#[115,154)  0                    5                 1         16                   8                   8
#[154,190]  0                    1                 0         11                  16                   9