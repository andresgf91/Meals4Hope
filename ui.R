
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


source('data_processing_meals4hope.R')



#-----HEADER ------ 
header <- dashboardHeader()

anchor <- tags$a(href='https://www.meals4hope.org',
                 tags$img(src='Picture2.png', height='45', width='212'))

header$children[[2]]$children <- tags$div(anchor,
                                          class = 'name')

#-----SIDEBAR------ 
sidebar <- dashboardSidebar(sidebarMenu(
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
                 fluidPage(titlePanel("General Overview"),
                           fluidRow(
                             column(
                               width = 4,
                               valueBoxOutput("n_proyectos", width = NULL),
                               valueBoxOutput("n_ninos", width = NULL),
                               valueBoxOutput("n_total_embarazadas", width = NULL),
                               valueBoxOutput("n_total_lactantes", width = NULL)
                             ),
                             column(
                               width = 8,
                               tabsetPanel(
                                 type = 'pills',
                                 tabPanel("Geografia",
                                          leafletOutput("vene_map_proyectos")),
                                 tabPanel(
                                   "Donor Contributions",
                                   tableOutput("donor_contributions"),
                                   plotlyOutput("donor_contributions_GG")
                                 ),
                                 tabPanel(
                                   title = "RETF grants overview",
                                   fluidRow(
                                     valueBoxOutput("RETF_n_grants_A"),
                                     valueBoxOutput("RETF_$_grants_A")
                                   ),
                                   fluidPage(tabsetPanel(
                                     tabPanel(title = "Trustees",
                                              plotlyOutput("RETF_trustees_A_pie", height = 450)),
                                     tabPanel(title = "Regions",
                                              plotlyOutput("RETF_region_A_pie", height = 450))
                                   ))
                                 )
                               )
                             )
                           )))

tab.2 <-  tabItem(tabName = "fichas_proyecto",
                  fluidPage(
                    titlePanel('Información General por Proyecto'),
                    fluidRow(
                      selectInput(
                        'select_project',
                        "Seleccione un proyecto:",
                        choices = sort(unique(data$Q1)),
                        width = 800
                      )),
                      
                      fluidRow(
                        column(width=3,
                               infoBoxOutput("estado", width = NULL),
                               infoBoxOutput("municipio", width = NULL),
                               infoBoxOutput("parroquia", width = NULL),
                               valueBoxOutput("coordinadora",width = NULL)),
                        column(width=2,
                               valueBoxOutput("fecha_inicio",width = NULL),
                               valueBoxOutput("n_voluntarios",width = NULL),
                               tableOutput("tipo_proyecto")),
                        column(width=2,
                      valueBoxOutput("n_beneficiarios_kids",width = NULL),
                      valueBoxOutput("n_beneficiarios_embarazadas",width=NULL),
                      valueBoxOutput("n_beneficiarios_lactantes",width=NULL))
                      
                    ))
                  )

body <- dashboardBody(tags$head(tags$style(HTML('
  .navbar-custom-menu>.navbar-nav>li>.dropdown-menu {
  width:600px;
  }
  '))),tabItems(tab.1,tab.2))

# UI ------
ui <- dashboardPage(header,sidebar,body)
