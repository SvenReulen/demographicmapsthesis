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
data$
#   4. Create a nice plotting function with a standardized lay out
source('plottingmap.r')
### 4.1 Relative difference in amount of households 2005-2012
mun_neth@data = data.frame(mun_neth@data, data[match(mun_neth@data[,2], data[,1]),])
plottingmap("HH_rel_2005_2012", 'Relative difference in amount of households 2005-2012', "purple", "yellow")
### 4.2 Difference in population
# 4.2.1 Municipalities with a shrinking population 1995-2005
future_trend <- subset(data, inw_2005.1995<=0, select=c(GEM_NAAM, inw_2005.1995))
mun_neth@data = data.frame(mun_neth@data, future_trend[match(mun_neth@data[,2], future_trend[,1]),])
plottingmap("inw_2005.1995", 'Municipalities with a shrinking population 1995-2005', "yellow", "red")
# 4.2.2 Municipalities with a shrinking population 2005-2012
future_trend <- subset(data, inw_2012.2005<=0, select=c(GEM_NAAM, inw_2012.2005))
mun_neth@data = data.frame(mun_neth@data, future_trend[match(mun_neth@data[,2], future_trend[,1]),])
plottingmap("inw_2012.2005", 'Municipalities with a shrinking population 2005-2012', "yellow", "red")
# 4.2.3 Expected difference in population 2012-2025
future_trend <- subset(data, inw_2012.2025<=0, select=c(GEM_NAAM, inw_2012.2025))
mun_neth@data = data.frame(mun_neth@data, future_trend[match(mun_neth@data[,2], future_trend[,1]),])
plottingmap("inw_2012.2025", 'Expected difference in population 2012-2025', "yellow", "red")
# 4.2.4 Expected difference in population 2012-2040
future_trend <- subset(data, inw_2012.2040<=0, select=c(GEM_NAAM, inw_2012.2040))
mun_neth@data = data.frame(mun_neth@data, future_trend[match(mun_neth@data[,2], future_trend[,1]),])
plottingmap("inw_2012.2040", 'Expected difference in population 2012-2040', "yellow", "red")

### 4.3 Working population
# 4.3.1 % of the population 20-65 years 2012 
mun_neth@data = data.frame(mun_neth@data, data[match(mun_neth@data[,2], data[,1]),])
plottingmap("X2012_wp", '% of the population 20-65 years 2012', "green", "red")
# 4.3.2 % of the population 20-65 years 2025
mun_neth@data = data.frame(mun_neth@data, data[match(mun_neth@data[,2], data[,1]),])
plottingmap("X2025_wp", '% of the population 20-65 years 2025', "green", "red")
# 4.3.3 % of the population 20-65 years 2040
mun_neth@data = data.frame(mun_neth@data, data[match(mun_neth@data[,2], data[,1]),])
plottingmap("X2040_wp", '% of the population 20-65 years 2040', "green", "red")

### 4.4 Aging
# 4.4.1 % of the population 65+ 2012 
mun_neth@data = data.frame(mun_neth@data, data[match(mun_neth@data[,2], data[,1]),])
plottingmap("X2012_aging", '% of the population 65+ 2012', "blue", "grey")
# 4.4.2 % of the population 65+ 2025
mun_neth@data = data.frame(mun_neth@data, data[match(mun_neth@data[,2], data[,1]),])
plottingmap("X2025_aging", '% of the population 65+ 2025', "blue", "grey")
# 4.4.3 % of the population 65+ 2040
mun_neth@data = data.frame(mun_neth@data, data[match(mun_neth@data[,2], data[,1]),])
plottingmap("X2040_aging", '% of the population 65+ 2040', "blue", "grey")

### 4.5 Region of interest
mun_neth@data = data.frame(mun_neth@data, data[match(mun_neth@data[,2], data[,1]),])
plottingmap("score", 'Municipality score', "green", "red")

### 5. Selecting region of interest
region_of_interest <- subset(mun_neth, GM_NAAM=="Groningen" | GM_NAAM == "Noordenveld" | GM_NAAM == "Ooststellingwerf" | GM_NAAM == "Westerveld" | GM_NAAM == "Midden-Drenthe" | GM_NAAM == "Borger-Odoorn" | GM_NAAM == "Aa en Hunze" | GM_NAAM == "Assen" | GM_NAAM == "Tynaarlo" | GM_NAAM == "Haren", select=GM_CODE:score)
idList <- region_of_interest@data$GM_NAAM
centroids.df <- as.data.frame(coordinates(region_of_interest))
names(centroids.df) <- c("Longitude", "Latitude")
randomMap.df <- data.frame(id = idList, values = region_of_interest$score, centroids.df)

plottingmap_roi("score", 'Municipality score', "green", "red")

gemeentenamen <- as.factor(region_of_interest$GM_NAAM)
region_of_interest.fort <- fortify(region_of_interest, region = "score")
region_of_interest.fort$id <- as.numeric(region_of_interest.fort$id)
region_of_interest.fort$id <- region_of_interest.fort$id
ggplot(data = region_of_interest.fort, aes(x = long, y = lat, fill = id, group = group)) +
  geom_polygon() +
  scale_fill_gradient(high = "green", low = "red", guide = "colorbar") +
  coord_equal() +
  theme() +
  ggtitle("Title")

# Data from http://thematicmapping.org/downloads/world_borders.php.
# Direct link: http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip
# Unpack and put the files in a dir 'data'
region_of_interest.fort <- fortify(region_of_interest, region = "score")
region_of_interest.fort$id <- as.numeric(region_of_interest.fort$id)
region_of_interest.fort$id <- region_of_interest.fort$id

idList <- unique(region_of_interest$GM_NAAM)

ggplot(randomMap.df, aes(map_id = id)) +
  geom_map(aes(fill = values), colour= "black", map =region_of_interest.fort) +
  expand_limits(x = region_of_interest.fort$long, y = region_of_interest.fort$lat) +
  scale_fill_gradient(high = "green", low = "red", guide = "colorbar") +
  geom_text(aes(label = id, x = Longitude, y = Latitude)) +
  coord_equal() +
  theme_bw() +
  ggtitle("Region of interest")
