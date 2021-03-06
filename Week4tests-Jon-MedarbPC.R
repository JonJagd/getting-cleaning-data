# Editing text variables

# Fixing character vectors - tolower(), toupper()
if (!file.exists("data")) {dir.create("data")}
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./data/cameras.csv")
cameraData <- read.csv("./data/cameras.csv")
names(cameraData)
toupper(names(cameraData)) # alle bogstaver i titlerne konverteres til UPPER case
tolower(names(cameraData)) # alle bogstaver i titlerne konverteres til lower case

# Fixing character vectors 
# strsplit() - god til automatisk opsplitning af variabelnavne
splitNames = strsplit(names(cameraData), "\\.")
splitNames[[6]] #"Location.1" er splittet til "Location" "1"  

# Et sidespring til man�vrer med en liste til de n�ste �velser
mylist <- list(letters = c("A", "b", "c"), numbers = 1:3, matrix(1:25, ncol = 5))
head(mylist)
mylist[1] # f�rste element i listen
mylist$letters # subset via named vaiable
mylist[[1]] # subset out alene vectoren ved at udtage det f�rste element i den liste

# tilbage til den forrige character vector
splitNames[[6]][1] # et eksempel der viser hvordan man udtager et enkelt element fra de opsplittede navne
firstElement <- function(x){x[1]} # vi laver en funktion der tager det f�rste element i en liste
sapply(splitNames, firstElement) # for hver element i listen udtager vi det f�rste element, hvorved vi f�r fjernet . og det bagefter i eksempelvis Location.1

# Vi genbruger data fra tidligere �velser
reviews = read.csv("./data/reviews.csv"); solutions <- read.csv("./data/solutions.csv")
head(reviews,2)
head(solutions,2)
# Fixing character vectors - sub()
names(reviews)
sub("_","",names(reviews)) # vi fjerner undercores fra navnene
# Fixing character vectors - gsub()
testName <- "this_is_a_test"
sub("_","",testName) # sub() fjerner kun den f�rste forekomst
gsub("_","",testName) # gsub() fjerner alle forekomster
# Finding values - grep(),grepl()
grep("Alameda",cameraData$intersection) # finder de elementer i intersection-variablen, som indeholder Alameda
table(grepl("Alameda",cameraData$intersection)) # grepl() returnerer en vektor, med TRUE og FALSE
cameraData2 <- cameraData[!grepl("Alameda",cameraData$intersection),] # her opretter vi et nyt dataset med alle de r�kker, hvor Alamede ikke optr�der i cameraData$intersection
grep("Alameda",cameraData$intersection,value=TRUE) # value=TRUE g�r at det e rv�rdien og ikke pladsen der returneres
length(grep("JeffStreet",cameraData$intersection)) # en m�de at tjekke om v�rdien findes eller ej
# Flere anvendelige tekst-funktioner
library(stringr)
nchar("Jon Jagd CHristensen") #finder antallet af karaterer
substr("Jon Jagd Christensen",1,7) #Udtage en del af en streng, fra og til karakterer
paste("Jon", "Jagd", "Christensen") #sammens�tning eller konkatenering af en streng
paste0("Jon", "Jagd", "Christensen") #sammens�tter UDEN mellemrum
str_trim("   Jon       ") # fjerner overfl�dige blanke karakterer i enderne
#Vigtige pointer vedr. tekst i datasets
# Variabelnavne
# - Kun lower case n�r det er muligt
# - Beskrivende (Diagnose vs. Dx)
# - Ikke duplikerede
# - Ingen underscores, punktummer eller mellemrum
# Variable med karakterv�rdier
# - B�r normalvis laves som faktorvariable
# - B�r v�re beskrivende (bruge TRUE/FALSE i stedet for 0/1 og Male/Female vs 0/1 elelr M/F)