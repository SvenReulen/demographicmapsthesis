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
# Adapting municipalities with untypable names
mun_neth$GM_NAAM <- as.factor(replace(as.character(mun_neth$GM_NAAM), 406, "S£dwest-FryslÄn"))
mun_neth$GM_NAAM <- as.factor(replace(as.character(mun_neth$GM_NAAM), 245, "GaasterlÄn-Sleat"))
mun_neth$GM_NAAM <- as.factor(replace(as.character(mun_neth$GM_NAAM), 19, "SkarsterlÄn"))

#   3. Load in CBS data of municipalities in the 18 years before 2012
### FOR DATASET OF 2012 WITHOUT REFORMATIONS
dl_from_dropbox("verhoudingen_inwoners.csv", "gijo0pg6pz9qphd")
data = read.csv("verhoudingen_inwoners.csv", fill=TRUE, header = T)
data$GEM_NAAM <- as.factor(replace(as.character(data$GEM_NAAM), 298, "S£dwest-FryslÄn"))
data$GEM_NAAM <- as.factor(replace(as.character(data$GEM_NAAM), 112, "GaasterlÄn-Sleat"))
data$GEM_NAAM <- as.factor(replace(as.character(data$GEM_NAAM), 315, "SkarsterlÄn"))

### 4.2 Difference in population
# 4.2.1 Municipalities with a shrinking population 1995-2005
future_trend <- subset(data, inw_2005.1995<=0, select=c(GEM_NAAM, inw_2005.1995))
mun_neth@data = data.frame(mun_neth@data, future_trend[match(mun_neth@data[,2], future_trend[,1]),])
plottingmap("inw_2005.1995", 'Municipalities with a shrinking population 1995-2005', "yellow", "red", "Decrease in population")
# 4.2.2 Municipalities with a shrinking population 2005-2012
future_trend <- subset(data, inw_2012.2005<=0, select=c(GEM_NAAM, inw_2012.2005))
mun_neth@data = data.frame(mun_neth@data, future_trend[match(mun_neth@data[,2], future_trend[,1]),])
plottingmap("inw_2012.2005", 'Municipalities with a shrinking population 2005-2012', "yellow", "red", "Decrease in population")
# 4.2.3 Expected difference in population 2012-2025
future_trend <- subset(data, inw_2012.2025<=0, select=c(GEM_NAAM, inw_2012.2025))
mun_neth@data = data.frame(mun_neth@data, future_trend[match(mun_neth@data[,2], future_trend[,1]),])
plottingmap("inw_2012.2025", 'Expected difference in population 2012-2025', "yellow", "red", "Decrease in population")
# 4.2.4 Expected difference in population 2012-2040
future_trend <- subset(data, inw_2012.2040<=0, select=c(GEM_NAAM, inw_2012.2040))
mun_neth@data = data.frame(mun_neth@data, future_trend[match(mun_neth@data[,2], future_trend[,1]),])
plottingmap("inw_2012.2040", 'Expected difference in population 2012-2040', "yellow", "red", "Decrease in population")
