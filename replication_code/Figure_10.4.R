# Description: Replication script for Figure 10.4
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
data_path <- '../Data/ppa/'
output_path <- '../Chapter 10/'

ppa.df <- read_dta(paste0(data_path, 'PlantPat_DateMerge.dta'))

# create df for figures
fig.df <-
    ppa.df %>%
    mutate_if(is.character, tolower) %>% 
    
    # filter from 1930 to 1970
    filter(between(year, 1930, 1970)) %>% 
    group_by(year) %>%
    summarise(n_all = n(),
              n_rose = sum(rose == 1),
              .groups = 'drop') %>%
    pivot_longer(cols = !year,
                 names_to = 'n_type',
                 values_to = 'n_patents')


fig.df %>%
    ggplot(., aes(x = year, y = n_patents, 
                  linetype = n_type)) +
    geom_line() +
    scale_linetype_manual(values = c('longdash', 'solid'),
                          labels = c('All Plants', 'Roses')) +
    theme_bw(base_size = 12) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank()) +
    labs(x = '',
         y = 'Number of Patents per Year',
         linetype = '')

ggsave(paste0(output_path, 'Figure_10.4.png'), width = 6, height = 5)
