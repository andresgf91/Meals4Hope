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
library(shinydashboard)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  
#tab.1 OVERVIEW ----------
  output$n_proyectos <- renderValueBox({
    icon_logo <- local_icon("logo.png")
   valueBox(value = nrow(data),subtitle = "Proyectos",
            icon=shiny::icon("door-open"),
            color='navy')
  })
  
  output$n_ninos <- renderValueBox({
    vector <- data$Q10 %>% as.numeric()
    
    apputils::valueBox(value = sum(vector, na.rm = T),
             subtitle = "Niños/Niñas Beneficiadas",
             icon = local_icon('children attended.png'),
             color='blue')
    
  })
  
  
  output$n_total_embarazadas_lactantes <- renderValueBox({
    embarazadas <- data$Q22_1_1 %>% as.numeric() %>% sum(na.rm = T)
    lactantes <- data$Q22_2_1 %>% as.numeric() %>% sum(na.rm = T)
    apputils::valueBox(value = embarazadas + lactantes ,
                       subtitle = "Mujeres Embarazadas o Lactantes",
                       icon = local_icon('pregnant and lactating women.png'),
                       color = "blue")
    
  })
  
  
  output$n_poblacion <- renderValueBox({
    ninos <- data$Q10 %>% as.numeric() %>% sum(na.rm = T)
    embarazadas <- data$Q22_1_1 %>% as.numeric()%>% sum(na.rm = T)
    lactantes <- data$Q22_2_1 %>% as.numeric()%>% sum(na.rm = T)
    apputils::valueBox(value = ninos+embarazadas+lactantes,
                       subtitle = "Total beneficiarios",
                       icon = local_icon("people supported.png",Width="70px"),
                       color = "blue")
    
  })
  
  output$n_estados <- renderValueBox({
    n_estados <- length(unique(data$Q2_1))
    apputils::valueBox(value = n_estados,
                       subtitle = "Estados",
                       icon = shiny::icon("map-marker-alt"),
                       color = "navy")
    
  })
  
  output$n_comidas <- renderValueBox({
    comidas <-  data$Q15 %>% as.numeric() %>% sum(na.rm = T)
    apputils::valueBox(value = scales::comma(comidas),
                       subtitle = "Comidas administradas semanalmente",
                       icon = local_icon("nutritious meals.png","60px"),
                       color = "light-blue")
    
  })
  

  
  
#tab.1 FICHAS PROYECTOS --------------------------
    temp.project <- reactive({
        data %>% filter(Q1 == input$select_project)
    })
    
    output$estado <- renderInfoBox({
        
        temp.data <- temp.project()
        apputils::infoBox(title = "Estado",
                value = temp.data$Q2_1[1],
                icon=icon("map-marked"),
                color='light-blue')
    })
    
    output$municipio <- renderInfoBox({
        
        temp.data <- temp.project()
        apputils::infoBox(title = "Municipio",
                value = temp.data$Q2_2[1],
                icon=icon("map-marked"),
                color='light-blue')
    })
    
    output$parroquia <- renderInfoBox({
        
        temp.data <- temp.project()
        apputils::infoBox(title = "Parroquia",
                value = temp.data$Q2_3[1],
                icon=icon("map-marked"),
                color='light-blue')
    })
    
    output$fecha_inicio <- renderValueBox({
        temp.data <- temp.project()
        valor <- paste(temp.data$Q5_1,temp.data$Q5_2)
        apputils::valueBox(value = valor,
                 subtitle = "Fecha de Inicio",
                 icon=icon("calendar-alt"),
                 color='navy')
    })
    
    output$n_voluntarios <- renderValueBox({
        temp.data <- temp.project()
        apputils::valueBox(value = as.numeric(temp.data$Q11),
                 subtitle = "Número de Voluntarios",
                 icon=local_icon('volunteers.png',"60px"),
                 color="blue")
    })
    
    output$tipo_proyecto <-  function(){
                     
        temp.data <- temp.project()                  
        
        
        temp.data$Q6 <- stri_replace_all_fixed(
          temp.data$Q6,'(huertos, gallinas, etc)',"")
        temp.data$Q6 <- stri_replace_all_fixed(
          temp.data$Q6,'(Por favor especifique en el recuadro abajo)',"")
        
        df <- strsplit(temp.data$Q6, split = ",") %>% as.data.frame()
        names(df) <- "Actividades Principales"
        
        df %>% knitr::kable("html") 
        #%>%
        #kable_styling("basic", full_width = F)
        
    }
    
    
    output$coordinadora <- renderValueBox({
      
      temp.data <- temp.project()
      
      nombre <- temp.data$Q9_1
      apellido <- temp.data$Q9_2
      
      apputils::valueBox(color='blue',
        value=paste0(nombre," \n",apellido),
        subtitle =
          HTML(
            "<b>Coordinador(a)</b> <button id=\"show_contacto_coordinadora\" type=\"button\" class=\"btn btn-default action-button\">Ver Contacto</button>"))
      
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
      apputils::valueBox(value = as.numeric(temp.data$Q10),
               subtitle = "Número de Niños(as)",
               icon=local_icon("children attended.png"),
               color='light-blue')
    })
    
    
    output$n_beneficiarios_embarazadas_lactantes <- renderValueBox({
      temp.data <- temp.project()
      
      embarazadas <- ifelse(is.na(as.numeric(temp.data$Q22_1_1)),
                      0,
                      as.numeric(temp.data$Q22_1_1))
      
      lactantes <- ifelse(is.na(as.numeric(temp.data$Q22_2_1)),
                      0,
                      as.numeric(temp.data$Q22_2_1))
      valor <- embarazadas+lactantes
      valor <- ifelse(valor>0,valor,"No Aplica")
      
      apputils::valueBox(value = valor,
               subtitle = "Número de mujeres embarazadas o lactantes",
               icon=local_icon("pregnant and lactating women.png"),
               color='light-blue')
    })
    
    output$n_beneficiarios_lactantes <- renderValueBox({
      temp.data <- temp.project()
      
      
      valor <- ifelse(is.na(as.numeric(temp.data$Q22_2_1)),
                      "No Aplica",
                      as.numeric(temp.data$Q22_2_1))
      
      
      apputils::valueBox(value = valor,
               subtitle = "Número de mujeres lactantes",
               icon=local_icon("pregnant and lactating women.png"),
               color='blue')
    })
    
    output$vene_map_proyectos <- renderLeaflet({
      
      require(leaflet.providers)
      leaflet(map_df) %>% 
          addProviderTiles(
            providers$OpenStreetMap.Mapnik,
            options = providerTileOptions(noWrap = F)) %>%
        addCircleMarkers(lng = ~lon, lat = ~lat,
                         popup = ~n_proyectos,radius = ~round(ifelse(n_proyectos>1,
                                                                     (log(n_proyectos)*10),
                                                                     (log(2)*12/2))),
                         label =  ~paste0("[",nombre_estado,"] ",
                                          "Numero de proyectos: ",
                                          n_proyectos))
})

})    
    