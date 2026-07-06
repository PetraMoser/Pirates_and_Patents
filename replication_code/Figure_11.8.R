# Description: Replication script for Figure 11.8
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
library(MatchIt)
library(cowplot)

# data paths and data 
data_path <- '../Data/'
output_path <- '../Chapter 11/'

books.df <- haven::read_dta(paste0(data_path, 'books_data.dta')) 

# plot by year
panelA <-
    books.df %>%
    filter(brp == 1)%>%
    group_by(year_c) %>%
    summarise(English = sum(count_eng)/n(),
              Other = sum(count_noeng)/n()) %>%
    ggplot(., aes(x = year_c)) +
    geom_line(aes(y = English, linetype = 'English'), color = '#9AA6B2', size = 0.5) +
    geom_line(aes(y = Other, linetype = 'Other Language'), color = '#222222', size = 0.5) +
    geom_vline(xintercept = 1942, linetype = 'longdash', color = 'dimgray') +
    labs(subtitle = 'Panel A: Citations to BRP Books from New Work in English \n versus Other Languages',
         x = '',
         y = 'No. of citations',
         color = '') +
    annotate('text', x = 1942, y = 0.8, label = '1942 BRP', vjust = 1, hjust = 0) +
    scale_linetype_manual(name = '', 
                          values = c('English' = 'solid', 'Other Language' = 'longdash'), 
                          labels = c('English', 'Other Language')) +
    xlim(1930, 1970) +
    theme_bw() +
    theme(legend.position = 'bottom', legend.text = element_text(size = 10),
          panel.grid = element_blank(),
          plot.subtitle = element_text(family = 'Times New Roman', hjust = 0.5, size = 12))

# PSM Plot
pscore.df <- 
    books.df %>%
    filter(brp == 0 | brp == 1) %>%
    group_by(id, year_c)  %>%
    summarise(count_eng = sum(count_eng),
              count_noeng = sum(count_noeng),
              brp = first(brp),
              field = first(field),
              brp = first(brp),
              pre = 1 - post,
              .groups = 'drop')  %>%
    group_by(id, pre) %>%
    mutate(count_noeng_pre = sum(count_noeng),
           field = as.factor(field)) %>%
    arrange(-pre) %>%
    group_by(id)  %>%
    summarise(count_noeng_pre = first(count_noeng_pre),
              field = first(field),
              brp = first(brp),
              .groups = 'drop') %>%
    filter(field != '')

m_pscore <- glm(brp ~ field + count_noeng_pre,
                family = binomial(), 
                data = pscore.df)

pscore_pred <- 
    predict(m_pscore, type = 'response') %>%
    as.data.frame() %>%
    mutate(brp = m_pscore$model$brp,
           id = pscore.df$id)

mod_match <- matchit(brp ~ field + count_noeng_pre,
                     distance = 'mahalanobis', 
                     exact = 'field',
                     data = pscore.df,
                     replace = TRUE)

data_matched <- get_matches(mod_match, id = 'id2') %>% arrange(subclass)

matched.df <- 
    books.df %>%
    mutate(match = ifelse(id %in% data_matched$id, 1,0 )) %>%
    filter(year_c >= 1930, match == 1)

# Matched figure
panelB <-
    matched.df %>%
    group_by(year_c, brp) %>%
    summarise(total_eng = sum(count_eng),
              total = n(),
              share_eng_cit = total_eng / total,
              mean_eng_cit = mean(share_eng_cit),
              .groups = 'drop') %>%
    mutate(brp = ifelse(brp == 1, 'BRP', 'Swiss')) %>%
    ggplot(., aes(x = year_c, 
                  y = mean_eng_cit, 
                  color = brp,
                  linetype = brp)) +
    geom_line() +
    theme_bw() +
    labs(subtitle = 'Panel B: Citations to a Matched Sample of BRP and Swiss Books',
         x = '',
         y = 'No. of citations',
         color = '',
         linetype = '') +
    theme(legend.position = 'bottom',
          panel.grid = element_blank(),
          plot.subtitle = element_text(family = 'Times New Roman', hjust = 0.5, size = 12)) +
    scale_color_manual(values = c('#9AA6B2', '#222222')) +
    geom_vline(xintercept = 1942, linetype = 'dashed', color = 'dimgray') +
    scale_linetype_manual(name = '', 
                          values = c('BRP' = 'solid', 'Swiss' = 'longdash'), 
                          labels = c('BRP', 'Swiss')) +
    annotate('text', x = 1942, y = 0.8, label = '1942 BRP', vjust = 1, hjust = 0)

plot_grid(panelA, panelB, ncol = 1)

ggsave(paste0(output_path, 'Figure_11.8.png'), width = 6, height = 8)

