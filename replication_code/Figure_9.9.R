# Description: Replication script for Figure 9.9
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
PanelA.df <-
    twea.df %>%
    mutate(licensed_class = ifelse(nclic == 0, 0, 1)) %>%
    group_by(year, licensed_class) %>%
    summarise(share = mean(nc),
              .groups = 'drop')

# Panel A: Fields with and without licensed Patents
PanelA.df %>%
    ggplot(., aes(x = year, y = share, 
                  color = as.factor(licensed_class),
                  linetype = as.factor(licensed_class))) +
    geom_line() +
    scale_linetype_manual(values = c('longdash', 'solid'),
                          labels = c('Fields w/o Compulsory Licenses',
                                     'Fields with Compulsory Licenses')) +
    scale_color_grey(start = 0.45, end = 0.2,
                     labels = c('Fields w/o Compulsory Licenses',
                                'Fields with Compulsory Licenses')) +
    scale_x_continuous(breaks = seq(1900, 1940, by = 5)) +
    scale_y_continuous(name = 'Average Patents per Subclass',
                       breaks = seq(0, 2, by = .2)) +
    geom_vline(xintercept = 1919, color = 'dimgray', linetype = 'dotted') +
    annotate('text', x = 1917.5, y = 20, label = 'TWEA', vjust = 1, size = 4) +
    theme_bw(base_size = 12) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank()) +
    labs(x = '',
         color = '',
         #shape = '',
         linetype = '')

ggsave(paste0(output_path, 'Figure_9.9_panelA.png'), width = 6, height = 5)

# Panel B: Quartiles of the Distribution of Licensed Patents
PanelB.df <-
    twea.df %>%
    
    # keep only licensed patents
    filter(nclic > 0) %>%
    
    # create quantiles and find averages
    mutate(q25 = quantile(nclic, 0.25, na.rm = TRUE),
           q50 = quantile(nclic, 0.50, na.rm = TRUE),
           q75 = quantile(nclic, 0.75, na.rm = TRUE),
           nclic_q = case_when(
               nclic <= q25 ~ '0 to 1 Licenses',
               nclic <= q50 ~ '2 Licenses',
               nclic <= q75 ~ '3 to 10 Licenses',
               T ~ '11 + Licenses')) %>%
    group_by(year, nclic_q) %>%
    summarise(share = mean(nc),
              .groups = 'drop') %>%
    mutate(nclic_q = factor(nclic_q,
                            levels = c('0 to 1 Licenses',
                                       '2 Licenses',
                                       '3 to 10 Licenses',
                                       '11 + Licenses')))

PanelB.df %>%
    ggplot(., aes(x = year, y = share, 
                  color = nclic_q,
                  linetype = nclic_q)) +
    geom_line() +
    scale_linetype_manual(values = c('dotted', 'dotdash', 'longdash', 'solid')) +
    scale_color_grey(start = 0.45, end = 0.2) +
    scale_x_continuous(breaks = seq(1900, 1940, by = 5)) +
    scale_y_continuous(name = 'Average Patents per Subclass',
                       breaks = seq(0, 50, by = 5)) +
    geom_vline(xintercept = 1919, color = 'dimgray', linetype = 'dotted') +
    annotate('text', x = 1917.5, y = 45, label = 'TWEA', vjust = 1, size = 4) +
    theme_bw(base_size = 12) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank()) +
    labs(x = '',
         color = '',
         linetype = '')

ggsave(paste0(output_path, 'Figure_9.9_panelB.png'), width = 6, height = 5)

# Stats ====
# check quantiles
quantile(twea.df$nclic[twea.df$nclic > 0],
         probs = c(.25, .50, .75),
         na.rm = TRUE)

