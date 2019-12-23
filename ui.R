
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


setwd("~/Meals4Hope/R_code/Meals_4_Hope")
source('~/Meals4Hope/R_code/Meals_4_Hope/data_processing_meals4hope.R')



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

tab.2 <-  tabItem(tabName = "fichas_proyecto",
                  fluidPage(
                    titlePanel('Información General por Proyecto'),
                    fluidRow(
                      selectInput(
                        'select_project',
                        "Seleccione un proyecto:",
                        choices = sort(unique(data$Q1)),
                        width = 800
                      ),
                      infoBoxOutput("estado", width = 3),
                      infoBoxOutput("municipio", width = 3),
                      infoBoxOutput("parroquia", width = 3),
                      valueBoxOutput("fecha_inicio",width = 2),
                      valueBoxOutput("n_voluntarios",width = 2),
                      textOutput("tipo_proyecto")
                      
                    )
                  ))

body <- dashboardBody(tags$head(tags$style(HTML('
  .navbar-custom-menu>.navbar-nav>li>.dropdown-menu {
  width:600px;
  }
  '))),tabItems(tab.2))

# UI ------
ui <- dashboardPage(header,sidebar,body)
