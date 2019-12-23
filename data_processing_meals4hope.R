
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