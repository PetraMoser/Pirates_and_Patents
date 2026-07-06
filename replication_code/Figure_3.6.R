# Description: Replication script for Figure 3.6
# Author: Laura Carreno Carrillo

# Set working directory to script folder
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Clean Environment
rm(list = ls(all = TRUE))
gc()

options(stringsAsFactors = F)
options(scipen=999)

'%nin%' <- negate('%in%')

# load packages
library(tidyverse)
library(readxl)
library(ggrepel)

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 3/'

exhibit.df <- read_excel(paste0(data_path, 'rpat100513.xls'), skip = 1)

# create plot
# vector of countries to include in plot
countries <- c('France', 'Denmark', 'Switzerland', 'Prussia', 'Wurttemberg',
               'Saxony', 'US', 'Austria', 'Netherlands', 'Belgium', 'Bavaria', 
               'Norway & Sweden')

fig.df <-
    exhibit.df %>%
    # fix some country names
    mutate(country = case_when(
        country %in% c('Norswe', 'Norway', 'Sweden') ~ 'Norway & Sweden',
        T ~ country)) %>% 
    filter(year == 1851) %>% 
    group_by(country) %>% 
    summarise(pleng = mean(pleng, na.rm = T),
              pop = mean(pop, na.rm = T),
              n_exhibits = rowSums(across(starts_with('class')), na.rm = T),
              # sum across awards. These include council medals (counall), 
              # prize medals (priallz), and honorable medal (honall)
              n_awards = sum(medall),
              .groups = 'drop') %>%
    # create y-axis: Awards per 100 exhibits
    mutate(awards_p100_exhib = n_awards / (n_exhibits/ 100),
           # population is in thousands, so dividing by 1000 to transform to millions
           awards_pc = n_awards / (pop/1000))

fig.df %>%
    filter(country %in% countries) %>%
    ggplot(., aes(x = pleng, y = awards_p100_exhib, label = country)) +
    geom_point() +
    labs(x = 'Patent Length in 1851',
         y = 'Awards per 100 Exhibits') +
    theme_bw(base_size = 14) +
    theme(panel.grid = element_blank()) +
    geom_text_repel() +
    scale_x_continuous(limits = c(0, 20),
                       breaks = seq(0, 20, by = 5)) +
    scale_y_continuous(breaks = seq(10, 125, by = 5))

ggsave(paste0(output_path, 'Figure_3.6.png'), width = 8, height = 6)

# Descriptive stats ----
all_awards <-
    fig.df %>%
    filter(country %in% countries) %>%
    summarise(n_exhibits = sum(n_exhibits, na.rm = T),
              n_awards = sum(n_awards, na.rm = T),
              awards_p100_exhib = n_awards / (n_exhibits/ 100),
              pop = sum(pop, na.rm = T),
              awards_pc = n_awards / (pop/1000))
