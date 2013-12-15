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

#   5. Load in CBS data of municipalities in the 18 years before 2012
### FOR DATASET OF 2012 WITHOUT REFORMATIONS
dl_from_dropbox("verhoudingen_inwoners.csv", "5dkesv9b2em2bc6")
growth_decrease <- read.csv('verhoudingen_inwoners.csv', fill=TRUE, header = T)

#   6. Run the functions on the data in order to make the data compatible to municipalities of 2012

#   7. Join the compatible data to the shape file of municipalities in 2012
shrinking_muns <- subset(growth_decrease, X2005.1995<=0, select=c(GEM_NAAM, X2005.1995))
mun_neth@data = data.frame(mun_neth@data, shrinking_muns[match(mun_neth@data[,2], shrinking_muns[,1]),])

#   8. Create a nice plotting function with a standardized lay out
source('plottingmap.r')
plottingmap("X2005.1995", 'Change in amount of households 2011-2012', "yellow", "red")
