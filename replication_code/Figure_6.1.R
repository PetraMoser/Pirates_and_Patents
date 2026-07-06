# Description: Replication script for Figure 6.1
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
library(readxl)
library(ggrepel)

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 6/'

patents.df <- read_excel(paste0(data_path, 'sewing_machines906022.xls'), sheet = 'Tab sm pat total pat')

# Replicate figure
fig.df <-
    patents.df %>%
    select(Year,`British Proportion (less attachments and tables)...6`,
           `US Proportion (less attachments and tables)`) %>%
    # make it long format for easier plotting 
    pivot_longer(cols = c('British Proportion (less attachments and tables)...6',
                          'US Proportion (less attachments and tables)'),
                 names_to = 'country',
                 values_to = 'share') %>%
    mutate(country = ifelse(str_detect(country, 'British'), 'Britain', 'United States'),
           share = as.numeric(share),
           year = as.numeric(Year)) %>%
    slice(3:n())

# plot
fig.df %>%
    ggplot(., aes(x = year, 
                  y = share,
                  #shape = country,
                  color = country,
                  group = country, # ggplot was having problems grouping
                  linetype = country)) +
    geom_line() +
    #geom_point() +
    theme_bw(base_size = 14) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank(),
          axis.text = element_text(color = 'black')) +
    labs(x = '', y = '', color = '', linetype = '', shape = '') +
    scale_color_manual(values = c('#686D76', '#222222')) +
    scale_linetype_manual(values = c('longdash', 'solid')) +
    scale_shape_manual(values = c(22, 20)) +
    geom_vline(xintercept = 1856, linetype = 'dotted') +
    geom_text(inherit.aes = F,
              x = 1852.5, y = 0.025, 
              label = 'October 24, 1856:\n Albany Agreement',
              size = 3) +
    scale_x_continuous(breaks = seq(1850, 1890, by = 5)) +
    scale_y_continuous(labels = scales::label_percent(),
                       breaks = seq(0, .03, by = .005)) +
    geom_vline(xintercept = 1877, linetype = 'dotted') +
    geom_text(inherit.aes = F,
              x = 1879.5, y = 0.025, 
              label = 'May 8, 1877:\n Pool Dissolved',
              size = 3)

ggsave(paste0(output_path, 'Figure_6.1.png'), width = 8, height = 6)        
