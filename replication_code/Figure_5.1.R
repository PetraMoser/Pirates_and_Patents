# Description: Replication script for Figure 5.1
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

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 5/'

US.df <- read_excel(paste0(data_path, 'usa1851_JO90724.xls')) 
britain.df <- read_excel(paste0(data_path, 'Britain1851.xls')) 
industry_labels.df <- read_dta(paste0(data_path, 'industry.dta'))

# ================ Patents by Industry ================
# Obtain totals and shares for city size By country by industry
patent_country.df <-
    britain.df %>%
    # join with industry labels
    left_join(.,
              industry_labels.df,
              by = 'industryclass') %>%
    filter(!is.na(ind_lbl)) %>%            # filter industries with NA
    mutate(
        # assess which exhibits were patents
        patented = ifelse(!is.na(reference_to_patent), 1, 0),
        country = 'All British Exhibits') %>%
    select(ind_lbl, country, patented) %>%
    
    # join with US data
    rbind(., 
          US.df %>%
              # join with industry labels
              left_join(.,
                        industry_labels.df,
                        by = c('Industry' = 'industryclass')) %>%
              rename('patented' = 'Patented') %>%
              mutate(country = 'All US Exhibits') %>%
              filter(!is.na(ind_lbl)) %>%    # filter industries with NA
              select(ind_lbl, country, patented)) %>%
    mutate(ind_lbl = ifelse(ind_lbl == 'Manufacturing Machinery', 'Manufacturing \n Machinery', ind_lbl))


# ================ Patenting Rates by Industry ================
# Obtain totals and shares for city size by exhibits by industry
patent_exhibit.df <-
    britain.df %>%
    
    # join with industry labels
    left_join(.,
              industry_labels.df,
              by = 'industryclass') %>%
    filter(!is.na(ind_lbl)) %>% # filter industries with NA
    
    # assess which exhibits were patented and award-winners
    mutate(patented = ifelse(!is.na(reference_to_patent), 1, 0),
           award = ifelse(!is.na(award), 1, 0),
           ind_lbl = ifelse(ind_lbl == 'Manufacturing Machinery', 'Manufacturing \n Machinery', ind_lbl)) 

# ============== Coeficient Plots ==============
# Panel A
patent_country.df %>%
    ggplot(., aes(x = patented, y = reorder(ind_lbl, patented), color = country)) +
    stat_summary_bin(position = position_dodge(width = 0.5)) +
    theme_bw(base_size = 12) +
    labs(#subtitle = 'Panel A: Patent Use by Industry in 1851, United States vs. Britain',
         x = 'Patented Exhibits / All Exhibits',
         y = '',
         color = '') +
    theme(legend.position = c(.8, .1),
          plot.subtitle = element_text(family = "Times New Roman",
                                       hjust = 0.5,
                                       size = 14),
          legend.background = element_rect(color = 'black', size = 0.5),
          panel.grid = element_blank(),
          legend.margin = margin(-4, 8, 6, 8),
          axis.text = element_text(color = 'black')) +
    scale_color_manual(values = c('#58A0C8', '#003161')) +
    scale_x_continuous(breaks = seq(0, 1, by = 0.1))

ggsave(paste0(output_path, 'Figure_5.1_PanelA.png'), width = 7, height = 5)

# Panel B 
pos <- position_dodge(width = 0.4)

patent_exhibit.df %>%
    select(ind_lbl, patented) %>%
    ggplot(., aes(x = patented, y = reorder(ind_lbl, patented), color = 'All Exhibits')) +
    stat_summary_bin() +
    stat_summary_bin( data = patent_exhibit.df %>% 
                          filter(award == 1) %>%
                          select(ind_lbl, patented),
                      aes(x = patented, y = ind_lbl, color = 'Award-Winning Exhibits')) +
    scale_color_manual(values = c('#58A0C8', '#003161'),
                       labels = c('All British Exhibits', 'Award-Winning British Exhibits')) +
    theme_bw(base_size = 12) +
    theme(legend.position = c(.75, .1),
          plot.subtitle = element_text(family = "Times New Roman",
                                       hjust = 0.5,
                                       size = 14),
          legend.background = element_rect(color = 'black', size = 0.5),
          legend.margin = margin(-4, 8, 6, 8),
          panel.grid = element_blank(),
          #axis.ticks.y = element_blank(),
          axis.text = element_text(color = 'black')) +
    scale_x_continuous(breaks = seq(0, 1, by = 0.1)) +
    labs(#subtitle = 'Panel B: Patent Use by Industry in 1851, British Exhibits',
         x = 'Rate of Patenting',
         color = '',
         y = '')

ggsave(paste0(output_path, 'Figure_5.1_PanelB.png'), width = 7, height = 5)

# Statistics ====
patent_country.df %>%
    group_by(country, ind_lbl) %>%
    summarise(share = mean(patented))

patent_country.df %>%
    group_by(country) %>%
    summarise(share = mean(patented))

patent_exhibit.df %>%
    filter(award == 1) %>%
    group_by(ind_lbl) %>%
    summarise(share = mean(patented))


