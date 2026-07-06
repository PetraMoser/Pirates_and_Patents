# Description: Replication script for Figure 11.2
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
library(readxl)
library(ggrepel)

# data paths and data 
data_path <- '../Data/operas/'
output_path <- '../Chapter 11/'

opera.df <- haven::read_dta(paste0(data_path, '20years.dta')) 

opera.df %>%
    mutate(treated_states = ifelse(treat == 1, 'Lombardy & Venetia', 'Other States')) %>%
    
    # Mean new operas per year
    group_by(year, treated_states) %>% 
    summarise(opera_count = n(),
              regions = n_distinct(state),
              operas_mean = opera_count/regions,
              .groups = 'drop') %>%
    ggplot(., aes(x = year,
                  y = operas_mean,
                  color = treated_states,
                  linetype = treated_states)) +
    geom_line() +
    scale_linetype_manual(values = c('Lombardy & Venetia' = 'solid', 
                                     'Other States' = 'dashed')) +
    geom_vline(xintercept = 1801, linetype = 'dashed', color = 'dimgray') +
    annotate('text',
             x = 1805.4, y = 7.7,
             label = '1801 Copyright Law',
             vjust = 1, size = 4, color = 'black') +
    theme_bw(base_size = 14) +
    scale_color_manual(values = c('#222222', '#686D76')) +
    labs(x = '',
         y = 'Mean New Operas Per Year') +
    ylim(0, 8) +
    theme(legend.position = 'bottom',
          legend.title = element_blank(),
          legend.box.background = element_rect(),
          panel.grid = element_blank(),
          axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 10))

ggsave(paste0(output_path, 'Figure_11.2.png'), width = 8, height = 6)
    
    
