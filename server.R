#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
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
    
    output$tipo_proyecto <- renderText({
                     
        temp.data <- temp.project()                  
        temp.data$Q6
    }
    )
    
    
})
