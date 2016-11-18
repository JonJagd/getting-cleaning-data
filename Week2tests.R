ucscDb <- dbConnect(MySQL(), user="genome",
                    host="genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb,"show databases;"); dbDisconnect(ucscDb);

head(result)

hg19 <- dbConnect(MySQL(), user="genome", db="hg19",
                    host="genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19) #list all tables in the database hg19
length(allTables)
allTables[1:5]
dbListFields(hg19,"affyU133Plus2") # list all the fields in that table
dbGetQuery(hg19, "select count(*) from affyU133Plus2") # simple query against the table
affyData <- dbReadTable(hg19, "affyU133Plus2") # get all data from the table
head(affyData)

query <- dbSendQuery(hg19, "select * from affyU133Plus2 where misMatches between 1 and 3") # dbSendQuery() is different from ...GetQuery in that the query is stored remotely on the server and can then be fetched

affyMis <- fetch(query); quantile(affyMis$misMatches)

affyMisSmall <- fetch(query,n=10); dbClearResult(query) # only top 10 (n) records and then the query is cleared at the server

affyMisSmall[1:5]

dim(affyMisSmall) # dim returnerer antal rækker og kolonner

dbDisconnect(hg19)

#HDF5
source("http://bioconductor.org/biocLite.R")
library(rhdf5)

created = h5createFile("example.h5")
created
created = h5createGroup("example.h5","foo")
created = h5createGroup("example.h5","baa")
created = h5createGroup("example.h5","foo/foobaa")
h5ls("example.h5")

A = matrix(1:10,nr=5,nc=2)
h5write(A, "example.h5", "foo/A")
B = array(seq(0.1,2.0,by=0.1),dim=c(5,2,2))
attr(B, "scale") <- "liter"
h5write(B, "example.h5","foo/foobaa/B")
h5ls("example.h5")

# web scraping
con = url("http://scholar.google.com/citations?user=HI-I6C0AAAAJ&hl=en")
htmlCode = readLines(con)
close(con)
htmlCode
