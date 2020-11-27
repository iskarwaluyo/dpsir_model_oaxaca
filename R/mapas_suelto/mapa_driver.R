
m0 <- leaflet(ac_mapa) %>%
  addMapPane("A", zIndex = 490) %>% #
  addMapPane("B", zIndex = 480) %>% # 
  addMapPane("C", zIndex = 470) %>% # 
  addMapPane("D", zIndex = 460) %>% # 
  
  addTiles() %>%
  addTiles(group = "Open Street Map") %>%
  addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 1,
              fillColor = ~pal(as.numeric(CVE_MUN)),
              label = ~paste0(NOMGEO, ": ", formatC(NOMGEO, big.mark = ","))) 

m0 <- m0 %>%  addPolygons(data = ac_mapa_maderable, stroke = FALSE, smoothFactor = 0.3,
                          options = pathOptions(pane = "A"),
                          fillOpacity = 1,
                          fillColor = ~pal_maderable(as.numeric(VPM_2016)),
                          opacity = .3,
                          weight = 1,
                          color = "#4D4D4D",
                          dashArray = "2",
                          highlight = highlightOptions(
                            weight = 1,
                            color = "#4D4D4D",
                            fillOpacity = 0.1,
                            dashArray = "2",
                            bringToFront = TRUE),
                          group = "MADERABLE",
                          labelOptions = labelOptions(
                            style = list("font-weight" = "normal", padding = "3px 8px"),
                            textsize = "15px",
                            direction = "auto"),
                          popup = ~pop_driver_maderable)

m0 <- m0 %>%  addPolygons(data = ac_mapa_maderable, stroke = FALSE, smoothFactor = 0.3,
                          options = pathOptions(pane = "B"),
                          fillOpacity = 1,
                          fillColor = ~pal_no_maderable(as.numeric(VPNM_2016)),
                          opacity = .3,
                          weight = 1,
                          color = "#4D4D4D",
                          dashArray = "2",
                          highlight = highlightOptions(
                            weight = 1,
                            color = "#4D4D4D",
                            fillOpacity = 0.1,
                            dashArray = "2",
                            bringToFront = TRUE),
                          group = "NO MADERABLE",
                          labelOptions = labelOptions(
                            style = list("font-weight" = "normal", padding = "3px 8px"),
                            textsize = "15px",
                            direction = "auto"),
                          popup = ~pop_driver_no_maderable)

m0 <- m0 %>%  addPolygons(data = ac_mapa_agricola, stroke = FALSE, smoothFactor = 0.3,
                          options = pathOptions(pane = "C"),
                          fillOpacity = 1,
                          fillColor = ~pal_agricola(as.numeric(VPC_2016)),
                          opacity = .3,
                          weight = 1,
                          color = "#4D4D4D",
                          dashArray = "2",
                          highlight = highlightOptions(
                            weight = 1,
                            color = "#4D4D4D",
                            fillOpacity = 0.1,
                            dashArray = "2",
                            bringToFront = TRUE),
                          group = "AGRÍCOLA",
                          labelOptions = labelOptions(
                            style = list("font-weight" = "normal", padding = "3px 8px"),
                            textsize = "15px",
                            direction = "auto"),
                          popup = ~pop_driver_agricola)

m0 <- m0 %>%  addPolygons(data = ac_mapa_ganadera, stroke = FALSE, smoothFactor = 0.3,
                          options = pathOptions(pane = "D"),
                          fillOpacity = 1,
                          fillColor = ~pal_ganadera(as.numeric(VPT_2016)),
                          opacity = .3,
                          weight = 1,
                          color = "#4D4D4D",
                          dashArray = "2",
                          highlight = highlightOptions(
                            weight = 1,
                            color = "#4D4D4D",
                            fillOpacity = 0.1,
                            dashArray = "2",
                            bringToFront = TRUE),
                          group = "GANADERA",
                          labelOptions = labelOptions(
                            style = list("font-weight" = "normal", padding = "3px 8px"),
                            textsize = "15px",
                            direction = "auto"),
                          popup = ~pop_driver_ganadera)

# CONTROL DE CAPAS
m0 <- m0 %>% addLayersControl(
  baseGroups = c("Open Street Map", "Toner", "Toner Lite"),
  overlayGroups = c("MADERABLE", "NO MADERABLE", "AGRÍCOLA", "GANADERA"),
  options = layersControlOptions(collapsed = FALSE)
)

m0