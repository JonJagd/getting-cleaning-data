# Subsetting and sorting
set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X <-X[sample(1:5),]; X$var2[c(1,3)] = NA
X
X[(X$var1 <= 3 | X$var3 > 15),]
X[X$var2 > 8,] #inkluderer NA-v�rdier
X[which(X$var2 > 8),] # which-funktionen bruges for at h�ndtere(frafiltrere) NA-v�rdier
sort(X$var1) #returnerer v�rdier i sorteret r�kkef�lge
sort(X$var1,decreasing = TRUE)
sort(X$var2,na.last = TRUE)
X[order(X$var1,X$var3),] #sorter output'et af en dataframe
install.packages("plyr")
library(plyr)
arrange(X,desc(var1)) #sortering med plyr-pakken
X$var4 <- rnorm(5) #tilf�jer en kolonne
Y <- cbind(X, rnorm(5)) # laver en ny data frame, som kombinerer kolonner fra X med den nye kolonne, som ogs� kan foranstilles
Y <- rbind(X, rnorm(5)) # laver en ny data frame, som kombinerer r�kkerne fra X med en ny r�kke, som ogs� kan foranstilles

#Summarizing data
if (!file.exists("data")) {
        dir.create("data")
}
fileUrl <- "https://data.baltimorecity.gov/api/views/k5ry-ef3g/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/restaurants.csv")
restData <- read.csv("./data/restaurants.csv")
head(restData,n=3)
tail(restData,n=3)
summary(restData)
str(restData)
quantile(restData$councilDistrict, na.rm = TRUE)
quantile(restData$councilDistrict, probs=c(0.5,0.75,0.9))
# Opret tabel
table(restData$zipCode,useNA = "ifany") # laver en summering af antal forekomster per zipCode, useNA = "ifany" tilf�jer en kolonne til count af NA's hvis der er nogen
table(restData$councilDistrict, restData$zipCode) # 2-dimensionel tabel af count af restauranter i forhold til distrikter og zip-koder
# Check om der er manglende v�rdier
sum(is.na(restData$councilDistrict)) #t�l antallet af manglede v�rdier
any(is.na(restData$councilDistrict)) #angiver om der er manglede v�rdier eller ej
all(restData$zipCode > 0)
# Row and column sums
colSums(is.na(restData)) #t�ller for hver kolonne antallet af v�rdier, der evaluerer til TRUE (1) p� ok de er Na
all(colSums(is.na(restData))==0)# evaluerer om alle kolonner har 0 v�rdier der er Na
# V�rdier med specifikke karakteristika
table(restData$zipCode %in% c("21212","21213")) # %in% er i s�r gavnligt n�r man vil tjekke for flere v�rdier
restData[restData$zipCode %in% c("21212","21213"),]
# Cross tabs
data("UCBAdmissions")
DF = as.data.frame(UCBAdmissions)
summary(DF)
xt <- xtabs(Freq ~ Gender + Admit, data = DF)
# Flade tabeller
warpbreaks$replicate <- rep(1:9, len = 54)
xt = xtabs(breaks ~.,data=warpbreaks) # t�ller antallet af breaks brudt ned p� alle (.) variable 
ftable(xt) # kan bruges til at flade det ud og opsummere det lidt a la en pivotabelops�tning
#St�rrelse af af datase�t
fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData),units = "Mb")

# Creating new variables
# At skabe sekvenser
s1 <- seq(1,10,by=2); s1 # [1] 1 3 5 7 9
s2 <- seq(1,10,length=3); s2 # [1]  1.0  5.5 10.0
x <- c(1,3,8,25,100); seq(along=x) # seq(along...) bruges til at skabe en vector med lige s� mange sekventielle tal som i x

# Subsetting variables
restData$nearMe = restData$neighborhood %in% c("Roland Park", "Homeland") # Tilf�jer en kolonne nearMe med en boolsk/binary markering
table(restData$nearMe) #table() giver en summering p� kolonnen nearMe
head(restData)
# Binary variables
restData$zipWrong = ifelse(restData$zipCode < 0, TRUE, FALSE) # opretter en bin�r variabel der markerer om zip er < 0
table(restData$zipWrong,restData$zipCode < 0) # viser fordelingen
# Categorical values
restData$zipGroups = cut(restData$zipCode,breaks=quantile(restData$zipCode)) # en faktorvariable der opdeler zipCode i grupper af kvartiler
table(restData$zipGroups)
table(restData$zipGroups,restData$zipCode)

install.packages("Hmisc")
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode,g=4) # alternativ og lidt enklere m�de at opdele zipCode i kvartiler
table(restData$zipGroups)
# Oprette faktor variable
restData$zcf <- factor(restData$zipCode) # zipCode er en integer-variable, s� man kan �ndre den til en faktor-variabel
restData$zcf[1:10]
class
# Niveauer af factor variable
yesno <- sample(c("yes","no"),size = 10,replace = TRUE) # vi opretter en character-vector med tilf�ldig serie p� 10 v�rdier af "yes" og "no"  
yesnofac = factor(yesno,levels=c("yes","no")) # vi opretter en factor-variabel p� grundlag af character-vectoren 
relevel(yesnofac,ref = "yes") # funktionen s�tter referencev�rdien til i dette tilf�lde at v�re "yes"
as.numeric(yesnofac)
#Cutting producerer factor variable
# Brug af mutate-funktionen
library(plyr)
restData2 = mutate(restData,zipGroups=cut2(zipCode,g=4)) # mutate-funktionen bruges til igen at opdele i zip-grupper og direkte tilf�je det i en tabel
table(restData2$zipGroups)
# Common transformations
# abs(x) absolute value
# sqrt(x) square root
# ceiling(x) rund op
# floor(x) rund ned
# round(x, digts=n)
# signif(x, digits=n) 3.475 er 3.5

#Reshaping data
library(reshape2)
head(mtcars)
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars,id=c("carname","gear","cyl"),measure.vars = c("mpg","hp"))
# melt-funktionen laver en "h�j og tynd" tabel, hvor der bliver lavet en ny r�kke for hver variabel/measure og v�rdi
head(carMelt,n=3)
tail(carMelt,n=3)
cylData <- dcast(carMelt, cyl ~ variable) #dcast er en aggregeringsfunktion, som i dette tilf�lde for hver gruppe af cylindre opsummerer antal (length) af variable
cylData <- dcast(carMelt, cyl ~ variable,mean) #i stedet for default-funktionen length beregner dcast nu mean for hver variable for hver gruppe
#Averaging values for faktorer
head(InsectSprays)
tapply(InsectSprays$count,InsectSprays$spray,sum) # for hver gruppe af spray laver den en sum af count-kolonnen
# Split - apply, combine
spIns = split(InsectSprays$count,InsectSprays$spray) # split returnerer en liste af counts grupperet efter de forskellige sprays
sprCount = lapply(spIns,sum) # efter at have udf�rt et split kan man lave en apply p� det opsplittede datas�t
unlist(sprCount) # for at komme tilbage til en vector kan vi unliste listen
sapply(spIns,sum)# en m�de at udf�re apply & combine i et step efter opsplitningen
library(plyr)
ddply(InsectSprays,.(spray),summarize,sum=sum(count)) # en anden m�de at lave en split, apply & combine
spraySums <- ddply(InsectSprays,.(spray),summarize,sum=ave(count,FUN=sum)) # vi opretter en ny variabel med samme l�ngde som det oprindelige datas�t, alts� en total sum sat ind p� hver r�kke, som kan tilf�jes datas�ttet og bruges til at lave beregninger
dim(spraySums)
head(spraySums)

# Managing data frames with dplyr
library(dplyr)
options(width = 105)
fileURL <- "https://github.com/DataScienceSpecialization/courses/blob/master/03_GettingData/dplyr/chicago.rds?raw=true"
download.file(fileURL, destfile = "./data/chicago.rds", extra='-L', mode = "wb")
chicago <- readRDS("./data/chicago.rds")
dim(chicago)
str(chicago)
head(select(chicago, city:dptp)) # dplyr muligg�r en select med direkte reference til kolonnenavne
head(select(chicago, -(city:dptp))) # ved at bruge minus (-) kan frav�lge kolonner i output
#f�lgende tre linjer opn�r det samme som en linje med dplyr
i <- match("city", names(chicago))# vi finder indekset (pladsen) for kolonnen
j <- match("dptp", names(chicago))
head(chicago[, -(i:j)])
# filter() - en anden dplyr-funktion
chic.f <- filter(chicago, pm25tmean2 > 30) # frafiltrerer r�kker med pm25tmean er st�rre end 30
head(chic.f, 10)
chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80) # flere kriterier kan kombineres
head(chic.f)
# arrange() er en effeltiv metode til at sortere et datas�t
chicago <- arrange(chicago, date)
head(chicago)
tail(chicago)
chicago <- arrange(chicago, desc(date)) # sortering descending
head(chicago)
tail(chicago)
# Renaming af variables
chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint = dptp)
head(chicago)
# mutate() bruges til at transformere eksisterende eller oprette nye variable
chicago <- mutate(chicago, pm25detrend = pm25-mean(pm25, na.rm = TRUE)) # vi opretter en vairabel, hvor vi beregner pm25's afvigelse fra gennemsnittet
head(select(chicago, pm25, pm25detrend))
# Group by bruges til at splitte et data s�t op via nogle kategorier
chicago <- mutate(chicago, tempcat = factor(1 * (tmpd > 80), labels = c("cold", "hot"))) # vi tilf�jer en factor-variabel baseret p� om tmpd er > 80
hotcold <- group_by(chicago, tempcat) # vi opretter en dataframe grupperet p� tempcat
summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))
# kategorisering p� andre variable eks summary for hvert �r
chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900) # vi tilf�jer en �rsvariabel vha. POSIXLt-funktionen der tr�kker �r ud af datoen
years <- group_by(chicago, year)
summarize(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))
# det hele kan g�res og vises i en lang "pipeline"
# her som et summary af pollutant-variables per m�ned
# ved at bruge %>% kan g� direkte til variable og beh�ver tilsyneladende ikke at referere til data frame'en f�rst
chicago %>% mutate(month = as.POSIXlt(date)$mon +1) %>%group_by(month) %>% summarize(pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))

# Merging data
if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileUrl2 = "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1,destfile="./data/reviews.csv", mode = "wb")
download.file(fileUrl2,destfile="./data/solutions.csv", mode = "wb")
reviews = read.csv("./data/reviews.csv"); solutions <- read.csv("./data/solutions.csv")
head(reviews,2)
head(solutions,2)
names(reviews)
names(solutions)
mergedData = merge(reviews,solutions,by.x = "solution_id",by.y="id",all = TRUE)
head(mergedData)
intersect(names(solutions),names(reviews)) # viser bare de f�lles kolonnenavne og dermed hvad der kan ske hvis man ikke specificerer hvad der skal merges by
# joins i plyr-pakken, kan kun joine p� kolonner med de samme navne og defaulter til left join
library(plyr)
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
arrange(join(df1,df2),id) # de to datasets bliver joinet p� id og derefter sorteret p� id
df3 = data.frame(id=sample(1:10),z=rnorm(10))
dfList = list(df1,df2,df3) # laver f�rst en liste med 3 dataframes i
join_all(dfList) # effektiv og nem m�de at joine flere end 2 tabeller