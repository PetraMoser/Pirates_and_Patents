# Description: Replication script for Figure 11.5
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
library(fastDummies)
library(haven)
library(ggplot2)


# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 11/'

dead_poets.df <- haven::read_dta(paste0(data_path, 'dat_rom_ecb_final.dta'))

# Pre-process data
remove <- c('A General Collection of the Best and Most Interesting',
            'Provincial antiquities of Scotland',
            'The British Novelists: With an Essay',
            'History of Brazil')
fig.df <-
    dead_poets.df %>%
    # filter people younger than 14 years old
    filter(age <= 14,
           year >= 1800,
           
           # remove most expensive editions
           !str_detect(title_text_old, paste0(remove, collapse = '|'))) %>%
    
    # identify dead authors
    mutate(is_dead = ifelse(year > author_death_yr, 1, 0),
           # create bin years
           year_bin = floor(year/3)*3,
           year5 = case_when(
               between(year, 1800, 1804) ~ '1800-04',
               between(year, 1805, 1809) ~ '1805-09',
               between(year, 1810, 1814) ~ '1810-14',
               between(year, 1815, 1819) ~ '1815-19',
               between(year, 1820, 1824) ~ '1820-24',
               between(year, 1825, 1829) ~ '1825-29',
               between(year, 1830, 1834) ~ '1830-34',
               between(year, 1835, 1839) ~ '1835-37',
               T ~ NA)) 

# Binned scatterplot
fig.df %>%
    ggplot(., aes(x = year, y = rawprice, color = as.factor(is_dead))) +
    stat_summary_bin() +
    scale_color_manual(values = c('#9AA6B2', '#222222'),
                      labels = c('1' = 'Dead Poets', '0' = 'Living Poets')) +
    theme_bw(base_size = 14) +
    theme(legend.position = 'bottom',
          panel.grid = element_blank()) +
    geom_vline(xintercept = 1814, linetype = 'dashed', color = 'dimgray') +
    annotate('text',
             x = 1819, y = 140,
             label = 'Copyright Act of 1814',
             vjust = 1, size = 4, color = 'black') +
    labs(x = '',
         color = '',
         fill = '',
         y = 'Raw Price')

ggsave(paste0(output_path, 'Figure_11.5.png'), width = 8, height = 6)
