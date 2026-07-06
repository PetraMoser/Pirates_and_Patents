# Description: Replication script for Figure 11.9
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
library(cowplot)

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 11/'

books.df <- haven::read_dta(paste0(data_path, 'brp_dataset.dta'))
MoS.df <- haven::read_dta(paste0(data_path, 'mos_citations.dta'))

# Create Figure on Citations to BRP Books by Emigres vs Other BRP Books
PanelA <-
    books.df %>%
    filter(brp == 1, 
           mathematics == 1,
           year_c > 1929) %>%
    group_by(year_c, emigre_us) %>%
    summarise(brp = NA,
              mean_eng = mean(count_eng, na.rm = T),
              .groups = 'drop') 

PanelB <-
    books.df %>%
    filter(emigre_us == 1,
           #mathematics == 1,
           year_c > 1929) %>%
    group_by(year_c) %>%
    summarise(emigre_us = 1,
              brp = 1,
              mean_eng = mean(count_eng, na.rm = T),
              .groups = 'drop') %>%
    rbind(MoS.df %>%
              filter(year_c > 1929, 
                     #mathematics == 1,
                     emigre_us != 0) %>%
              group_by(year_c) %>%
              summarise(emigre_us = 0,
                        brp = 0,
                        mean_eng = mean(count_eng, na.rm = T),
                        .groups = 'drop'))


PanelA.pl <-
    PanelA %>%
    ggplot(., aes(x = year_c, y = mean_eng, 
                  color = as.factor(emigre_us),
                  linetype = as.factor(emigre_us))) +
    geom_line() +
    labs(x = '', y = 'Average English Citations',
         subtitle = 'Panel A: Citations to BRP Books by Émigrés vs Other BRP Books',
         color = '',
         shape = '',
         linetype = '') +
    theme_bw(base_size = 14) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank(),
          plot.subtitle = element_text(family = 'Times New Roman', hjust = 0.5, size = 12)) +
    geom_vline(xintercept = 1942, linetype = 'dashed', color = 'dimgray') +
    scale_color_manual(values = c('#9AA6B2', '#222222'),
                       labels = c('BRP Books by US Émigrés', 'Other BRP Books')) +
    scale_linetype_manual(values = c('dashed', 'solid'),
                          labels = c('BRP Books by US Émigrés', 'Other BRP Books')) +
    scale_shape_manual(values = c(20, 18),
                       labels = c('BRP Books by US Émigrés', 'Other BRP Books'))
        

PanelB.pl <-
    PanelB %>%
    ggplot(., aes(x = year_c, y = mean_eng, 
                  color = as.factor(brp),
                  linetype = as.factor(brp))) +
    geom_line() +
    labs(x = '', y = 'Average English Citations',
         subtitle = 'Panel B: Citations to BRP Books by Émigrés vs Other Bookes by Émigrés',
         color = '',
         shape = '',
         linetype = '') +
    theme_bw(base_size = 14) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank(),
          plot.subtitle = element_text(family = 'Times New Roman', hjust = 0.5, size = 12)) +
    geom_vline(xintercept = 1942, linetype = 'dashed', color = 'dimgray') +
    scale_color_manual(values = c('#9AA6B2', '#222222'),
                       labels = c('BRP Books by US Émigrés', 'Books by other US Émigrés')) +
    scale_linetype_manual(values = c('dashed', 'solid'),
                          labels = c('BRP Books by US Émigrés', 'Books by other US Émigrés')) +
    scale_shape_manual(values = c(20, 18),
                          labels = c('BRP Books by US Émigrés', 'Books by other US Émigrés')) 


plot_grid(PanelA.pl, PanelB.pl, ncol = 1)    

ggsave(paste0(output_path, 'Figure_11.9.png'), width = 7, height = 9)
