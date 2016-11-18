# Subsetting and sorting
set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X <-X[sample(1:5),]; X$var2[c(1,3)] = NA
X
X[(X$var1 <= 3 | X$var3 > 15),]
X[X$var2 > 8,] #inkluderer NA-værdier
X[which(X$var2 > 8),] # which-funktionen bruges for at håndtere(frafiltrere) NA-værdier
sort(X$var1) #returnerer værdier i sorteret rækkefølge
sort(X$var1,decreasing = TRUE)
sort(X$var2,na.last = TRUE)
X[order(X$var1,X$var3),] #sorter output'et af en dataframe
install.packages("plyr")
library(plyr)
arrange(X,desc(var1)) #sortering med plyr-pakken
X$var4 <- rnorm(5) #tilføjer en kolonne
Y <- cbind(X, rnorm(5)) # laver en ny data frame, som kombinerer kolonner fra X med den nye kolonne, som også kan foranstilles
Y <- rbind(X, rnorm(5)) # laver en ny data frame, som kombinerer rækkerne fra X med en ny række, som også kan foranstilles

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
table(restData$zipCode,useNA = "ifany") # laver en summering af antal forekomster per zipCode, useNA = "ifany" tilføjer en kolonne til count af NA's hvis der er nogen
table(restData$councilDistrict, restData$zipCode) # 2-dimensionel tabel af count af restauranter i forhold til distrikter og zip-koder
# Check om der er manglende værdier
sum(is.na(restData$councilDistrict)) #tæl antallet af manglede værdier
any(is.na(restData$councilDistrict)) #angiver om der er manglede værdier eller ej
all(restData$zipCode > 0)
# Row and column sums
colSums(is.na(restData)) #tæller for hver kolonne antallet af værdier, der evaluerer til TRUE (1) på ok de er Na
all(colSums(is.na(restData))==0)# evaluerer om alle kolonner har 0 værdier der er Na
# Værdier med specifikke karakteristika
table(restData$zipCode %in% c("21212","21213")) # %in% er i sær gavnligt når man vil tjekke for flere værdier
restData[restData$zipCode %in% c("21212","21213"),]
# Cross tabs
data("UCBAdmissions")
DF = as.data.frame(UCBAdmissions)
summary(DF)
xt <- xtabs(Freq ~ Gender + Admit, data = DF)
# Flade tabeller
warpbreaks$replicate <- rep(1:9, len = 54)
xt = xtabs(breaks ~.,data=warpbreaks) # tæller antallet af breaks brudt ned på alle (.) variable 
ftable(xt) # kan bruges til at flade det ud og opsummere det lidt a la en pivotabelopsætning
#Størrelse af af dataseæt
fakeData = rnorm(1e5)
object.size(fakeData)
print(object.size(fakeData),units = "Mb")

# Creating new variables
# At skabe sekvenser
s1 <- seq(1,10,by=2); s1 # [1] 1 3 5 7 9
s2 <- seq(1,10,length=3); s2 # [1]  1.0  5.5 10.0
x <- c(1,3,8,25,100); seq(along=x) # seq(along...) bruges til at skabe en vector med lige så mange sekventielle tal som i x

# Subsetting variables
restData$nearMe = restData$neighborhood %in% c("Roland Park", "Homeland") # Tilføjer en kolonne nearMe med en boolsk/binary markering
table(restData$nearMe) #table() giver en summering på kolonnen nearMe
head(restData)
# Binary variables
restData$zipWrong = ifelse(restData$zipCode < 0, TRUE, FALSE) # opretter en binær variabel der markerer om zip er < 0
table(restData$zipWrong,restData$zipCode < 0) # viser fordelingen
# Categorical values
restData$zipGroups = cut(restData$zipCode,breaks=quantile(restData$zipCode)) # en faktorvariable der opdeler zipCode i grupper af kvartiler
table(restData$zipGroups)
table(restData$zipGroups,restData$zipCode)

install.packages("Hmisc")
library(Hmisc)
restData$zipGroups = cut2(restData$zipCode,g=4) # alternativ og lidt enklere måde at opdele zipCode i kvartiler
table(restData$zipGroups)
# Oprette faktor variable
restData$zcf <- factor(restData$zipCode) # zipCode er en integer-variable, så man kan ændre den til en faktor-variabel
restData$zcf[1:10]
class
# Niveauer af factor variable
yesno <- sample(c("yes","no"),size = 10,replace = TRUE) # vi opretter en character-vector med tilfældig serie på 10 værdier af "yes" og "no"  
yesnofac = factor(yesno,levels=c("yes","no")) # vi opretter en factor-variabel på grundlag af character-vectoren 
relevel(yesnofac,ref = "yes") # funktionen sætter referenceværdien til i dette tilfælde at være "yes"
as.numeric(yesnofac)
#Cutting producerer factor variable
# Brug af mutate-funktionen
library(plyr)
restData2 = mutate(restData,zipGroups=cut2(zipCode,g=4)) # mutate-funktionen bruges til igen at opdele i zip-grupper og direkte tilføje det i en tabel
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
# melt-funktionen laver en "høj og tynd" tabel, hvor der bliver lavet en ny række for hver variabel/measure og værdi
head(carMelt,n=3)
tail(carMelt,n=3)
cylData <- dcast(carMelt, cyl ~ variable) #dcast er en aggregeringsfunktion, som i dette tilfælde for hver gruppe af cylindre opsummerer antal (length) af variable
cylData <- dcast(carMelt, cyl ~ variable,mean) #i stedet for default-funktionen length beregner dcast nu mean for hver variable for hver gruppe
#Averaging values for faktorer
head(InsectSprays)
tapply(InsectSprays$count,InsectSprays$spray,sum) # for hver gruppe af spray laver den en sum af count-kolonnen
# Split - apply, combine
spIns = split(InsectSprays$count,InsectSprays$spray) # split returnerer en liste af counts grupperet efter de forskellige sprays
sprCount = lapply(spIns,sum) # efter at have udført et split kan man lave en apply på det opsplittede datasæt
unlist(sprCount) # for at komme tilbage til en vector kan vi unliste listen
sapply(spIns,sum)# en måde at udføre apply & combine i et step efter opsplitningen
library(plyr)
ddply(InsectSprays,.(spray),summarize,sum=sum(count)) # en anden måde at lave en split, apply & combine
spraySums <- ddply(InsectSprays,.(spray),summarize,sum=ave(count,FUN=sum)) # vi opretter en ny variabel med samme længde som det oprindelige datasæt, altså en total sum sat ind på hver række, som kan tilføjes datasættet og bruges til at lave beregninger
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
head(select(chicago, city:dptp)) # dplyr muliggør en select med direkte reference til kolonnenavne
head(select(chicago, -(city:dptp))) # ved at bruge minus (-) kan fravælge kolonner i output
#følgende tre linjer opnår det samme som en linje med dplyr
i <- match("city", names(chicago))# vi finder indekset (pladsen) for kolonnen
j <- match("dptp", names(chicago))
head(chicago[, -(i:j)])
# filter() - en anden dplyr-funktion
chic.f <- filter(chicago, pm25tmean2 > 30) # frafiltrerer rækker med pm25tmean er større end 30
head(chic.f, 10)
chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80) # flere kriterier kan kombineres
head(chic.f)
# arrange() er en effeltiv metode til at sortere et datasæt
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
# Group by bruges til at splitte et data sæt op via nogle kategorier
chicago <- mutate(chicago, tempcat = factor(1 * (tmpd > 80), labels = c("cold", "hot"))) # vi tilføjer en factor-variabel baseret på om tmpd er > 80
hotcold <- group_by(chicago, tempcat) # vi opretter en dataframe grupperet på tempcat
summarize(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))
# kategorisering på andre variable eks summary for hvert år
chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900) # vi tilføjer en årsvariabel vha. POSIXLt-funktionen der trækker år ud af datoen
years <- group_by(chicago, year)
summarize(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))
# det hele kan gøres og vises i en lang "pipeline"
# her som et summary af pollutant-variables per måned
# ved at bruge %>% kan gå direkte til variable og behøver tilsyneladende ikke at referere til data frame'en først
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
intersect(names(solutions),names(reviews)) # viser bare de fælles kolonnenavne og dermed hvad der kan ske hvis man ikke specificerer hvad der skal merges by
# joins i plyr-pakken, kan kun joine på kolonner med de samme navne og defaulter til left join
library(plyr)
df1 = data.frame(id=sample(1:10),x=rnorm(10))
df2 = data.frame(id=sample(1:10),y=rnorm(10))
arrange(join(df1,df2),id) # de to datasets bliver joinet på id og derefter sorteret på id
df3 = data.frame(id=sample(1:10),z=rnorm(10))
dfList = list(df1,df2,df3) # laver først en liste med 3 dataframes i
join_all(dfList) # effektiv og nem måde at joine flere end 2 tabeller