
# ----- LOAD PACKAGES ---------
library(shinydashboard)
library(shiny)
library(shinyWidgets)
library(readxl)
library(pander)
library(scales)
library(lubridate)
library(ggplot2)
library(hrbrthemes)
library(dplyr)
library(tidyr)
library(viridis)
library(shinyBS)
library(plotly)
library(streamgraph)
library(DT)
library(leaflet)
library(stringi)
library(dashboardthemes)
#library(shiny.semantic)
#library(semantic.dashboard)
#library(stringi)
#library(shinythemes)


#-----HEADER ------ 
header <- dashboardHeader()

# anchor <- tags$a(href='https://www.meals4hope.org',
#                  tags$img(src='Picture2.png', height='45', width='16'))
# 
# header$children[[2]]$children <- tags$div(anchor,
#                                           class = 'name')

#-----SIDEBAR------ 
sidebar <- dashboardSidebar(collapsed = TRUE,
  sidebarMenu(
    menuItem(
        "Program Overview",
        tabName = "overview",
        icon = icon("dashboard")
    ),
    menuItem(
        text = "Fichas de Proyectos",
        tabName = "fichas_proyecto",
        icon = icon("list-ol")
    )
))





tab.1 <- tabItem(tabName = "overview",
                 fluidPage(titlePanel("General Overview"),theme = "superhero",
                           fluidRow(
                             column(
                               width = 2,
                               valueBoxOutput("n_proyectos", width = 12),
                               valueBoxOutput("n_estados", width = 12),
                               valueBoxOutput("n_comidas", width = 12)
                               
                             ),
                             column(
                               width = 2,
                               valueBoxOutput("n_poblacion", width = 12),
                               valueBoxOutput("n_ninos", width = 12),
                               valueBoxOutput("n_total_embarazadas_lactantes", width = 12)
                             ),
                             column(width = 8,
                                    box(title = "Mapa - Número de Proyectos por Estado",
                                        width = NULL,
                                        background = "navy",
                                        leafletOutput(height = 600,
                                      "vene_map_proyectos"
                                    )))
                           )))

                             
                       

tab.2 <-  tabItem(tabName = "fichas_proyecto",
                  fluidPage(
                    titlePanel('Información General por Proyecto'),
                    fluidRow(
                      selectInput(
                        'select_project',
                        "Seleccione un proyecto:",
                        choices = sort(unique(data$Q1)),
                        width = 800,
                        selected = "Apoyo A Mujeres Embarazadas Y Lactantes - Zea"
                      )),
                      
                      fluidRow(
                               infoBoxOutput("estado", width = 4),
                               infoBoxOutput("municipio", width = 4),
                               infoBoxOutput("parroquia", width = 4)),
                    fluidRow(
                        column(width=4,
                               valueBoxOutput("n_beneficiarios_kids",width = NULL),
                               valueBoxOutput("n_beneficiarios_embarazadas_lactantes",width=NULL)
                               ),
                        column(width=4,
                      valueBoxOutput("n_voluntarios",width = NULL),
                      valueBoxOutput("coordinadora",width = NULL))
                      ,
                      column(width=4,
                             valueBoxOutput("fecha_inicio",width = NULL),
                             box(tableOutput("tipo_proyecto"),width=NULL,background = "navy",height = 200)
                             )
                      
                    ))
                  )

body <- dashboardBody(tags$head(tags$style(HTML('
  .navbar-custom-menu>.navbar-nav>li>.dropdown-menu {
  width:600px;
  }
    /* body */
    .content-wrapper, .right-side {
    background-color: #FFFFFF;
    }
                                                    
    .small-box {height: 200px}
    
    .wrapper{
    overflow-y: hidden;}
                                                '
                                                ))),
                      shinyDashboardThemes(
                        theme = "blue_gradient"
                      ),
  tabItems(tab.1,tab.2))

# UI ------
ui <- dashboardPage(header,sidebar,body)
                    #theme = "superhero",)
