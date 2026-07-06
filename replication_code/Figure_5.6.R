# Description: Replication script for Figure 5.6
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
library(haven)
library(ggrepel)
library(ggalt)

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 5/'

innovations.df <- read_excel(paste0(data_path, 'rpat509rep.xls'))

# ========= Create data frame to replicate figure =======
fig.df <-
    innovations.df %>%
    filter(country == 'Netherlands') %>%
    
    # long format for industry
    pivot_longer(cols = c('mining', 'chemicals', 'food', 'mach', 'scinst', 'textiles', 'manu'),
                 names_to = 'industry',
                 values_to = 'n_exhibits') %>%
    
    # variables of insterest 
    group_by(year) %>%
    transmute(industry = industry,
              share = round(n_exhibits/ sum(n_exhibits), 3)) %>%
    ungroup() %>%
    
    # fix labels
    mutate(industry = case_when(
        industry == 'chemicals' ~ 'Chemicals',
        industry == 'food' ~ 'Food',
        industry == 'mach' ~ 'Machinery',
        industry == 'manu' ~ 'Manufactures',
        industry == 'mining' ~ 'Minining',
        industry == 'scinst' ~ 'Instruments',
        industry == 'textiles' ~ 'Textiles'))
    
# ========= Replicate figure =======
fig.df %>%
    ggplot(., aes(x = industry, 
                  y = share, 
                  fill = as.factor(year),
                  color = as.factor(year),
                  label = share)) +
    geom_col(position = 'dodge') +
    geom_text(aes(label = scales::percent(share)),
              position = position_dodge(width = 0.9),
              vjust = -0.2,   # nudge labels just above bar
              size = 3.5,
              show.legend = FALSE) +
    theme_bw(base_size = 14) +
    theme(panel.grid = element_blank(),
          legend.position = 'bottom',
          axis.text.x = element_text(angle = 10)) +
    scale_y_continuous(labels = scales::label_percent(),
                       breaks = seq(0, .4, by = .05)) +
    scale_fill_manual(values = c('#37353E', '#708993')) +
    scale_color_manual(values = c('#000000', '#3F4F44')) +
    labs(x = '',
         y = 'Share of Exhibits (%)',
         color = '',
         fill = '')

ggsave(paste0(output_path, 'Figure_5.6.png'), width = 8, height = 6)
