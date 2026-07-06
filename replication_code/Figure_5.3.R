# Description: Replication script for Figure 5.3
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

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 5/'

exhibit.df <- read_excel(paste0(data_path, 'rpat100513.xls'), skip = 1)

# ========= Create data frame to replicate figure =======
countries <- c('Britain', 'Switzerland', 'Belgium', 'Saxony', 'Wurttemberg', 'Prussia', 'US',
               'France', 'Austria', 'Netherlands', 'Norway & Sweden', 'Denmark', 'Bavaria')

fig.df <-
    exhibit.df %>%
    mutate(country = case_when(country == 'Norswe' ~ 'Norway & Sweden', T ~ country),
           total_exhibits = rowSums(across(starts_with('class')), na.rm = T)) %>% 
    # filter for 1851 and for the countries we want to observe
    filter(year == 1851, country %in% countries) %>%
    # Find share of Scientific Instruments per countries
    mutate(share = round(class10 / total_exhibits, 2)) %>%
    # keep only variables for Industry Code 10 (Instruments)
    select(country, year, pleng, share)

# ========= Replicate figure =======
fig.df %>%
    ggplot(., aes(x = pleng, y = share, label = country)) +
    geom_point() +
    geom_text_repel() +
    theme_bw(base_size = 14) +
    theme(panel.grid = element_blank(),
          axis.text = element_text(color = 'black')) +
    scale_y_continuous(labels = scales::label_percent(),
                       breaks = seq(0, .3, by = .05)) +
    labs(x = 'Patent Length (in Years)',
         y = 'Share of Scientific Instruments (%)')

ggsave(paste0(output_path, 'Figure_5.3.png'), width = 8, height = 6)

# ========= Replicate Statistics =======
countries <- c('Britain', 'Switzerland', 'Belgium', 'Saxony', 'Wurttemberg', 'Prussia', 'US',
               'France', 'Austria', 'Netherlands', 'Norway & Sweden', 'Denmark', 'Bavaria')

stats.df <-
    exhibit.df %>%
    select(country, starts_with('class')) %>%
    pivot_longer(cols = !country,
                 names_to = 'class',
                 values_to = 'n') %>%
    mutate(industryclass = as.numeric(str_extract(class, '[[:digit:]]+')),
           country = case_when(country %in% c('Norswe', 'Norway') ~ 'Norway & Sweden', T ~ country)) %>%
    filter(country %in% countries) %>%
    left_join(read_dta(paste0(data_path, 'industry.dta')) %>% distinct(industryclass, ind_lbl),
               by = 'industryclass') %>%
    group_by(country, ind_lbl) %>%
    summarise(n_exhibits = sum(n, na.rm = T),
              .groups = 'drop') %>%
    group_by(country) %>%
    mutate(share = n_exhibits / sum(n_exhibits, na.rm = T)) %>%
    ungroup()
    
median <- stats.df %>% filter(ind_lbl == 'Instruments') %>% summarise(median = median(share)) %>% pull()
average <- stats.df %>% filter(ind_lbl == 'Instruments') %>% summarise(mean = mean(share)) %>% pull()

netherlands <- 
    exhibit.df %>% 
    filter(country %in% countries, year == 1876) %>% 
    mutate(dutch = ifelse(country == 'Netherlands', 1, 0),
           n_exhibits = rowSums(across(starts_with('class')), na.rm = T)) %>%
    group_by(dutch) %>%
    summarise(n_exhibits = sum(n_exhibits),
              pop = sum(pop, na.rm = T),
              .groups = 'drop') %>%
    mutate(share = n_exhibits/pop)

netherlands[2, 2]/netherlands[1, 2]
