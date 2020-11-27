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
library(OneR)

load(url("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/Rdata/datos.RData"))
load(url("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/Rdata/carto.RData"))
load(url("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/Rdata/autocorrelaciones.RData"))


bins_vpm <- c(0, 2, 10, 50, 250, 500, 1000, 2000, 4000, 8000, 16000, 32000, 64000, 128000, Inf)
pal_vpm <- colorBin( palette="viridis", domain = ac_mapa_maderable$VPM_2016, bins = bins_vpm)

bins_vpnm <- c(0, 2, 10, 50, 250, 500, 1000, 2000, 4000, Inf)
pal_vpnm <- colorBin( palette="viridis", domain = ac_mapa_maderable$VPNM_2016, bins = bins_vpnm)

bins_vpc <- c(0, 500, 2500, 12500, 62500, 312500, Inf)
pal_vpc <- colorBin( palette="viridis", domain = ac_mapa_agricola$VPC_2016, bins = bins_vpc)

bins_vpt <- c(0, 100, 500, 2500, 12500, 62500, 312500, Inf)
pal_vpt <- colorBin( palette="viridis", domain = ac_mapa_ganadera$VPT_2016, bins = bins_vpt)

bins_pob <- c(50, 250, 500, 1000, 2000, 4000, 8000, 16000, 32000, 64000, 128000, Inf)
pal_pob <- colorBin(palette = "viridis", domain = ac_mapa_pob$POB_2010, bins = bins_pob)

bins_psa <- c(0, 100, 500, 2500, 12500, 62500, Inf)
pal_psa <- colorBin(palette = "viridis", domain = ac_mapa_psa$sum, bins = bins_pob)

pal_prod_maderable <- colorBin(palette="viridis", domain = ac_mapa_maderable$APM_2016, bins = bins_vpm)
pal_prod_no_maderable <- colorBin(palette="viridis", domain = ac_mapa_maderable$APNM_2016, bins = bins_vpnm)

pal_autocorr <- colorBin( palette="magma", domain = ac_mapa_autocorr$VPT_LISA_CL, bins = bins_autocorr)



bins_pct <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
bins_autocorr <- c(0,1,2,3,4)

azul_a <- rgb(1/255, 7/255, 255/255, 1)
azul_b <- rgb(177/255, 209/255, 230/255, 1)
blanco <- rgb(255/255, 255/255, 255/255, 1)
rojo_a <- rgb(250/255, 112/255, 105/255, 1)
rojo_b <- rgb(255/255, 0/255, 0/255, 1)

geoda_colors <- c(azul_a, azul_b, blanco, rojo_a, rojo_b)



# PALETA DE COLORES

pal <- colorFactor(c("white", "red", "blue", "pink", "grey"), 0:4)
palb <- colorFactor( palette="Spectral", 1:7)


#pal_0b <- colorBin( palette="Set1", domain = autocorr$LISA_CLdef, bins = bins_autocorr)
#pal_0c <- colorBin( palette="heat", domain = autocorr$LISA_CLdeg, bins = bins_autocorr)

#pal_1 <- colorBin( palette="magma", domain = as.numeric(as.character(ac_mapa_ma@data$X2016)), bins = bins_superficie)
#pal_2 <- colorNumeric( palette= "YlGn", domain=ac_mapa@data$PCT_FORESTAL, na.color="transparent")
#pal_3 <- colorNumeric( palette="YlOrBr", domain=ac_mapa@data$PCT_AGRICOLA, na.color="transparent")
#pal_4 <- colorNumeric( palette="YlOrRd", domain=ac_mapa@data$PCT_PECUARIO, na.color="transparent")

# k-means only works with numerical variables,
# so don't give the user the option to select
# a categorical variable
#vars <- colnames(matriz_correlacion)

# POP-UPS MADERABLE

pop_driver_maderable <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                               "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                               "<b><br/> VALOR DE PRODUCCIÓN MADERABLE: </b>", ac_mapa_maderable$VPM_2016)

pop_driver_no_maderable <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                                  "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                                  "<b><br/> VALOR DE PRODUCCIÓN MADERABLE: </b>", ac_mapa_maderable$VPNM_2016)

pop_driver_agricola <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                              "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                              "<b><br/> VALOR DE PRODUCCIÓN DE CULTIVO PRINCIPAL: </b>", ac_mapa_agricola$VPC_2016)

pop_driver_ganadera <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                              "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                              "<b><br/> VALOR DE PRODUCCIÓN DE GANADERA: </b>", ac_mapa_ganadera$VPT_2016,
                              "<b><br/> VOLUMEN DE PRODUCCIÓN GANADERA: </b>", ac_mapa_ganadera$PT_2016)


pop_driver_poblacion <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                              "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                              "<b><br/> POBLACIÓN: </b>", ac_mapa_pob$POB_2010)

# POP-UPS PRESSURE

pop_pressure_agricola <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                                "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                                "<b><br/> SUPERFICIE SEMBRADA: </b>", ac_mapa_agricola$SSC_2016)

# POP-UPS STATE

pop_state_agricola <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                             "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                             "<b><br/> SUPERFICIE SEMBRADA: </b>", ac_mapa_agricola$SSC_2016)

# POP-UPS IMPACT


pop_impact_maderable <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                               "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                               "<b><br/> VALOR DE PRODUCCIÓN MADERABLE: </b>", ac_mapa_maderable$VPM_2016)

pop_impact_no_maderable <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                                  "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                                  "<b><br/> VALOR DE PRODUCCIÓN NO-MADERABLE: </b>", ac_mapa_maderable$VPNM_2016)

pop_impact_agricola <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                                  "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                                  "<b><br/> VALOR DE PRODUCCIÓN AGRÍCOLA: </b>", ac_mapa_agricola$VPC_2016)

pop_impact_ganadera <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                                 "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                                 "<b><br/> VALOR DE PRODUCCIÓN GANADERA: </b>", ac_mapa_ganadera$VPT_2016)

# POP-UPS RESPONSE

pop_response <- paste0("<b><br/> MUNICIPIO: </b>", ac_mapa$NOMGEO,
                       "<b><br/> SUPERFICIE: </b>", ac_mapa$AREA,
                       "<b><br/> SUPERFICE ELEGIBLE PARA PSA: </b>", ac_mapa_psa$sum)
