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

# Et sidespring til manøvrer med en liste til de næste øvelser
mylist <- list(letters = c("A", "b", "c"), numbers = 1:3, matrix(1:25, ncol = 5))
head(mylist)
mylist[1] # første element i listen
mylist$letters # subset via named vaiable
mylist[[1]] # subset out alene vectoren ved at udtage det første element i den liste

# tilbage til den forrige character vector
splitNames[[6]][1] # et eksempel der viser hvordan man udtager et enkelt element fra de opsplittede navne
firstElement <- function(x){x[1]} # vi laver en funktion der tager det første element i en liste
sapply(splitNames, firstElement) # for hver element i listen udtager vi det første element, hvorved vi får fjernet . og det bagefter i eksempelvis Location.1

# Vi genbruger data fra tidligere øvelser
reviews = read.csv("./data/reviews.csv"); solutions <- read.csv("./data/solutions.csv")
head(reviews,2)
head(solutions,2)
# Fixing character vectors - sub()
names(reviews)
sub("_","",names(reviews)) # vi fjerner undercores fra navnene
# Fixing character vectors - gsub()
testName <- "this_is_a_test"
sub("_","",testName) # sub() fjerner kun den første forekomst
gsub("_","",testName) # gsub() fjerner alle forekomster
# Finding values - grep(),grepl()
grep("Alameda",cameraData$intersection) # finder de elementer i intersection-variablen, som indeholder Alameda
table(grepl("Alameda",cameraData$intersection)) # grepl() returnerer en vektor, med TRUE og FALSE
cameraData2 <- cameraData[!grepl("Alameda",cameraData$intersection),] # her opretter vi et nyt dataset med alle de rækker, hvor Alamede ikke optræder i cameraData$intersection
grep("Alameda",cameraData$intersection,value=TRUE) # value=TRUE gør at det er værdien og ikke pladsen der returneres
length(grep("JeffStreet",cameraData$intersection)) # en måde at tjekke om værdien findes eller ej
# Flere anvendelige tekst-funktioner
library(stringr)
nchar("Jon Jagd CHristensen") #finder antallet af karaterer
substr("Jon Jagd Christensen",1,7) #Udtage en del af en streng, fra og til karakterer
paste("Jon", "Jagd", "Christensen") #sammensætning eller konkatenering af en streng
paste0("Jon", "Jagd", "Christensen") #sammensætter UDEN mellemrum
str_trim("   Jon       ") # fjerner overflødige blanke karakterer i enderne
#Vigtige pointer vedr. tekst i datasets
# Variabelnavne
# - Kun lower case når det er muligt
# - Beskrivende (Diagnose vs. Dx)
# - Ikke duplikerede
# - Ingen underscores, punktummer eller mellemrum
# Variable med karakterværdier
# - Bør normalvis laves som faktorvariable
# - Bør være beskrivende (bruge TRUE/FALSE i stedet for 0/1 og Male/Female vs 0/1 eller M/F)

# Regular expressions I
# Literals (bogstaverne) og metacharacterer er lige som grammatikken (wildcards, søgefunktioner mm)
# ^i think : begyndelsen af en linje og vil matche "i think we all" m.fl.
# mornings$ : $ repræsenterer afslutningen på en linje
# Character Classes with []: [Bb][Uu][Ss][Hh] vil finde alle udgaver af bush uanset kombinationen af store og små bogstaver
# ^[Ii] am: begyndelsen af linjen med enten stort eller lille i
# [a-z] eller [a-zA-Z]: ranges af bogstaver og rækkefølgen er lige meget
# ^[0-9][a-zA-Z] : vil finde enhver sætning der begynder med et tal og som efterfølges af alle slags bogstaver fra a - z uanset om det er store eller små bogstaver
# [^?.]$ : når ^ bruges i begyndelsen af en character class finder alle der ender med noget andet end ? eller .

# Regular expressions II
# More Metacharacters
# "." er et wild card der bruges til at referere til en hvilken som helst karakterer, men altså kun 1 karakter
# 9.11 vil f.eks. finde "post 9-11 rules", "did 9/11 we"

# | som betyder OR er en anden metakarakter
# flood|fire vil finde alle linjer der indeholder enten flood eller fire
# flood|fire|earthquake|hurricane|coldfire : man kan indsætte uendeligt antal alternativer
# Alternativerne i en OR kan osgå være expressions og ikke kun literals
# ^[Gg]ood|[Bb]ad : vil finde "good to ..", eller "Good afternoon... eller "..had bad experience.."
# ^([Gg]ood|[Bb]ad) : paranteserne gør at både good og bad skal findes som første ord i linjen
# [Gg]eorge( [Ww]\.)? [Bb]ush : vil finde en linje med eks. "george bush" fordi ? gør at [Ww]\. bliver valgfri. Escape-karakteren \ gør at punktummet her bliver opfattet som en literal

# * og + indikerer gentagelser; * et hvilket som helst antal inkl. ingen af dem, + betyder mindst en af dem
# (.*) : et hvilket som helst antal af karakterer melem to () inklusiv ingenting
# [0-9]+ (.*)[0-9]+: Et til mange tal, efterfulgt af to () evt. med noget i mellem, og efterfulgt af 1 til flere tal

# More metacharacters: { and } - interval quantifiers som lader os specificere minimum og maksimum antal matches for et udtryk
# [Bb]ush( +[^ ]+ +){1,5} debate : Mellem bush og debate skal der findes minimum 1 mellemrum - "( + "-, efterfulgt af noget som ikke er et mellemrum - "[^ ]+" - efterfulgt af mindst 1 mellemrum - " +" - gentaget mindst 5 gange - "{1,5}". Altså mellemrum - ord - mellemrum op til 5 gange mellem bush og debate
# m,n mellem {: mindst m men ikke mere end n matches 
# m: betyder præcis m antal matches
# m,: betyder mindst m antal matches

# (and) genbesøgt: begrænser scope for alternativer opdelt af | men kan også bruges til at "huske" text matched ad disse subexpressions
# man referer til matched tekst med \1, \2 osv
#  +([a-zA-Z]+) +\1 +: et mellemrum efterfulgt af 1 eller flere karakterer efterfulgt af mindst et mellemrum efterfulgt af eksakt det samme match som vi fandt i paranteserne. Eks. "blah blah"

# * er grådig og finder altid den længst mulige
# ^s(.*)s : skal starte med et s efterfulgt af et ukendt antal karakterer efterfulgt af endnu et s, eks. "sitting at starbucks"
# * grådighed kan slås fra ? (finder ikke længere maksimum længde) og $: ^s(.*$)s$