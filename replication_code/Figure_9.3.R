# Description: Replication script for Figure 9.3
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

fig.df <-
    twea.df %>%
    
    group_by(grntyr, licensed_class) %>%
    # Mean patents across subclasses with licenses
    summarise(patents = mean(count), 
              .groups = 'drop') 

fig.df %>%
    ggplot(., aes(x = grntyr, y = patents, 
                  color = as.factor(licensed_class),
                  #shape = as.factor(licensed_class),
                  linetype = as.factor(licensed_class))) +
    geom_line() +
    #geom_point() +
    theme_bw(base_size = 12) +
    labs(x = '',
         y = 'Patents per year and field',
         color = '',
         shape = '',
         linetype = '') +
    theme(legend.position = 'bottom',
          panel.grid = element_blank()) +
    geom_vline(xintercept = 1919, color = 'dimgray', linetype = 'dotted') +
    annotate('text', x = 1916, y = 2.9, label = 'TWEA', vjust = 1, size = 4) +
    scale_x_continuous(breaks = seq(1800, 1940, by = 10)) +
    scale_color_manual(values = c('#686D76', '#25343F'),
                       labels = c('Fields w/o Compulsory Licenses', 
                                  'Fields with Compulsory Licenses')) +
    scale_linetype_manual(values = c('longdash', 'solid'),
                          labels = c('Fields w/o Compulsory Licenses', 
                                     'Fields with Compulsory Licenses')) +
    scale_shape_manual(values = c(5, 19),
                       labels = c('Fields w/o Compulsory Licenses', 
                                  'Fields with Compulsory Licenses'))

ggsave(paste0(output_path, 'Figure_9.3.png'), width = 8, height = 6)            
