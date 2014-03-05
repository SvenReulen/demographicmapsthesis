plottingmap <- function(variablename, titlemap, colourhigh, colourlow, namecolour){
  mun_neth.fort <- fortify(mun_neth, region = variablename)
  mun_neth.fort$id <- as.numeric(mun_neth.fort$id)
  mun_neth.fort$id <- mun_neth.fort$id
  ggplot(data = mun_neth.fort, aes(x = long, y = lat, fill = id, group = group)) +
    geom_polygon() +
    scale_fill_gradient(namecolour, high = colourhigh, low = colourlow, guide = "colourbar") +
    coord_equal() +
    theme() +
    ggtitle(titlemap)
}