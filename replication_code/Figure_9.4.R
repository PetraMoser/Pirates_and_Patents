# Description: Replication script for Figure 9.4
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
output_path <- '../Chapter 9/'

twea.df <- read_dta(paste0(data_path, 'twea_data.dta')) 

# difference plot
margin_eff <-
    twea.df %>%
    mutate(n_owned = case_when(
        count_licenses == 0 ~ 'No licenses',
        count_licenses == 1 ~ '1 licenses',
        count_licenses >= 2 ~ '2 or more licenses'),
        n_owned = factor(n_owned, levels = c('No licenses',
                                             '1 licenses',
                                             '2 or more licenses'))) %>%
    group_by(grntyr, n_owned) %>%
    summarise(patent_count = sum(count_usa),
              n_subcl = n_distinct(uspto_class),
              .groups = 'drop') %>%
    mutate(patent_share = (patent_count) / n_subcl)

margin_eff %>%
    ggplot(., aes(x = grntyr, y = patent_share, 
                  color = n_owned,
                  linetype = n_owned)) +
    geom_line() +
    geom_vline(xintercept = 1919, color = 'dimgray', linetype = 'dashed') +
    annotate('text', x = 1916, y = 1.7, label = 'TWEA', vjust = 1, size = 4) +
    scale_linetype_manual(values = c('dotdash', 'dashed', 'solid')) +
    scale_color_grey(start = 0.45, end = 0.2) +
    labs(y = 'Patents per year and field',
         x = '',
         color = '',
         shape = '',
         linetype = '',
         limits = '') +
    scale_x_continuous(breaks = seq(1800, 1940, by = 10)) +
    theme_bw(base_size = 12) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank())

ggsave(paste0(output_path, 'Figure_9.4.png'), width = 7, height = 6)

# Stats =====
# Mean licensed patents by americans vs foreigners
twea.df %>%
    
    # fixing "confiscated_class" variable
    mutate(is_confiscated = ifelse(licensed_class == 1, 1, confiscated_class)) %>%
    filter(is_confiscated == 1) %>%
    summarise(mean = mean(count))
    
