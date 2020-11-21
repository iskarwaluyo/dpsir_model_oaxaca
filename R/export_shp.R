
setwd("/home/iskar/Documents/PAPER_JOSEGARCIA/MAPA/data/raw_data/shape_ouput/agricola/")
writeOGR(ac_mapa_agricola, dsn = '.', layer = 'mapa_agricola', driver = "ESRI Shapefile")

setwd("/home/iskar/Documents/PAPER_JOSEGARCIA/MAPA/data/raw_data/shape_ouput/ganadera/")
writeOGR(ac_mapa_ganadera, dsn = '.', layer = 'mapa_ganadera', driver = "ESRI Shapefile")

setwd("/home/iskar/Documents/PAPER_JOSEGARCIA/MAPA/data/raw_data/shape_ouput/maderable/")
writeOGR(ac_mapa_maderable, dsn = '.', layer = 'mapa_maderable', driver = "ESRI Shapefile")