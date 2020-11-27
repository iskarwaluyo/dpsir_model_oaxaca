
m3 <- leaflet(ac_mapa) %>%
  addMapPane("A", zIndex = 490) %>% #
  addMapPane("B", zIndex = 480) %>% # 
  addMapPane("C", zIndex = 470) %>% # 
  addMapPane("D", zIndex = 460) %>% # 
  
  addTiles() %>%
  addTiles(group = "Open Street Map") %>%
  addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 1,
              fillColor = ~pal(as.numeric(APM_2016)),
              label = ~paste0(NOMGEO, ": ", formatC(NOMGEO, big.mark = ","))) 

m3 <- m3 %>%  addPolygons(data = ac_mapa_maderable, stroke = FALSE, smoothFactor = 0.3,
                          options = pathOptions(pane = "A"),
                          fillOpacity = 1,
                          fillColor = ~pal_prod_maderable(as.numeric(APM_2016)),
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
                          group = "APROVECHAMIENTO MADERABLE",
                          labelOptions = labelOptions(
                            style = list("font-weight" = "normal", padding = "3px 8px"),
                            textsize = "15px",
                            direction = "auto"),
                          popup = ~pop_impact_maderable)

m3 <- m3 %>%  addPolygons(data = ac_mapa_maderable, stroke = FALSE, smoothFactor = 0.3,
                          options = pathOptions(pane = "B"),
                          fillOpacity = 1,
                          fillColor = ~pal_maderable(as.numeric(APNM_2016)),
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
                          group = "APROVECHAMIENTO NO MADERABLE",
                          labelOptions = labelOptions(
                            style = list("font-weight" = "normal", padding = "3px 8px"),
                            textsize = "15px",
                            direction = "auto"),
                          popup = ~pop_impact_maderable)

# CONTROL DE CAPAS
m3 <- m3 %>% addLayersControl(
  baseGroups = c("Open Street Map", "Toner", "Toner Lite"),
  overlayGroups = c("APROVECHAMIENTO MADERABLE", "APROVECHAMIENTO NO MADERABLE"),
  options = layersControlOptions(collapsed = FALSE)
)

m3  
