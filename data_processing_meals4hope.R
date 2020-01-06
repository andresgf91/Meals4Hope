
library(tidyverse)
library(ggplot2)
library(openxlsx)
library(readxl)
library(stringr)
library(labelled)

latest_data_download <- 'data/Formulario Nuevo Proyecto - Meals 4 Hope_19 diciembre 2019_07.30.xlsx'

data <- read_xlsx(latest_data_download,skip = 1)

data.labels <- names(data)

data <- read_xlsx(latest_data_download)

data <- data[-1,]
data <- set_variable_labels(data,.labels=data.labels)

data <- data %>%  select(-c(StartDate,`Duration (in seconds)`,RecordedDate,
                            RecipientLastName,RecipientFirstName,RecipientEmail,
                            ExternalReference,UserLanguage,Q_RecaptchaScore))

legend <- labelled::var_label(data) %>% as.data.frame() %>% t() 
legend_df <- labelled::var_label(data) %>% as.data.frame()


simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), tolower(substring(s, 2)),
        sep="", collapse=" ")
}

data$Q1 <- sapply(data$Q1, simpleCap)

library(plotly)
library(sf)
library(sp)
library(maptools)
library(rgdal)
library(plotly)
require(sf)


poly_ob <- rgdal::readOGR(dsn = "data/Maps", layer = "Estados_Venezuela")

poly_df <- fortify(model = poly_ob,data = poly_ob@data$ESTADO)

poly_df$id <- as.numeric(poly_df$id)


estado_id <- poly_ob@data
estado_id$id <- row.names(estado_id) %>% as.numeric()
estado_id <- estado_id %>% select(-ID)

poly_df <- left_join(poly_df,estado_id,by=c("id"="id"))


estado_coordy <- poly_df %>% group_by(ESTADO) %>%
  summarise(lat=mean(as.numeric(lat)),
            lon=mean(as.numeric(long)))



estado_coordy$nombre_estado <- c("Amazonas",
                                 "Anzoategui",
                                 "Apure",
                                 "Aragua",
                                 "Barinas",
                                 "Bolivar",
                                 "Carabobo",
                                 "Cojedes",
                                 "Delta Amacuro",
                                 "Distrito Capital",
                                 "Falcon",
                                 "Guarico",
                                 "Lara",
                                 "Merida",
                                 "Miranda",
                                 "Monagas",
                                 "Nueva Esparta",
                                 "Portuguesa",
                                 "Sucre",
                                 "Tachira",
                                 "Trujillo",
                                 "Vargas",
                                 "Yaracuy",
                                 "Zona en Reclamacion",
                                 "Zulia")

n_pro_df <- data %>% dplyr::group_by(Q2_1) %>% summarise(n_proyectos=n())

map_df <- left_join(estado_coordy,n_pro_df,by=c("nombre_estado"="Q2_1")) %>%
  filter(n_proyectos>0)
