function(input, output, session) {
  
  # GENERAR TABLAS PARA VISUALIZAR DATOS
  # VISUALIZACIÓN DE DATOS 1
  
  output$tabla1 = DT::renderDataTable({
    data <- datos_maderable
    DT::datatable(
      extensions = 'Buttons',
      options = list(
        dom = 'Bfrtip',
        buttons = c('csv')
      ),
      {
        if (input$NOMBRE != "Todos") {
          data <- data[data$NOMBRE == input$NOMBRE,]
        }
        data
      }
    )
  })
  
  # VISUALIZACIÓN DE DATOS 2
  output$tabla2 = DT::renderDataTable({
    data <- datos_agricola
    DT::datatable(
      extensions = 'Buttons',
      options = list(
        dom = 'Bfrtip',
        buttons = c('csv')
      ),
      {
        if (input$NOMBRE != "Todos") {
          data <- data[data$NOMBRE == input$NOMBRE,]
        }
        data
      }
    )
  })
  
  # VISUALIZACIÓN DE DATOS 3
  output$tabla3 = DT::renderDataTable({
    data <- datos_ganadera
    DT::datatable(
      extensions = 'Buttons',
      options = list(
        dom = 'Bfrtip',
        buttons = c('csv')
      ),
      {
        if (input$NOMBRE != "Todos") {
          data <- data[data$NOMBRE == input$NOMBRE,]
        }
        data
      }
    )
  })
  
  # GENERAR MAPA
  output$mapa_drivers <- renderLeaflet({
    
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
    
  })
  
  output$mapa_pressure <- renderLeaflet({
    
    m1 <- leaflet(ac_mapa) %>%
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
    
    m1 <- m1 %>%  addPolygons(data = ac_mapa_agricola, stroke = FALSE, smoothFactor = 0.3,
                              options = pathOptions(pane = "A"),
                              fillOpacity = .7,
                              fillColor = ~pal_agricola(as.numeric(SSC_2016)),
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
                              group = "SUPERFICIE SEMBRADA",
                              labelOptions = labelOptions(
                                style = list("font-weight" = "normal", padding = "3px 8px"),
                                textsize = "15px",
                                direction = "auto"),
                              popup = ~pop_pressure_agricola)
    
    # CONTROL DE CAPAS
    m1 <- m1 %>% addLayersControl(
      baseGroups = c("Open Street Map", "Toner", "Toner Lite"),
      overlayGroups = c("SUPERFICIE SEMBRADA"),
      options = layersControlOptions(collapsed = FALSE)
    )
    
    m1
    
  })
  
  output$mapa_state <- renderLeaflet({

    m2 <- leaflet(ac_mapa) %>%
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
    
    m2 <- m2 %>%  addPolygons(data = ac_mapa_agricola, stroke = FALSE, smoothFactor = 0.3,
                              options = pathOptions(pane = "A"),
                              fillOpacity = .7,
                              fillColor = ~pal_agricola(as.numeric(SSC_2016)),
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
                              group = "SUPERFICIE SEMBRADA",
                              labelOptions = labelOptions(
                                style = list("font-weight" = "normal", padding = "3px 8px"),
                                textsize = "15px",
                                direction = "auto"),
                              popup = ~pop_agricola)
    
    # CONTROL DE CAPAS
    m2 <- m2 %>% addLayersControl(
      baseGroups = c("Open Street Map", "Toner", "Toner Lite"),
      overlayGroups = c("SUPERFICIE SEMBRADA"),
      options = layersControlOptions(collapsed = FALSE)
    )
    
    m2
    
  })
  
  output$mapa_impact <- renderLeaflet({
  
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
    
  })
    
    

  output$mapa_response <- renderLeaflet({

    m4 <- leaflet(ac_mapa) %>%
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
    
    
    m4 <- m4 %>%  addPolygons(data = ac_mapa_agricola, stroke = FALSE, smoothFactor = 0.3,
                              options = pathOptions(pane = "A"),
                              fillOpacity = .7,
                              fillColor = ~pal_agricola(as.numeric(SSC_2016)),
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
                              group = "SUPERFICIE SEMBRADA",
                              labelOptions = labelOptions(
                                style = list("font-weight" = "normal", padding = "3px 8px"),
                                textsize = "15px",
                                direction = "auto"),
                              popup = ~pop_agricola)
    
    
    
    # CONTROL DE CAPAS
    m4 <- m4 %>% addLayersControl(
      baseGroups = c("Open Street Map", "Toner", "Toner Lite"),
      overlayGroups = c("SUPERFICIE SEMBRADA"),
      options = layersControlOptions(collapsed = FALSE)
    )
    
    m4
    
  })
    
  # LOS PROXIES PERMITEN ENCENDER Y APAGAR ELEMENTOS EN R LEAFLET
  observe({
    proxy <- leafletProxy("mapa_drivers", data = ac_mapa_maderable)
    proxy %>% clearControls()
    if (input$leyenda) {
        addLegend("topleft", group = "MADERABLE", pal = pal_maderable, values = ~VPM_2016, opacity = 1.0) %>%
        addLegend("topleft", group = "NO MADERABLE", pal = pal__no_maderable, values = ~VPNM_2016, opacity = 1.0) %>%
        addLegend("topleft", group = "AGRÍCOLA", pal = pal_agricola, values = ~VPC_2016, opacity = 1.0)%>%
        addLegend("topleft", group = "GANADERA", pal = pal_ganadera, values = ~VPT_2016, opacity = 1.0)
    }
  })
  
  observe({
    proxy <- leafletProxy("mapa_drivers", data = ac_mapa_agricola)
    proxy %>% clearControls()
    if (input$leyenda) {
      proxy %>% 
        addLegend("topleft", group = "AGRÍCOLA", pal = pal_agricola, values = ~as.numeric(VPC_2016), opacity = 1.0)
    }
  })  
  
  observe({
    proxy <- leafletProxy("mapa_drivers", data = ac_mapa_ganadera)
    proxy %>% clearControls()
    if (input$leyenda) {
      proxy %>% 
        addLegend("topleft", group = "GANADERA", pal = pal_ganadera, values = ~as.numeric(VPT_2016), opacity = 1.0)
    }
  })
  
}