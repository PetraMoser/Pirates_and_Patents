# Description: Replication script for Figure 1.7
# Author: Laura Carreno Carrillo

# Set working directory to script folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Clean Environment
rm(list = ls(all = TRUE))
gc()

options(stringsAsFactors = F)
options(scipen=999)
`%nin%` <- Negate(`%in%`)

# load packages
library(tidyverse)
library(openxlsx)
library(ggrepel)

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 1/'

adoption.df <- read.xlsx(paste0(data_path, 'pat_timeline.xlsx'))

# figure 1.7
fig.df <-
    adoption.df %>%
    arrange(year) %>%
    filter(country %nin% c('Russia', 'Britain')) %>% 
    
    # create labels and positions for labels
    group_by(year) %>%
    mutate(country_lbl = paste0(country, ' (', year, ')', collapse = ' and \n'),
           country_lbl = ifelse(str_detect(country_lbl, 'Belgium'), 
                                str_remove(country_lbl, '\\(1817\\)'),
                                country_lbl),
           country_lbl = ifelse(country == 'Netherlands' & year == 1869, 'Netherlands\n(Abolished, 1869)', country_lbl)) %>%
    ungroup() %>%
    distinct(country_lbl, .keep_all = T) %>%
    
    mutate(id = match(country, unique(country)),
           # Stagger labels above/below to avoid overlap
           y_pos = rank(year, ties.method = "first") * 0.5,
           y_pos = case_when(year == 1869 & country == 'Netherlands' ~ 2.5,
                             year > 1844 & country == 'Denmark' ~ 3,
                             year > 1844 & country == 'Germany' ~ 3.5,
                             year > 1844 & country == 'Switzerland' ~ 4,
                             year > 1844 & country == 'Netherlands' ~ 4.5,
                             T ~ y_pos))


fig.df %>%
    ggplot(aes(x = year)) +
    geom_hline(yintercept = 0, color = 'grey80', linewidth = 7) +
    geom_point(aes(y = 0.15), size = 1) +
    geom_segment(aes(x = year, xend = year, y = 0.15, yend = y_pos - 0.15), 
                 color = '#44444E', linewidth = 0.3) +
    geom_label(aes(y = y_pos, label = country_lbl), size = 3.5, label.size = 0.2, fill = 'white') +
    geom_text(data = data.frame(year = seq(1780, 1920, by = 30)),
             aes(x = year, y = 0, label = year),
             size = 3.5, color = "#091413",
             inherit.aes = FALSE) +
    scale_x_continuous(limits = c(1775, 1920)) +
    labs(x = '',
         y = '') +
    theme_minimal(base_size = 11) +
    theme(legend.position = 'bottom',
          axis.ticks = element_blank(),
          panel.grid = element_blank(),
          axis.text = element_blank(),
          plot.margin = margin(0, 0, 0, 0))

ggsave(paste0(output_path, 'Figure_1.7.png'), width = 8, height = 6)
