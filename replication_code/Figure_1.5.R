# Description: Replication script for Figure 1.5
# Author: Laura Carreno Carrillo

# Set working directory to script folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Clean Environment
rm(list = ls(all = TRUE))
gc()

options(stringsAsFactors = F)
options(scipen=999)

# load packages
library(tidyverse)
library(openxlsx)
library(ggrepel)
library(jsonlite) # to open dataset of 150 years of patents

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 1/'

patent_300yrs.df <- read.csv(paste0(data_path, 'patents_per_year.csv'))
brit_patent.df <- read.xlsx(paste0(data_path, 'Brit_patents_app_sealed1617-1938.xlsx')) 

# Figure data frame
fig.df <-
    brit_patent.df %>%
    
    # transform the number of patents to Log
    mutate(log_app = log(applications),
           log_seal = log(sealed)) %>%
    
    # join with 300 years of British patent data
    left_join(.,
              patent_300yrs.df %>%
                  mutate(log_patent = log(patent_count)),
              by = 'year') %>%
    
    # transform to long data for easy ploting 
    pivot_longer(cols = !year,
                 names_to = 'patent_type',
                 values_to = 'patents') %>%
    
    # filter from 1750 to the end of our data set
    # filter for log numbers only
    filter(year >= 1750, grepl('log_', patent_type)) %>%
    mutate(patent_type = factor(patent_type,
                                levels = c('log_app',
                                           'log_seal',
                                           'log_patent')))


# figure 1.5
fig.df %>%
    ggplot(., aes(x = year, y = patents)) +
    geom_line(aes(linetype = patent_type)) +
   
    labs(x = '',
         y = 'Log Number of Patents',
         linetype = '') +
    scale_x_continuous(breaks = seq(1750, 1932, by = 20)) +
    scale_y_continuous(breaks = seq(0, 12, by = 2)) +
    theme_bw(base_size = 14) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank()) +
    scale_linetype_manual(values = c('dashed', 'dotted', 'solid'),
                          labels = c('Patent Applications MD62', 'Patent Sealed MD62', 'Patent Sealed BCT25')) +
    geom_vline(xintercept = 1852, linetype = 'dotted') +
    geom_vline(xintercept = 1883, linetype = 'dotted') +
    annotate('text', x = 1855.5, y = 12, label = '1852 Act', angle = -90, hjust = 0, size = 4) +
    annotate('text', x = 1885.5, y = 12, label = '1883 Act', angle = -90, hjust = 0, size = 4) +
    annotate('text', x = 1835, y = 9, label = '1851 World Fair', vjust = 0, size = 4)

ggsave(paste0(output_path, 'Figure_1.5.png'), width = 8, height = 5)
  