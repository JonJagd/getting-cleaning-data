library(httr)
# Week 2 Quiz
# 1

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "cba762d9d7c32d921a5a",
                   secret = "e10692ebec48ce4bf70cb887f06c80a332c64e2b")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
content(req)

# OR:
req <- with_config(gtoken, GET("https://api.github.com/users/jtleek/repos"))
stop_for_status(req)
content(req)

# Finder svaret på spørgsmål #1 i quizzen
library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
subset(jsonData, full_name=="jtleek/datasharing",select = (created_at))
#2013-11-07T13:25:07Z


# Week 2 Quiz
# 2
acs = read.table("./data/getdata-data-ss06pid.csv", header = TRUE, sep = ",")
#acsDataTable = data.table(acs)
head(acs)
install.packages("sqldf")
library("sqldf")
sqldf("select pwgtp1 from acs where AGEP < 50")
# Week 2 Quiz
# 3
sqldf("select distinct AGEP from acs") #91

# Week 2 Quiz
# 4
con = url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode = readLines(con)
close(con)

nchar(htmlCode[c(10,20,30,100)])
# [1] 45 31  7 25


# Week 2 Quiz
# 5
#install.packages("readr")
#library(readr)
x <- read.fwf(
        file="./data/getdata-wksst8110.for",
        skip=4,
        widths=c(12, 7, 4, 9, 4, 9, 4, 9, 4))
head(x)
class(x)
sum(x$V4)
#[1] 32426.7
