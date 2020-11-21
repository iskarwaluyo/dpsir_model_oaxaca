# CARGAR LIBRERIAS UTILIZADAS DE R
library(data.table)
library(curl)
library(devtools)
library(rio)
library(shiny)
library(shinythemes)
library(DT)
library(leaflet)
library(rgdal)
library(sf)
library(plyr)
library(DBI)
library(dplyr)
library(sf)
library(corrplot)
library(car)
library(ggplot2)
library(curl)
library(geojsonio)
library(reshape2)
library(ggcorrplot)
library(colorspace)
library(revealjs)
library(ggpmisc)
library(magrittr)

setwd("/home/iskar/Documents/PAPER_JOSEGARCIA/MAPA/data/Rdata/")
load("carto.RData")
load("datos.RData")

bins_vpm <- c(0, 2, 10, 50, 250, Inf)
bins_vpc <- c(0, 500, 2500, 12500, 62500, 312500, Inf)
bins_vpt <- c(0, 100, 500, 2500, 12500, 62500, 312500, Inf)
bins_pct <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
bins_autocorr <- c(0,1,2,3,4)

# PALETA DE COLORES

pal <- colorFactor(c("white", "red", "blue", "green", "grey"), 0:4)
palb <- colorFactor( palette="Spectral", 1:7)

pal_maderable <- colorBin( palette="viridis", domain = ac_mapa_maderable$VPM_2016, bins = bins_vpm)
pal_agricola <- colorBin( palette="magma", domain = ac_mapa_agricola$VPC_2016, bins = bins_vpc)
pal_ganadera <- colorBin( palette="YlOrBr", domain = ac_mapa_ganadera$VPT_2016, bins = bins_vpt)

#pal_0a <- colorBin( palette="Set1", domain = autocorr$LISA_CL, bins = bins_autocorr)
#pal_0b <- colorBin( palette="Set1", domain = autocorr$LISA_CLdef, bins = bins_autocorr)
#pal_0c <- colorBin( palette="Set1", domain = autocorr$LISA_CLdeg, bins = bins_autocorr)

#pal_1 <- colorBin( palette="magma", domain = as.numeric(as.character(ac_mapa_ma@data$X2016)), bins = bins_superficie)
#pal_2 <- colorNumeric( palette= "YlGn", domain=ac_mapa@data$PCT_FORESTAL, na.color="transparent")
#pal_3 <- colorNumeric( palette="YlOrBr", domain=ac_mapa@data$PCT_AGRICOLA, na.color="transparent")
#pal_4 <- colorNumeric( palette="YlOrRd", domain=ac_mapa@data$PCT_PECUARIO, na.color="transparent")
#pal_5 <- colorFactor( palette="Spectral", domain = serie_3@data$Clase)
#pal_6 <- colorFactor( palette="Spectral", domain = serie_6@data$Clase)
#pal_7 <- colorBin( palette="YlOrRd", domain = as.numeric(as.character(cambios_usv_ac@data$X._PVP)), bins = bins_pct) 
#pal_8 <- colorFactor( palette="Spectral", domain = cambios_usv@data$tipo_cambi)
#pal_9 <- colorBin( palette="YlOrRd", domain = as.numeric(as.character(autocorr_ac@data$P_AT_AT_S)), bins = bins_pct) 

# k-means only works with numerical variables,
# so don't give the user the option to select
# a categorical variable
#vars <- colnames(matriz_correlacion)

# POP UPS

pop_maderable <- paste0("<b><br/> VALOR DE PRODUCCIÓN MADERABLE: </b>", ac_mapa_maderable$VPM_2016,
                      "<b><br/> VALOR DE PRODUCCIÓN NO MADERABLE: </b>", ac_mapa_maderable$VPNM_2016)


pop_agricola <- paste0("<b><br/> VALOR DE PRODUCCIÓN DE CULTIVO PRINCIPAL: </b>", ac_mapa_agricola$VPC_2016,
                        "<b><br/> SUPERFICIE COSECHADA: </b>", ac_mapa_agricola$SCC_2016)

pop_ganadera <- paste0("<b><br/> VALOR DE PRODUCCIÓN DE GANADERA: </b>", ac_mapa_ganadera$VPT_2016,
                       "<b><br/> VOLUMEN DE PRODUCCIÓN GANADERA: </b>", ac_mapa_ganadera$PT_2016)
