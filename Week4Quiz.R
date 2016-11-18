# 1. 
# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
        
#        https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

# and load the data into R. The code book, describing the variable names is here:
        
#        https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

# Apply ?strsplit() to split all the names of the data frame on the characters "wgtp". 

# What is the value of the 123 element of the resulting list?

# "" "15"

# "w" "15"

# "wgt" "15"

# "wgtp" "15"
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,destfile="./data/housing_idaho.csv", mode = "wb")
housingIdaho = read.csv("./data/housing_idaho.csv")
head(housingIdaho)
strsplit(names(housingIdaho), "wgtp")
# [[123]]
# [1] ""   "15"

# 2. 
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
        
#        https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?

# Original data sources:
        
#        http://data.worldbank.org/data-catalog/GDP-ranking-table

#379596.5

#381668.9

#387854.4

#377652.4

# Jeg downloader og læser filen
fileUrl1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl1,destfile="./data/gross_domestic_product.csv", mode = "wb")
gdp <- read.csv("./data/gross_domestic_product.csv", skip = 4, nrows = 215)
names(gdp)
gdp <- gdp[gdp$X != "" & !is.na(gdp$X.1),] # fjerner rækker uden country code og uden ranking


mean(as.integer(gsub(",","",gdp$X.4)))
# [1] 377652.4

# 3. 
# In the data set from Question 2 what is a regular expression that would allow you 
# to count the number of countries whose name begins with "United"? 
# Assume that the variable with the country names in it is named countryNames. How many countries begin with United?

# grep("^United",countryNames), 4

# grep("^United",countryNames), 3

# grep("United$",countryNames), 3

# grep("*United",countryNames), 2


countryNames <- gdp$X.3

length(grep("^United", countryNames))
# [1] 3

#4. 
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
        
#        https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Load the educational data from this data set:
        
#        https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

# Match the data based on the country shortcode. Of the countries for which the end of the fiscal
# year is available, how many end in June?

# Original data sources:
        
#        http://data.worldbank.org/data-catalog/GDP-ranking-table

# http://data.worldbank.org/data-catalog/ed-stats

# 7

# 8

# 13

# 16

education <- read.csv("./data/educational.csv")
mergedData = merge(gdp,education,by.x = "X",by.y="CountryCode",all = FALSE) # merger de to data sets
length(grep("^Fiscal year end: June", mergedData$Special.Notes)) # finder antallet af de rækker/pladser, hvor feltet Special Notes starter med "Fiscal year end: June"
# 13

# 5. 
# You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices for publicly traded companies on the NASDAQ and NYSE. 
# Use the following code to download data on Amazon's stock price and get the times the data was sampled.

install.packages("quantmod")
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

head(sampleTimes)
# How many values were collected in 2012? How many values were collected on Mondays in 2012?

# 250, 47

# 365, 52

# 252, 50

# 251,51

length(grep("^2012", sampleTimes))
# [1] 250

# denne funktion udvælger alle værdier for datoer i 2012, ændrer det til en dato, og udvælger alle mandage
length(grep("mandag", weekdays(as.Date(grep("^2012", sampleTimes, value = TRUE)))))
# [1] 47
