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
  output$mapa <- renderLeaflet({
    
    m <-leaflet(ac_mapa) %>%
      addMapPane("A", zIndex = 490) %>% #
      addMapPane("B", zIndex = 480) %>% # 
      addMapPane("C", zIndex = 470) %>% # 
      addMapPane("D", zIndex = 460) %>% # 
      addMapPane("E", zIndex = 450) %>% #
      addMapPane("F", zIndex = 440) %>% # 
      addMapPane("G", zIndex = 430) %>% # 
      addMapPane("H", zIndex = 420) %>% # 
      addMapPane("I", zIndex = 410) %>% # 
      addMapPane("J", zIndex = 410) %>% # 
      
      addTiles() %>%
      addTiles(group = "Open Street Map") %>%
      addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
      addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
      addPolygons(stroke = FALSE, smoothFactor = 0.3, fillOpacity = 1,
                  fillColor = ~pal(as.numeric(CVE_MUN)),
                  label = ~paste0(NOMGEO, ": ", formatC(NOMGEO, big.mark = ","))) 
    
    m <- m %>%  addPolygons(data = ac_mapa_maderable, stroke = FALSE, smoothFactor = 0.3,
                            options = pathOptions(pane = "A"),
                            fillOpacity = .7,
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
                            popup = ~pop_maderable)
    
    m <- m %>%  addPolygons(data = ac_mapa_agricola, stroke = FALSE, smoothFactor = 0.3,
                            options = pathOptions(pane = "B"),
                            fillOpacity = .7,
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
                            popup = ~pop_agricola)
    
    m <- m %>%  addPolygons(data = ac_mapa_ganadera, stroke = FALSE, smoothFactor = 0.3,
                            options = pathOptions(pane = "D"),
                            fillOpacity = .7,
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
                            popup = ~pop_ganadera)
    
    # CONTROL DE CAPAS
    m <- m %>% addLayersControl(
      baseGroups = c("Open Street Map", "Toner", "Toner Lite"),
      overlayGroups = c("MADERABLE", "AGRÍCOLA", "GANADERA"),
      options = layersControlOptions(collapsed = FALSE)
    )
    
    
    
    m
    
  })
   
  # LOS PROXIES PERMITEN ENCENDER Y APAGAR ELEMENTOS EN R LEAFLET
  observe({
    proxy <- leafletProxy("mapa", data = ac_mapa_maderable)
    proxy %>% clearControls()
    if (input$leyenda) {
      proxy %>% 
        addLegend("topleft", group = "MADERABLE", pal = pal_maderable, values = ~VPM_2016, opacity = 1.0) %>%
        addLegend("topleft", group = "MADERABLE", pal = pal_maderable, values = ~VPM_2015, opacity = 1.0)
    }
  })
  
  observe({
    proxy <- leafletProxy("mapa", data = ac_mapa_agricola)
    proxy %>% clearControls()
    if (input$leyenda) {
      proxy %>% 
        addLegend("topleft", group = "AGRÍCOLA", pal = pal_agricola, values = ~as.numeric(VPC_2016), opacity = 1.0)
    }
  })  
  
  observe({
    proxy <- leafletProxy("mapa", data = ac_mapa_ganadera)
    proxy %>% clearControls()
    if (input$leyenda) {
      proxy %>% 
        addLegend("topleft", group = "GANADERA", pal = pal_ganadera, values = ~as.numeric(VPT_2016), opacity = 1.0)
    }
  })
  
}