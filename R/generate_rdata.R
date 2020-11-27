# CARGAR LIBRERIAS UTILIZADAS DE R
library(sf)
library(sp)
library(geojsonio)
library(rgdal)
library(rmapshaper)
library(rio)
library(dplyr)
library(plyr)
library(ggplot2)
library(maptools)
library(raster)
library(corrplot)
library(reshape2)
library(ggcorrplot)
library(rgeos)

ac_mapa <- readOGR("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/geojson/oax_mun.geojson")


# LECTURA DE SHAPE BASE DE ÁREAS DE CONTROL DE GITHUB
# FUENTE: ACTUALIZACIÓN DEL MARCO SENSAL MADERABLE 2016

apm <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/maderable/apm.csv")
apnm <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/maderable/apnm.csv")
pm <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/maderable/pm.csv")
pnm <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/maderable/pnm.csv")
vpm <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/maderable/vpm.csv")
vpnm <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/maderable/vpnm.csv")

# CONVERTIR TODOS LOS ENCABEZADOS A MAYUSCULAS
colnames(apm) <- toupper(colnames(apm)) 
colnames(apnm) <- toupper(colnames(apnm))
colnames(pm) <- toupper(colnames(pm))
colnames(pnm) <- toupper(colnames(pnm))
colnames(vpm) <- toupper(colnames(vpm))
colnames(vpnm) <- toupper(colnames(vpnm))

datos_maderable <- cbind(apm, apnm, pm, pnm, vpm, vpnm)

datos_maderable <- datos_maderable[,-2]

ac_mapa <- ms_simplify(ac_mapa, keep = 0.05)

ac_mapa_maderable <- merge(ac_mapa, datos_maderable, by = "CVEGEO", all.x = TRUE, all.y = TRUE)

# LECTURA DE INDICADORES DE LA PRODUCCIÓN AGRICOLA DE GITHUB
# FUENTE: ACTUALIZACIÓN DEL MARCO SENSAL AGROPECUARIO 2016

scc <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/agricola/scc.csv")
ssc <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/agricola/ssc.csv")
vpc <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/agricola/vpc.csv")
sct <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/agricola/sct.csv")
ssr <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/agricola/ssr.csv")
sst <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/agricola/sst.csv")

# CONVERTIR TODOS LOS ENCABEZADOS A MAYUSCULAS
colnames(scc) <- toupper(colnames(scc)) 
colnames(ssc) <- toupper(colnames(ssc))
colnames(vpc) <- toupper(colnames(vpc))
colnames(ssr) <- toupper(colnames(ssr))
colnames(sst) <- toupper(colnames(sst))

datos_agricola <- cbind(scc, ssc, vpc, ssr, sst)

datos_agricola <- datos_agricola[,-2]

ac_mapa_agricola <- merge(ac_mapa, datos_agricola, by = "CVEGEO", all.x = TRUE, all.y = TRUE)

# LECTURA DE INDICADORES DE LA PRODUCCIÓN AGRICOLA DE GITHUB
# FUENTE: ACTUALIZACIÓN DEL MARCO SENSAL AGROPECUARIO 2016

pt <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/ganadera/pt.csv")
vpt <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/ganadera/vpt.csv")

# CONVERTIR TODOS LOS ENCABEZADOS A MAYUSCULAS
colnames(pt) <- toupper(colnames(pt)) 
colnames(vpt) <- toupper(colnames(vpt))

datos_ganadera <- cbind(pt, vpt)

datos_ganadera <- datos_ganadera[,-2]

ac_mapa_ganadera <- merge(ac_mapa, datos_ganadera, by = "CVEGEO", all.x = TRUE, all.y = TRUE)

# LECTURA DE INDICADORES DE LA POBLACIÓN



pob <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/pob.csv")

# CONVERTIR TODOS LOS ENCABEZADOS A MAYUSCULAS
colnames(pob) <- toupper(colnames(pob)) 

datos_pob <- cbind(pob)

ac_mapa_pob <- merge(ac_mapa, datos_pob, by = "CVEGEO", all.x = TRUE, all.y = TRUE)

# PSA

psa <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/psa.csv")

# CONVERTIR TODOS LOS ENCABEZADOS A MAYUSCULAS
colnames(psa) <- toupper(colnames(psa)) 

psa_x <- ddply(psa, .(CVEGEO), summarise, sum = sum(SUP_MUN_ZE))

datos_psa <- cbind(psa_x)

ac_mapa_psa <- merge(ac_mapa, psa_x, by = "CVEGEO", all.x = TRUE, all.y = TRUE)


# DATOS DE AUTOCORRELACIONES

autocorr1 <- import("https://raw.githubusercontent.com/iskarwaluyo/dpsir_model_oaxaca/main/data/raw_data/csv/autocorr_2016.csv")

ac_mapa_autocorr <- merge(ac_mapa, autocorr1, by = "CVEGEO", all.x = TRUE, all.y = TRUE)


# CREAR ARCHIVOS TIPO RData PARA ALMACENAR LOS RESULTADOS DEL PROCESAMIENTO DE LOS DATOS
setwd("/home/iskar/Documents/PAPER_JOSEGARCIA/dpsir_model_oaxaca/data/Rdata/")

save(ac_mapa, ac_mapa_maderable, ac_mapa_agricola, ac_mapa_ganadera, ac_mapa_autocorr, ac_mapa_pob, ac_mapa_psa, file = "carto.RData")
save(apm, apnm, pm, pnm, vpm, vpnm, scc, ssc, vpc, ssr, sst, pt, vpt, pob, psa, autocorr1, file = "datos.RData")


# REGRESAR AL ENTORNO GENERAL LOCAL
setwd("/home/iskar/Documents/PAPER_JOSEGARCIA/dpsir_model_oaxaca/data")
