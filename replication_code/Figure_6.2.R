# Description: Replication script for Figure 6.2
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
library(ggrepel)

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 6/'

stitch.df <- read_dta(paste0(data_path, 'RJE_data140123.dta'))

# Replicate figure
fig.df <-
    stitch.df %>%
    filter(between(year, 1850, 1885)) %>%
    mutate(chain = ifelse(between(subclass, 197, 202), total_count, 0),
           lock = ifelse(between(subclass, 181, 196), total_count, 0)) %>%
    
    # aggregate patents by year
    group_by(year) %>%
    summarise(chain = sum(chain),
              lock = sum(lock),
              .groups = 'drop') %>%
    
    # transform to long format
    pivot_longer(cols = !year,
                 names_to = 'stitch',
                 values_to = 'n_pat')

# plot
fig.df %>%
    ggplot(., aes(x = year, 
                  y = n_pat,
                  color = stitch,
                  linetype = stitch)) +
    geom_line() +
    theme_bw(base_size = 14) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank(),
          axis.text = element_text(color = 'black')) +
    labs(x = '', 
         y = 'Patents per stitch type and year',
         color = '', 
         linetype = '',
         shape = '') +
    scale_color_manual(values = c('#686D76', '#222222'),
                       labels = c('Chain stitch', 'Lockstitch')) +
    scale_linetype_manual(values = c('solid', 'longdash'),
                          labels = c('Chain stitch', 'Lockstitch')) +
    scale_shape_manual(values = c(1, 17),
                          labels = c('Chain stitch', 'Lockstitch')) +
    scale_x_continuous(breaks = seq(1850, 1890, by = 5)) +
    geom_vline(xintercept = 1856, linetype = 'dashed') +
    geom_text(inherit.aes = F,
              x = 1854, y = 50, 
              label = 'Pool forms',
              size = 3.5) +
    geom_vline(xintercept = 1867, linetype = 'dashed') +
    geom_text(inherit.aes = F,
              x = 1864, y = 50, 
              label = 'Lock stitch patent \nexpires',
              size = 3.5) +
    geom_vline(xintercept = 1877, linetype = 'dashed') +
    geom_text(inherit.aes = F,
              x = 1874, y = 50, 
              label = 'Last pool patent \nexpires',
              size = 3.5)

ggsave(paste0(output_path, 'Figure_6.2.png'), width = 8, height = 6)        
