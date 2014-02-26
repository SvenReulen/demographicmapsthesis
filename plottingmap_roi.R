plottingmap_roi <- function(variablename, titlemap, colourhigh, colourlow){
  variablename = "score"
  colourhigh ="red"
  colourlow = "green"
  titlemap = "test"
  region_of_interest.fort <- fortify(region_of_interest, region = variablename)
  region_of_interest.fort$id <- as.numeric(region_of_interest.fort$id)
  region_of_interest.fort$id <- region_of_interest.fort$id

  ggplot(randomMap.df, aes(map_id = id)) +
    geom_map(aes(fill = values), colour= "black", map =region_of_interest.fort) +
    expand_limits(x = region_of_interest.fort$long, y = region_of_interest.fort$lat) +
    scale_fill_gradient(high = colourhigh, low = colourlow, guide = "colorbar") +
    geom_text(aes(label = id, x = Longitude, y = Latitude)) +
    coord_equal() +
    theme_bw() +
    ggtitle(titlemap)
}