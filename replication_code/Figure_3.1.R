# Description: Replication script for Figure 3.1
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
library(ggrepel)

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 3/'

fig.df <-
    read_excel(paste0(data_path, 'rpat100513.xls'), skip = 1) %>% 
    # sum all exhibit rows
    # returns total number of exhibits per country per year
    mutate(n_exhibits = rowSums(across(starts_with('class')), na.rm = T)) %>%
    # fix typos
    mutate(country = case_when(
        country == 'Norswe' ~ 'Norway & Sweden',
        T ~ country)) %>%
    # compute exhibits per capita
    # population is in thousands, so multiplying by 1000 to transform to millions
    mutate(exhibit_pc = (n_exhibits / pop)*1000) 

country_1851 <- c('Switzerland', 'Belgium', 'Saxony', 'Wurttemberg', 'Prussia', 'France', 
                  'Austria', 'Netherlands', 'Norway & Sweden', 'Denmark','US', 'Bavaria')
   
country_1876 <- c('Norway', 'Switzerland', 'Sweden', 'Austria', 'Denmark',
                  'France', 'Britain', 'Germany', 'Netherlands')

# create plot
fig.df %>%
    # keep countries in figures
    filter((year == 1851 & country %in% country_1851) |
    (year == 1876 & country %in% country_1876)) %>%
    ggplot(., aes(x = pleng, y = exhibit_pc, label = country)) +
    geom_point() +
    facet_wrap(. ~ year) +
    labs(x = 'Patent Length (in Years)',
         y = 'Exhibits per 1 Million Population') +
    theme_bw(base_size = 14) +
    theme(panel.grid = element_blank(),
          strip.background = element_rect(fill = 'white', color = NA),
          strip.text = element_text(size = 12, face = 'plain')) +
    geom_text_repel() +
    scale_y_continuous(limits = c(15, 160),
                       breaks = seq(20, 160, by = 20)) +
    scale_x_continuous(breaks = seq(0, 20, by = 5),
                       limits = c(0, 20))

ggsave(paste0(output_path, 'Figure_3.1.png'), width = 8, height = 6)

# ======== Stats ============
stats <- 
    fig.df %>%
    filter(country %in% country_1851, year == 1851) %>%
    summarise(mean = mean(exhibit_pc)) %>%
    pull(mean)
  