#############
# Exploratory Data Analysis
#############

# Clear work space
rm(list=ls())  # Remove all objects.

# Loading the CSV data set
adverse <- read.table("drug_adverse_effects.csv", header = TRUE, sep = ",", row.names = 'Index',
                      colClasses = c("character", "character", "character", "character",
                                     "character", "numeric", "character", "character",
                                     "character", "character", "character"))
str(adverse)

# Creating factors
adverse$Country <- factor(adverse$Country)
adverse$Sex <- factor(adverse$Sex)                # 1 = Male, 2 = Female
adverse$Indication <- factor(adverse$Indication)
adverse$Event <- factor(adverse$Event)
adverse$Outcome <- factor(adverse$Outcome)
# Codes for Outcome: 1 = Recovered/resolved, 2 = Recovering/resolving,
#  3 = Not recovered/not resolved, 4 = Recovered/resolved with sequelae
#  5 = Fatal, 6 = Unknown

# Exploring the data set
summary(adverse)  # Obs: exagerated values for age and a lot of NAs for Indication.
adverse$Age[adverse$Age > 122] <- NA # Oldest person that have even lived: 122 years old.
summary(adverse)  # Obs:  Large number of NA for Age as well.

# Computing frequencies & proportions and displaying barplots
country.freq <- with(adverse, table(Country))
country.freq
prop.table(country.freq)*100  # Proportions: US ~ 60% & rest are tiny.
barplot(country.freq, main = "Country Frequencies", xlab = "Countries",
        ylab = "Frequencies")

sex.freq <- with(adverse, table(Sex))
sex.freq
prop.table(sex.freq)*100  # Proportions: female = 60%
barplot(sex.freq, main = "Sex Frequencies", xlab = "Sex", ylab = "Frequency")

age.freq <- with(adverse, table(Age))
age.freq
prop.table(age.freq)*100  # Proportions: 
barplot(age.freq, main = "Age Frequencies", xlab = "Age", ylab = "Frequency")
hist(adverse$Age, breaks = 14, main = "Age Frequencies", xlab = "Age")

indication.freq <- with(adverse, table(Indication))
indication.freq
prop.table(indication.freq)*100  # Proportions: a few more common than others
barplot(indication.freq, main = "Indication Frequencies", xlab = "Indication",
        ylab = "Frequency")

event.freq <- with(adverse, table(Event))
event.freq
prop.table(event.freq)*100
# Proportions: same as with Indication but even more diversity
barplot(event.freq, main = "Event Frequencies", xlab = "Event",
        ylab = "Frequency")

outcome.freq <- with(adverse, table(Outcome))
outcome.freq
prop.table(outcome.freq)*100
# Proportions: NA = 60%, less serious events are more frequent
barplot(outcome.freq, main = "Outcome Frequencies", xlab = "Outcome",
        ylab = "Frequencies")

# Looking at frequencies and proportions outside the US
adverse.noUS <- subset(adverse, Country != "US")
country.noUS.freq <- with(adverse.noUS, table(Country))
country.noUS.freq
prop.table(country.noUS.freq)*100
barplot(country.noUS.freq, main = "Country Frequencies Outiside US",
        xlab = "Countries", ylab = "Frequencies")
hist(country.noUS$Freq, main = "Country Frequencies Exluded US",
     xlab = "Countries", ylab = "Frequencies")


###################
# Select only countries and adverse events reported mentioned in more than a certain
# number of countries.  For events, take into account that 75% of reports come from
# the US.  Create a data frame of proportions of adverse event per country.
###################

# Let us set a cutoff number of reports to select which countries we are
# going to include in the analysis.
country.cutoff <- 20000  # 22 countries
country.df <- as.data.frame(country.freq)
country.df
selected.countries <- as.vector(country.df$Country[country.df$Freq > country.cutoff])
selected.countries
selected.countries <- selected.countries[-1]  # Dropping country = ""
selected.countries
length(selected.countries)

adverse.selected <- subset(adverse, Country %in% selected.countries)
adverse.selected <- droplevels(adverse.selected)
head(adverse.selected$Country)
country.selected.freq <- with(adverse.selected, table(Country))
country.selected.freq
prop.table(country.selected.freq)*100  # Proportions: US = 75% & rest are tiny.
barplot(country.selected.freq, main = "Selected Country Frequencies",
        xlab = "Countries", ylab = "Frequencies")
summary(adverse.selected)
nlevels(adverse.selected$Country) # Number of Selected Countries: 21

# Let us now set a cutoff number of reports for the events.
min.events.num = 450  # Minimum number of events per country
event.cutoff <- (nlevels(adverse.selected$Country) - 1)*min.events.num*4
event.cutoff

# The formula above takes into account that the US accounts for 75% of reports.
event.selected.freq <- with(adverse.selected, table(Event))
barplot(event.selected.freq, main = "Event Frequencies for Selected Countries",
        xlab = "Event", ylab = "Frequency")

event.selected.df = as.data.frame(event.selected.freq)
selected.countries.events <-
      as.vector(event.selected.df$Event[event.selected.df$Freq > event.cutoff])
adverse.sel <- subset(adverse.selected, Event %in% selected.countries.events)
adverse.sel <- droplevels(adverse.sel)
head(adverse.sel$Event)
event.sel.freq <- with(adverse.sel, table(Event))
event.sel.freq
prop.table(event.sel.freq)*100
barplot(event.sel.freq, main = "Selected Event Frequencies for Selected Countries",
        xlab = "Events", ylab = "Frequencies")
summary(adverse.sel)
nlevels(adverse.sel$Event) # Number of Selected Adverse Effects: 42
# It seems that we still have good representation by sex and age.


# Create a data frame with the sum frequencies of each adverse event per country.
# It may be possible to use an aggreagation function.
country.event.freq <- with(adverse.sel, table(Country, Event))
country.event.prop <- prop.table(country.event.freq, 1)
country.event <- as.data.frame(country.event.prop)
head(country.event)
colnames(country.event) <- c("Country", "Event", "Prop")
summary(country.event)
sum(country.event$Prop[country.event$Country == "US"])

# Casting it around for analysis
library(reshape2)
country.event.cast <- dcast(country.event, Country ~ Event)
head(country.event.cast)
summary(country.event.cast)

# Saving the data frame as a CSV file
write.csv(country.event.cast, file = "CountryEventsProportions_42.csv", row.names = FALSE)



