# Description: Replication script for Figure 9.6
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

twea.df %>%
    group_by(grntyr, licensed_class) %>%
    summarise(patents = sum(count_germany),
              .groups = 'drop') %>%
    ggplot(., aes(x = grntyr, y = patents, 
                  color = as.factor(licensed_class),
                  linetype = as.factor(licensed_class))) +
    geom_line() +
    scale_linetype_manual(values = c('longdash', 'solid'),
                          labels = c('Fields w/o Compulsory Licenses', 
                                     'Fields with Compulsory Licenses')) +
    scale_color_grey(start = 0.5, end = 0.2,
                     labels = c('Fields w/o Compulsory Licenses', 
                                'Fields with Compulsory Licenses')) +
    scale_x_continuous(breaks = seq(1800, 1940, by = 10)) +
    scale_y_continuous(name = 'US patents',
                       breaks = seq(0, 1500, by = 100)) +
    geom_vline(xintercept = 1919, color = 'dimgray', linetype = 'dashed') +
    annotate('text', x = 1916, y = 1450, label = 'TWEA', vjust = 1, size = 4) +
    theme_bw(base_size = 12) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank()) +
    labs(x = '',
         color = '',
         linetype = '')
    

ggsave(paste0(output_path, 'Figure_9.6.png'), width = 8, height = 6)

