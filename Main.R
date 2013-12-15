# Author: Sven Reulen
# Date: 06-12-2013
# Dependencies
# Description: Final exercise for the course geoscripting
# Specialties: A line starting with #+# means functional but unnecessary for the result
#              A line starting with #-# means not functional and not finished.

### Set working directory to source file locations (can be done in options above (session -> set working directory))
#setwd("M:/Applied_geoscripting/Final_exercise/final_exercise")
#datdir <- "M:/Applied_geoscripting/Final_exercise/final_exercise"
source('packages.r')

# 1. Load map and data 2012
source('loadfromdropbox.r')
dl_from_dropbox("Netherlands.zip", "bocfjn1l2yhxzxe")
unzip("Netherlands.zip")
mun_neth <- readOGR('gem_2012_v1.shp', layer = 'gem_2012_v1')

# 2. Clean the shapefile from empty water areas
numberswithvalues <- which(mun_neth@data$AANT_INW > 0)
mun_neth <- mun_neth[numberswithvalues,]

# 3. Add a CSV file containing all municipal reformations in the last 18 years
dl_from_dropbox("Gemeentelijke_herindelingen.csv", "ks3o746s6wy1mdd")
gem_her = read.csv('Gemeentelijke_herindelingen.csv', fill=TRUE, sep = ",", header = T)

# 4. Create functions converting data following municipality reformations year by year
### Splitting municipalities in two datasets, reformed and not reformed
#+#source('splittingdata.r')
### Calculating the data for reformed municipalities
#-# source('addingoldmuns.r')
### Function for substracting the difference between the data now and in the year before to new number
#-# source('differenceintime.r')

#   5. Load in CBS data of municipalities in the 18 years before 2012
### FOR DATASET OF 2012 WITHOUT REFORMATIONS
dl_from_dropbox("woningwaardegemeenten.csv", "97saz2k2xkx3m73")
ww_gem_2012 = read.csv('woningwaardegemeenten.csv', fill=TRUE, sep = ";", header = T)

dl_from_dropbox("inwoners_1995.csv", "70zyf2ndkulx8l7")
inwoners1995 <- read.csv('inwoners_1995.csv', fill=TRUE, header = T)

dl_from_dropbox("verhoudingen_inwoners.csv", "5dkesv9b2em2bc6")
growth_decrease <- read.csv('verhoudingen_inwoners.csv', fill=TRUE, header = T)

dl_from_dropbox("verhoudingen_huishoudens.csv", "qi0ksxe25k7wi05")
household_change <- read.csv('verhoudingen_huishoudens.csv', fill=TRUE, header = T)

#   6. Run the functions on the data in order to make the data compatible to municipalities of 2012
### Splitting municipalities in two datasets, reformed and not reformed. Fill in year of dataset to plot.
#+# devideddata <- splittingdata(mun_neth$GM_NAAM, '1995')
#+# no_reformations <- data.frame(devideddata[1])
#+# no_reformations_data <- merge(no_reformations, melt(inwoners1995, id.var="Onderwerpen"), by.x="GM_NAAM", by.y="Onderwerpen")
#+# with_reformations <- data.frame(devideddata[2])
#-# MISSING FUNCTION TO CALCULATE REFORMED MUNICIPALITIES

#   7. Join the compatible data to the shape file of municipalities in 2012
### ADDING DATA FROM A DATASET TO THE MUN MAP FOR ALL THE MUNICIPALITIES IN no_reformations
#+# data_to_join_map <- rbind(no_reformations_df_and_data, with_reformations_df_and_data)
#+# mun_neth@data = data.frame(mun_neth@data, data_to_join_map[match(mun_neth@data[,2], data_to_join_map[,1]),])
### Adding data to map (((DIRECTLY FROM DATASET)))
shrinking_muns <- subset(growth_decrease, X2005.1995<=0, select=c(GEM_NAAM, X2005.1995))
mun_neth@data = data.frame(mun_neth@data, shrinking_muns[match(mun_neth@data[,2], shrinking_muns[,1]),])

#   8. Create a nice plotting function with a standardized lay out
source('plottingmap.r')
plottingmap("X2005.1995", 'Change in amount of households 2011-2012', "yellow", "red")
