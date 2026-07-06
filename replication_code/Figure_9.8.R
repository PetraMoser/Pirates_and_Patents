# Description: Replication script for Figure 9.8
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

twea.df <- read_dta(paste0(data_path, 'class_year.dta'))

# create df for figure
fig.df <-
    twea.df %>%
    mutate(licensed_class = ifelse(nclic == 0, 0, 1)) %>%
    group_by(year, licensed_class) %>%
    summarise(share = mean(nc_us),
              .groups = 'drop')

# Create figure
fig.df %>%
    ggplot(., aes(x = year, y = share, 
                  color = as.factor(licensed_class),
                  linetype = as.factor(licensed_class))) +
    geom_line() +
    scale_linetype_manual(values = c('longdash', 'solid'),
                          labels = c('Fields w/o Compulsory Licenses',
                                     'Fields with Compulsory Licenses')) +
    scale_shape_manual(values = c(12, 19),
                       labels = c('Fields w/o Compulsory Licenses',
                                  'Fields with Compulsory Licenses')) +
    scale_color_grey(start = 0.5, end = 0.2,
                     labels = c('Fields w/o Compulsory Licenses',
                                'Fields with Compulsory Licenses')) +
    scale_x_continuous(breaks = seq(1900, 1940, by = 5)) +
    scale_y_continuous(name = 'Average Patents per Subclass',
                       breaks = seq(0, 2, by = .2)) +
    geom_vline(xintercept = 1919, color = 'dimgray', linetype = 'dashed') +
    annotate('text', x = 1917.5, y = 1.8, label = 'TWEA', vjust = 1, size = 4) +
    theme_bw(base_size = 12) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank()) +
    labs(x = '',
         color = '',
         linetype = '')

ggsave(paste0(output_path, 'Figure_9.8.png'), width = 8, height = 6)

# Stats ====
twea.df %>%
    mutate(post = ifelse(year <= 1918, 0, 1),
           licensed_class = ifelse(nclic == 0, 0, 1)) %>%
    group_by(post, licensed_class) %>%
    summarise(share = mean(nc_us),
              .groups = 'drop')
