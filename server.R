#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(kableExtra)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$n_proyectos <- renderValueBox({
    
   valueBox(value = nrow(data),subtitle = "Numero de Proyectos")
    
    
  })
  
  output$n_ninos <- renderValueBox({
    
    vector <- data$Q10 %>% as.numeric()
    vector[which(is.na(vector))] <- 0
    
    
    valueBox(value = sum(vector),subtitle = "Ninos/Ninas Beneficiadas")
    
  })
  
  
#tab.1 OVERVIEW --------------------------
    temp.project <- reactive({
        data %>% filter(Q1 == input$select_project)
    })
    
    output$estado <- renderInfoBox({
        
        temp.data <- temp.project()
        infoBox(title = "Estado",
                value = temp.data$Q2_1[1],
                icon=icon("map-marked"))
    })
    
    output$municipio <- renderInfoBox({
        
        temp.data <- temp.project()
        infoBox(title = "Municipio",
                value = temp.data$Q2_2[1],
                icon=icon("map-marked"))
    })
    
    output$parroquia <- renderInfoBox({
        
        temp.data <- temp.project()
        infoBox(title = "Parroquia",
                value = temp.data$Q2_3[1],
                icon=icon("map-marked"))
    })
    
    output$fecha_inicio <- renderValueBox({
        temp.data <- temp.project()
        valor <- paste(temp.data$Q5_1,temp.data$Q5_2)
        valueBox(value = valor,
                 subtitle = "Fecha de Inicio",
                 icon=icon("calendar-alt"))
    })
    
    output$n_voluntarios <- renderValueBox({
        temp.data <- temp.project()
        valueBox(value = as.numeric(temp.data$Q11),
                 subtitle = "Número de Voluntarios",
                 icon=icon("hands-helping"))
    })
    
    output$tipo_proyecto <-  function(){
                     
        temp.data <- temp.project()                  
        
        df <- strsplit(temp.data$Q6, split = ",") %>% as.data.frame()
        names(df) <- "Actividades Principales"
        
        df %>% knitr::kable("html") %>%
          kable_styling("basic", full_width = F)
        
    }
    
    
    output$coordinadora <- renderValueBox({
      
      temp.data <- temp.project()
      
      nombre <- temp.data$Q9_1
      apellido <- temp.data$Q9_2
      
      valueBox(value=paste(nombre,apellido),
               subtitle =  HTML("<b>Coordinador(a)</b> <button id=\"show_contacto_coordinadora\" type=\"button\" class=\"btn btn-default action-button\">Ver Contacto</button>"))
      
    })
    
    
    observeEvent(input$show_contacto_coordinadora, {
      temp.data <- temp.project()
      isolate(temp.data <- temp.data %>% select(Q9_1,Q9_2,Q9_3,Q9_4) %>%
                mutate(Q9_3 = paste0("0",as.character(as.numeric(Q9_3)))) %>%
                mutate(Q9_3 = paste0("(",
                                     stri_sub(Q9_3,1,4),
                                     ") ",
                                     stri_sub(Q9_3,5,7),
                                     "-",
                                     stri_sub(Q9_3,8))) %>% 
                rename("Nombre"=Q9_1,
                       "Apellido"=Q9_2,
                       "Telefono"=Q9_3,
                       "Email"=Q9_4))
      
      showModal(modalDialog(size = 'm',
                            title = "Contacto del coordinador(a)",
                            renderTable(temp.data),
                            easyClose = TRUE))
      
    })
    
    
    output$n_beneficiarios_kids <- renderValueBox({
      temp.data <- temp.project()
      valueBox(value = as.numeric(temp.data$Q10),
               subtitle = "Número de Ninos(as)",
               icon=icon("child"))
    })
    
    
    output$n_beneficiarios_embarazadas <- renderValueBox({
      temp.data <- temp.project()
      
      valor <- ifelse(is.na(as.numeric(temp.data$Q22_1_1)),
                      "No Aplica",
                      as.numeric(temp.data$Q22_1_1))
      
      valueBox(value = valor,
               subtitle = "Número de mujeres embarazadas",
               icon=icon("child"))
    })
    
    output$n_beneficiarios_lactantes <- renderValueBox({
      temp.data <- temp.project()
      
      
      valor <- ifelse(is.na(as.numeric(temp.data$Q22_2_1)),
                      "No Aplica",
                      as.numeric(temp.data$Q22_2_1))
      
      
      valueBox(value = valor,
               subtitle = "Número de mujeres lactantes",
               icon=icon("child"))
    })
    
    output$vene_map_proyectos <- renderLeaflet({
      
      
      leaflet(map_df) %>%
        addProviderTiles(
          providers$OpenStreetMap.Mapnik,
          options = providerTileOptions(noWrap = TRUE)) %>%
        addCircleMarkers(lng = ~lon, lat = ~lat,
                         popup = ~n_proyectos,radius = ~round(ifelse(n_proyectos>1,
                                                                     (log(n_proyectos)*10),
                                                                     (log(2)*12/2))),
                         label =  ~paste0("[",nombre_estado,"] ",
                                          "Numero de proyectos: ",
                                          n_proyectos))
})

})    
    