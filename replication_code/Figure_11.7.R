# Description: Replication script for Figure 11.7
# Author: Laura Carreno Carrillo

# Set working directory to script folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Clean Environment
rm(list = ls(all = TRUE))
gc()

options(stringsAsFactors = F)
options(scipen=999)

'%nin%' <- Negate('%in%')

# load packages
library(tidyverse)
library(haven)
library(ggplot2)

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 11/'

books.df <- haven::read_dta(paste0(data_path, 'books_data.dta')) 

# Plot distribution of original prices and reproduction prices
fig.df <-
    books.df %>%
    filter(brp == 1) %>%
    select(year_c, p_original, p_reproduction) %>%
    pivot_longer(cols = !year_c,
                 names_to = 'type',
                 values_to = 'price') %>%
    group_by(year_c, type) %>%
        summarise(mean = mean(price, na.rm = T))
    

fig.df %>%
    ggplot(., aes(x = year_c, y = mean, fill = type)) +
    geom_bar(stat = 'identity') +
    theme_bw(base_size = 14) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank()) +
    scale_fill_manual(values = c('#9AA6B2', '#222222'),
                      labels = c('Original', 'Reproduction')) +
    labs(x = '',
         y = 'Mean Price per Year',
         fill = '')

ggsave(paste0(output_path, 'Figure_11.7.png'), width = 7, height = 6)

