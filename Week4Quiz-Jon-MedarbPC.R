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