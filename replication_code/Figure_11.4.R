# Description: Replication script for Figure 11.4
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
library(openxlsx)
library(cowplot)
library(ggrepel)

# data paths and data 
data_path <- '../Data/operas/'
output_path <- '../Chapter 11/'

opera.df <- haven::read_dta(paste0(data_path, 'repeated_performances140405.dta'))

# Count the years an opera was played for
prem <- opera.df %>% filter(type == 'prem') %>% filter(between(year, 1791, 1820)) %>% distinct(id) %>% pull()

fig.df <-
    opera.df %>%
    
    # keep performance years between 1781 and 1900
    # These are the performance years for operas created between 1871 and 1820
    filter(year <= 1900) %>%
    
    group_by(title) %>%
    # Count number of repetitions
    # Each row is treated as a repetition of an opera so this counts row per oper title
    summarise(n_repeat = n()-1, 
              max_life = max(longevity), # assign the oldest life-span of `longevity`
              .groups = 'drop')

fig.df %>%
    ggplot(., 
           aes(x = max_life, # oldest life-span 
               y = n_repeat)) + # number of rows per opera
    geom_col() +
    
    # format figure
    theme_bw(base_size = 14) +
    theme(panel.grid = element_blank()) +
    
    # add labels to life + n
    geom_vline(xintercept = 39.23, linetype = 'dashed') +
    geom_vline(xintercept = 41.23, linetype = 'dashed') +
    geom_vline(xintercept = 69.23, linetype = 'dashed') +
    geom_vline(xintercept = 79.23, linetype = 'dashed') +
    annotate('text', x = 33, y = 250, label = 'life + 10', vjust = 1, size = 4) +
    annotate('text', x = 47, y = 250, label = 'life + 12', vjust = 1, size = 4) +
    annotate('text', x = 64, y = 250, label = 'life + 30', vjust = 1, size = 4) +
    annotate('text', x = 85, y = 250, label = 'life + 40', vjust = 1, size = 4) +
    scale_y_continuous(breaks = seq(0, 300, by = 20)) +
    labs(x = 'Years since premiere',
         y = 'Repetitions')
    
ggsave(paste0(output_path, 'Figure_11.4.png'), width = 10, height = 8)

# Check statistics ====
mean_operas <-
    opera.df %>%
    distinct(title, .keep_all = T) %>%
    mutate(treat = ifelse(state %in% c('lombardy', 'venetia'), 1, 0),
           post = ifelse(year >= 1820, 1, 0)) %>%
    group_by(year, post, state, treat) %>% 
    summarise(opera_count = n(),
              regions = n_distinct(state),
              operas_mean = opera_count/regions,
              .groups = 'drop') %>%
    drop_na() %>%
    group_by(state, post) %>%
    summarise(mean = mean(operas_mean)) %>%
    group_by(post) %>%
    summarise(mean = mean(mean))

# Opera count ====
num_operas <-
    opera.df %>%
    mutate(type = ifelse(type == '', 
                         'other', # originally empty
                         type)) %>%
    group_by(year, type) %>%
    summarise(n_operas = n()) %>%
    group_by(year) %>%
    mutate(total_operas = sum(n_operas)) %>%
    pivot_wider(names_from = type,
                values_from = n_operas)

write_dta(num_operas, paste0(data_path, 'operas_per_year.dta'))
